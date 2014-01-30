package display.containers;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import flash.display.Sprite;

class ContainerTest {
    private var _container:Container;

    public function new() {

    }

    @Before
    public function setUp():Void {
        _container = new Container();
    }

    @After
    public function tearDown():Void {
        _container = null;
    }

    @Test
    public function shouldAddChildToInnerContainer():Void {
        var child:Sprite = new Sprite();
        _container.addChild(child);

        Assert.areEqual(child, _container.rawChildContainer.getChildAt(0));
    }

    @Test
    public function shouldAddChildAtIndexOnInnerContainer():Void {
        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();
        var child2:Sprite = new Sprite();

        _container.addChildAt(child2, 0);
        _container.addChildAt(child1, 0);
        _container.addChildAt(child, 0);

        Assert.areEqual(child2, _container.getChildAt(2));
        Assert.areEqual(child2, _container.rawChildContainer.getChildAt(2));
    }

    @Test
    public function shouldRemoveChildFromInnerContainer():Void {
        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();
        var child2:Sprite = new Sprite();

        _container.addChildAt(child2, 0);
        _container.addChildAt(child1, 0);
        _container.addChildAt(child, 0);

        Assert.areEqual(3, _container.rawChildContainer.numChildren);
        Assert.areEqual(child, _container.removeChild(child));
        Assert.areEqual(2, _container.rawChildContainer.numChildren);
    }

    @Test
    public function shouldRemovedChildAtFromInnerContainer():Void {
        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();
        var child2:Sprite = new Sprite();

        _container.addChildAt(child2, 0);
        _container.addChildAt(child1, 1);
        _container.addChildAt(child, 2);

        Assert.areEqual(3, _container.rawChildContainer.numChildren);
        Assert.areEqual(child2, _container.removeChildAt(0));
        Assert.areEqual(2, _container.rawChildContainer.numChildren);
    }

    @Test
    public function shouldGetNumchildrenFromRawChildren():Void {
        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();
        var child2:Sprite = new Sprite();

        _container.addChildAt(child2, 0);
        _container.addChildAt(child1, 1);
        _container.addChildAt(child, 2);

        Assert.areEqual(3, _container.rawChildContainer.numChildren);
        Assert.areEqual(3, _container.numChildren);
    }

    @Test
    public function shouldGetChildIndexFromRawChildren():Void {
        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();
        var child2:Sprite = new Sprite();

        _container.addChildAt(child2, 0);
        _container.addChildAt(child1, 1);
        _container.addChildAt(child, 2);

        Assert.areEqual(1, _container.getChildIndex(child1));
    }

    @Test
    public function shouldSetChildIndexFromRawChildren():Void {
        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();
        var child2:Sprite = new Sprite();

        _container.addChildAt(child2, 0);
        _container.addChildAt(child1, 1);
        _container.addChildAt(child, 2);

        _container.setChildIndex(child, 0);

        Assert.areEqual(child, _container.rawChildContainer.getChildAt(0));
    }

    @Test
    public function shouldGetChildByNameFromRawChildren():Void {
        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();
        var child2:Sprite = new Sprite();

        _container.addChildAt(child2, 0);
        _container.addChildAt(child1, 1);
        _container.addChildAt(child, 2);

        child.name = "1";
        child1.name = "2";
        child2.name = "3";

        Assert.areEqual(child1, _container.getChildByName("2"));
        Assert.areEqual(child2, _container.getChildByName("3"));
        Assert.areEqual(child, _container.getChildByName("1"));
    }

    @Test
    public function shouldCheckContainsFromRawChildren():Void {
        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();
        var child2:Sprite = new Sprite();

        _container.addChildAt(child2, 0);
        _container.addChildAt(child, 0);

        Assert.isTrue(_container.contains(child));
        Assert.isFalse(_container.contains(child1));
    }

    @Test
    public function shouldSwapChildrenOnRawChildren():Void {
        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();
        var child2:Sprite = new Sprite();

        _container.addChildAt(child2, 0);
        _container.addChildAt(child, 1);
        _container.addChildAt(child1, 2);

        _container.swapChildren(child, child2);
        Assert.areEqual(child, _container.rawChildContainer.getChildAt(0));
        Assert.areEqual(child2, _container.rawChildContainer.getChildAt(1));
    }

    @Test
    public function shouldSwapChildrenAtOnRawChildren():Void {
        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();
        var child2:Sprite = new Sprite();

        _container.addChildAt(child2, 0);
        _container.addChildAt(child, 1);
        _container.addChildAt(child1, 2);

        _container.swapChildrenAt(0, 1);
        Assert.areEqual(child, _container.rawChildContainer.getChildAt(0));
        Assert.areEqual(child2, _container.rawChildContainer.getChildAt(1));
    }

    @Test
    public function shouldAddChildToRawChildren():Void {
        Assert.areEqual(1, _container.rawNumChildren);

        _container.addRawChild(new Sprite());
        Assert.areEqual(2, _container.rawNumChildren);
    }

    @Test
    public function shouldAddChildAtToRawChildren():Void {
        Assert.areEqual(1, _container.rawNumChildren);

        _container.addRawChildAt(new Sprite(), 0);
        Assert.areEqual(2, _container.rawNumChildren);
    }

