package display.containers;

import flash.display.DisplayObject;
import flash.display.Shape;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;


class DefaultLayoutContainerTest {
    private var _layoutContainer: DefaultLayoutContainer;
    private var _container: Container;

    public function new() {

    }

    @Before
    public function setup():Void {
        _container = new Container();
        _layoutContainer = new DefaultLayoutContainer(_container);
    }

    @After
    public function tearDown():Void {
        _container = null;
        _layoutContainer = null;
    }


    @Test
    public function shouldSetHaveDefaultLayoutPolicyToHorizontalAndCanBeSet(): Void {
        Assert.areEqual(LayoutPolicy.HORIZONTAL_LAYOUT, _layoutContainer.layoutPolicy);
        _layoutContainer.layoutPolicy = LayoutPolicy.VERTICAL_LAYOUT;
        Assert.areEqual(LayoutPolicy.VERTICAL_LAYOUT, _layoutContainer.layoutPolicy);
    }

    @Test
    public function shouldOnlyChangeIfSetToValidValue(): Void {
        Assert.areEqual(LayoutPolicy.HORIZONTAL_LAYOUT, _layoutContainer.layoutPolicy);
        _layoutContainer.layoutPolicy = "wrong";
        Assert.areEqual(LayoutPolicy.HORIZONTAL_LAYOUT, _layoutContainer.layoutPolicy);
        _layoutContainer.layoutPolicy = LayoutPolicy.VERTICAL_LAYOUT;
        Assert.areEqual(LayoutPolicy.VERTICAL_LAYOUT, _layoutContainer.layoutPolicy);
        _layoutContainer.layoutPolicy = "wrong again";
        Assert.areEqual(LayoutPolicy.VERTICAL_LAYOUT, _layoutContainer.layoutPolicy);
    }

