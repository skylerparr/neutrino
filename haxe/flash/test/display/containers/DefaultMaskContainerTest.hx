package display.containers;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;


class DefaultMaskContainerTest {
    private var _maskContainer: DefaultMaskContainer;
    private var _container: Container;

    public function new() {

    }

    @Before
    public function setup():Void {
        _container = new Container();
        _maskContainer = new DefaultMaskContainer(_container);
    }

    @After
    public function tearDown():Void {
        _maskContainer = null;
        _container = null;
    }
    @Test
    public function shouldApplyMaskToContainer(): Void {
        Assert.isNotNull(_container.mask);
    }

    @Test
    public function shouldApplyOverridingMask(): Void {
        Assert.isNotNull(_container.mask);

        var newMask: Sprite = new Sprite();
        _maskContainer.maskDisplay = newMask;
        Assert.areEqual(newMask, _container.mask);
    }

    @Test
    public function shouldOverrideTheDefaultMaskHeight(): Void {
        _container.graphics.beginFill(0);
        _container.graphics.drawRect(0,0,200,200);
        _container.graphics.endFill();
        _maskContainer = new DefaultMaskContainer(_container);
        Assert.areEqual(0, _maskContainer.displayHeight);

        _maskContainer.displayHeight = 100;
        Assert.areEqual(100, _maskContainer.displayHeight);

        Assert.areEqual(100, _container.mask.height);
    }

    @Test
    public function shouldOverrideTheDefaultMaskWidth(): Void {
        _container.graphics.beginFill(0);
        _container.graphics.drawRect(0,0,200,200);
        _container.graphics.endFill();
        _maskContainer = new DefaultMaskContainer(_container);
        Assert.areEqual(0, _maskContainer.displayWidth);

        _maskContainer.displayWidth = 100;
        Assert.areEqual(100, _maskContainer.displayWidth);

        Assert.areEqual(100, _container.mask.width);
    }

    @Test
    public function shouldSetTheXPosition(): Void {
        Assert.areEqual(0, _maskContainer.displayX);

        _maskContainer.displayX = 100;
        Assert.areEqual(100, _maskContainer.displayX);

        Assert.areEqual(100, _container.mask.x);

    }

    @Test
    public function shouldSetTheYPosition(): Void {
        Assert.areEqual(0, _maskContainer.displayY);

        _maskContainer.displayY = 100;
        Assert.areEqual(100, _maskContainer.displayY);

        Assert.areEqual(100, _container.mask.y);

    }

    @Test
    public function shouldDispatchLayoutRefreshWhenContainerChildrenChange(): Void {
        var cbCalled: Bool = false;
        _maskContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, function(le: LayoutEvent): Void {
            cbCalled = true;
        });

        _container.addChild(getDisplayObject(100, 200));
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldResetMaskBoundsToMatchContainerBoundsIfNotExplicitlySet(): Void {
        var cbCalled: Bool = false;

        var disp: Shape = cast getDisplayObject(100, 200);
        _container.addChild(disp);

        _maskContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, function(le: LayoutEvent): Void {
            cbCalled = true;
        });

        disp.graphics.beginFill(0);
        disp.graphics.drawRect(0,0,200, 300);
        disp.graphics.endFill();

        _container.recalculateBounds();
        Assert.isTrue(cbCalled);
        Assert.areEqual(200, _maskContainer.maskDisplay.width);
        Assert.areEqual(300, _maskContainer.maskDisplay.height);
    }

    @Test
    public function shouldNotResetMaskBoundsToMatchContainerBoundsIfExplicitlySet(): Void {
        var cbCalled: Bool = false;
        var disp: Shape = cast getDisplayObject(100, 200);
        _container.addChild(disp);

        _maskContainer.displayWidth = 10;
        _maskContainer.displayHeight = 10;

        disp.graphics.beginFill(0);
        disp.graphics.drawRect(0,0,200, 300);
        disp.graphics.endFill();

        _maskContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, function(le: LayoutEvent): Void {
            cbCalled = true;
        });


        _container.recalculateBounds();
        Assert.isTrue(cbCalled);
        Assert.areEqual(10, _maskContainer.maskDisplay.width);
        Assert.areEqual(10, _maskContainer.maskDisplay.height);
    }


    private function getDisplayObject(width: Float, height: Float, x: Float = 0, y: Float = 0): DisplayObject {
        var retVal: Shape = new Shape();
        retVal.graphics.beginFill(0);
        retVal.graphics.drawRect(0,0,width, height);
        retVal.graphics.endFill();
        retVal.x = x;
        retVal.y = y;
        return retVal;
    }

}