    @Test
    public function shouldRemoveChildToRawChildren():Void {
        Assert.areEqual(1, _container.rawNumChildren);

        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();

        _container.addRawChildAt(child, 0);
        _container.addRawChildAt(child1, 0);
        Assert.areEqual(3, _container.rawNumChildren);

        _container.removeRawChild(child);
        Assert.areEqual(2, _container.rawNumChildren);
    }

    @Test
    public function shouldRemoveChildAtToRawChildren():Void {
        Assert.areEqual(1, _container.rawNumChildren);

        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();

        _container.addRawChildAt(child, 0);
        _container.addRawChildAt(child1, 0);
        Assert.areEqual(3, _container.rawNumChildren);

        _container.removeRawChildAt(0);
        Assert.areEqual(2, _container.rawNumChildren);
    }

    @Test
    public function shouldGetChildAtToRawChildren():Void {
        Assert.areEqual(1, _container.rawNumChildren);

        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();

        _container.addRawChildAt(child, 0);
        _container.addRawChildAt(child1, 0);
        Assert.areEqual(3, _container.rawNumChildren);

        Assert.areEqual(child, _container.getRawChildAt(1));
        Assert.areEqual(child1, _container.getRawChildAt(0));

    }

    @Test
    public function shouldHaveContainsToRawChildren():Void {
        Assert.areEqual(1, _container.rawNumChildren);

        var child:Sprite = new Sprite();
        var child1:Sprite = new Sprite();

        _container.addRawChildAt(child, 0);
        Assert.areEqual(2, _container.rawNumChildren);

        Assert.isTrue(_container.rawContains(child));
        Assert.isFalse(_container.rawContains(child1));

    }

    @Test
    public function shouldDispatchContainerChildrenChangeEventWhenAddingAChild():Void {
        var cbCalled: Bool = false;
        var child:Sprite = new Sprite();
        _container.addEventListener(ContainerEvent.RAW_CHILDREN_CHANGE, function(ce:ContainerEvent):Void {
            cbCalled = true;
            Assert.areEqual(child, ce.child);
            Assert.areEqual(_container, ce.container);
        });

        _container.addChild(child);
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldDispatchContainerChildrenChangeEventWhenAddingChildAt():Void {
        var cbCalled: Bool = false;
        var child:Sprite = new Sprite();
        _container.addEventListener(ContainerEvent.RAW_CHILDREN_CHANGE, function(ce:ContainerEvent):Void {
            cbCalled = true;
            Assert.areEqual(child, ce.child);
            Assert.areEqual(_container, ce.container);
        });

        _container.addChildAt(child, 0);
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldDispatchContainerChildrenChangeEventWhenRemovingChild():Void {
        var cbCalled: Bool = false;
        var child:Sprite = new Sprite();
        _container.addEventListener(ContainerEvent.RAW_CHILDREN_CHANGE, function(ce:ContainerEvent):Void {
            cbCalled = true;
            Assert.areEqual(child, ce.child);
            Assert.areEqual(_container, ce.container);
        }, 100);

        _container.rawChildContainer.addChild(child);
        _container.removeChild(child);
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldDispatchContainerChildrenChangeEventWhenRemovingChildAt():Void {
        var child:Sprite = new Sprite();
        var cbCalled: Bool = false;
        _container.addEventListener(ContainerEvent.RAW_CHILDREN_CHANGE, function(ce:ContainerEvent):Void {
            cbCalled = true;
            Assert.areEqual(child, ce.child);
            Assert.areEqual(_container, ce.container);
        }, 100);

        _container.rawChildContainer.addChild(child);
        _container.removeChildAt(0);
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldDispatchContainerChildrenChangeEventWhenSwappingChildren():Void {
        var cbCalled: Bool = false;
        _container.addEventListener(ContainerEvent.RAW_CHILDREN_CHANGE, function(ce:ContainerEvent):Void {
            cbCalled = true;
            Assert.isNull(ce.child);
            Assert.areEqual(_container, ce.container);
        });

        var child:Sprite = new Sprite();
        var child2:Sprite = new Sprite();
        _container.rawChildContainer.addChild(child);
        _container.rawChildContainer.addChild(child2);
        _container.swapChildren(child, child2);
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldDispatchContainerChildrenChangeEventWhenSwappingChildrenAt():Void {
        var cbCalled: Bool = false;
        _container.addEventListener(ContainerEvent.RAW_CHILDREN_CHANGE, function(ce:ContainerEvent):Void {
            cbCalled = true;
            Assert.isNull(ce.child);
            Assert.areEqual(_container, ce.container);
        });

        var child:Sprite = new Sprite();
        var child2:Sprite = new Sprite();
        _container.rawChildContainer.addChild(child);
        _container.rawChildContainer.addChild(child2);
        _container.swapChildrenAt(0, 1);
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldDispatchRecalculateBoundsEventIfToldToDoSo():Void {
        var cbCalled: Bool = false;
        _container.addEventListener(ContainerEvent.RECALCULATE_BOUNDS, function(ce:ContainerEvent):Void {
            cbCalled = true;
            Assert.isNull(ce.child);
            Assert.areEqual(_container, ce.container);
        });

        var child:Sprite = new Sprite();
        var child2:Sprite = new Sprite();
        _container.rawChildContainer.addChild(child);
        _container.rawChildContainer.addChild(child2);

        _container.recalculateBounds();
    }

}