    @Test
    public function shouldDispatchLayoutRefreshEventWhenChangingLayoutPolicy(): Void {
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;
            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);
            Assert.isTrue(true);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _layoutContainer.layoutPolicy = LayoutPolicy.VERTICAL_LAYOUT;
        Assert.isTrue(cbCalled);
    }

    @Test
    public function byDefaultTheItemsShouldLayoutHorizontallyByChildWidth(): Void {
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;
            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(100, _container.getChildAt(1).x);
            Assert.areEqual(110, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(0, _container.getChildAt(1).y);
            Assert.areEqual(0, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldRefreshHorizontalLayoutWhenContainerChanges(): Void {
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;
            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(100, _container.getChildAt(1).x);
            Assert.areEqual(110, _container.getChildAt(2).x);
            Assert.areEqual(160, _container.getChildAt(3).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(0, _container.getChildAt(1).y);
            Assert.areEqual(0, _container.getChildAt(2).y);
            Assert.areEqual(0, _container.getChildAt(3).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _container.addChild(getDisplayObject(50, 50));
        Assert.isTrue(cbCalled);
    }

    @Test
    public function byDefaultTheItemsShouldLayoutHorizontallyByChildWidthAndIgnoreTheXButKeepTheY(): Void {
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;

            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(100, _container.getChildAt(1).x);
            Assert.areEqual(110, _container.getChildAt(2).x);

            Assert.areEqual(343, _container.getChildAt(0).y);
            Assert.areEqual(325, _container.getChildAt(1).y);
            Assert.areEqual(34, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100, 134, 343));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10,432, 325));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50, 3432, 34));

        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function itemsShouldLayoutVerticallyIfSetToVerticalLayout(): Void {
        _layoutContainer.layoutPolicy = LayoutPolicy.VERTICAL_LAYOUT;
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;
            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(0, _container.getChildAt(1).x);
            Assert.areEqual(0, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(100, _container.getChildAt(1).y);
            Assert.areEqual(110, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldRefreshVerticalLayoutWhenContainerChanges(): Void {
        _layoutContainer.layoutPolicy = LayoutPolicy.VERTICAL_LAYOUT;
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;

            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(0, _container.getChildAt(1).x);
            Assert.areEqual(0, _container.getChildAt(2).x);
            Assert.areEqual(0, _container.getChildAt(3).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(100, _container.getChildAt(1).y);
            Assert.areEqual(110, _container.getChildAt(2).y);
            Assert.areEqual(160, _container.getChildAt(3).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _container.addChild(getDisplayObject(50, 50));
        Assert.isTrue(cbCalled);
    }

    @Test
    public function theItemsShouldLayoutVerticallyByChildHeightAndIgnoreTheYButKeepTheX(): Void {
        _layoutContainer.layoutPolicy = LayoutPolicy.VERTICAL_LAYOUT;
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;

            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(134, _container.getChildAt(0).x);
            Assert.areEqual(432, _container.getChildAt(1).x);
            Assert.areEqual(3432, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(100, _container.getChildAt(1).y);
            Assert.areEqual(110, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100, 134, 343));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10,432, 325));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50, 3432, 34));

        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldLayoutItemsHorizontallyAndAddAGapBetweenItems(): Void {
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;

            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(110, _container.getChildAt(1).x);
            Assert.areEqual(130, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(0, _container.getChildAt(1).y);
            Assert.areEqual(0, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _layoutContainer.gap = 10;
        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldLayoutItemsVerticallyAndAddAGapBetweenItems(): Void {
        _layoutContainer.layoutPolicy = LayoutPolicy.VERTICAL_LAYOUT;
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;

            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(0, _container.getChildAt(1).x);
            Assert.areEqual(0, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(110, _container.getChildAt(1).y);
            Assert.areEqual(130, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _layoutContainer.gap = 10;
        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);

    }

    @Test
    public function shouldRefreshLayoutWhenChangingTheGap(): Void {
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;

            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(110, _container.getChildAt(1).x);
            Assert.areEqual(130, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(0, _container.getChildAt(1).y);
            Assert.areEqual(0, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _layoutContainer.gap = 10;
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldEnforceCellWidthWhenLayingOutHorizontally(): Void {
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;
            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(40, _container.getChildAt(1).x);
            Assert.areEqual(80, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(0, _container.getChildAt(1).y);
            Assert.areEqual(0, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _layoutContainer.cellWidth = 40;
        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldEnforceCellHeightWhenLayingOutVertically(): Void {
        _layoutContainer.layoutPolicy = LayoutPolicy.VERTICAL_LAYOUT;
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;
            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(0, _container.getChildAt(1).x);
            Assert.areEqual(0, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(40, _container.getChildAt(1).y);
            Assert.areEqual(80, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _layoutContainer.cellHeight = 40;
        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldEnforceCellWidthWhenLayingOutHorizontallyAndAddGap(): Void {
        _layoutContainer.gap = 10;
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;
            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(50, _container.getChildAt(1).x);
            Assert.areEqual(100, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(0, _container.getChildAt(1).y);
            Assert.areEqual(0, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _layoutContainer.cellWidth = 40;
        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldEnforceCellHeightWhenLayingOutVerticallyAndAddGap(): Void {
        _layoutContainer.layoutPolicy = LayoutPolicy.VERTICAL_LAYOUT;
        _layoutContainer.gap = 10;
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;
            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(0, _container.getChildAt(1).x);
            Assert.areEqual(0, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(50, _container.getChildAt(1).y);
            Assert.areEqual(100, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _layoutContainer.cellHeight = 40;
        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldDispatchLayoutRefreshWhenCellWidthChanges(): Void {
        _layoutContainer.gap = 10;
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;
            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(50, _container.getChildAt(1).x);
            Assert.areEqual(100, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(0, _container.getChildAt(1).y);
            Assert.areEqual(0, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _layoutContainer.cellWidth = 40;
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldDispatchLayoutRefreshWhenCellHeightChanges(): Void {
        _layoutContainer.layoutPolicy = LayoutPolicy.VERTICAL_LAYOUT;
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;
            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(0, _container.getChildAt(1).x);
            Assert.areEqual(0, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(40, _container.getChildAt(1).y);
            Assert.areEqual(80, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50));

        _layoutContainer.cellHeight = 40;
        Assert.isTrue(cbCalled);
    }

    @Test
    public function byDefaultTheItemsShouldLayoutHorizontallyByChildWidthAndIgnoreTheXAndYIfOverwriteIsSetToTrue(): Void {
        _layoutContainer.overwritePlacement = true;
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;
            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(100, _container.getChildAt(1).x);
            Assert.areEqual(110, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(0, _container.getChildAt(1).y);
            Assert.areEqual(0, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100, 134, 343));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10,432, 325));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50, 3432, 34));

        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function byDefaultTheItemsShouldLayoutVerticallyByChildWidthAndIgnoreTheXAndYIfOverwriteIsSetToTrue(): Void {
        _layoutContainer.overwritePlacement = true;
        _layoutContainer.layoutPolicy = LayoutPolicy.VERTICAL_LAYOUT;
        var cbCalled: Bool = false;
        var handler: LayoutEvent->Void = null;
        handler = function(le: LayoutEvent): Void {
            cbCalled = true;
            _layoutContainer.removeEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

            Assert.areEqual(0, _container.getChildAt(0).x);
            Assert.areEqual(0, _container.getChildAt(1).x);
            Assert.areEqual(0, _container.getChildAt(2).x);

            Assert.areEqual(0, _container.getChildAt(0).y);
            Assert.areEqual(100, _container.getChildAt(1).y);
            Assert.areEqual(110, _container.getChildAt(2).y);
        }
        _layoutContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, handler);

        _container.rawChildContainer.addChild(getDisplayObject(100, 100, 134, 343));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10,432, 325));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50, 3432, 34));

        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldNotifyTheContainerToRecalculateBoundsIfRefreshed(): Void {
        var cbCalled: Bool = false;
        _container.addEventListener(ContainerEvent.RECALCULATE_BOUNDS, function(ce: ContainerEvent): Void {
            cbCalled = true;
        });

        _container.rawChildContainer.addChild(getDisplayObject(100, 100, 134, 343));
        _container.rawChildContainer.addChild(getDisplayObject(10, 10,432, 325));
        _container.rawChildContainer.addChild(getDisplayObject(50, 50, 3432, 34));

        _layoutContainer.refresh();
        Assert.isTrue(cbCalled);
    }

    private inline function getDisplayObject(width: Float, height: Float, x: Float = 0, y: Float = 0): DisplayObject {
        var retVal: Shape = new Shape();
        retVal.graphics.beginFill(0);
        retVal.graphics.drawRect(0,0,width, height);
        retVal.graphics.endFill();
        retVal.x = x;
        retVal.y = y;
        return retVal;
    }
}