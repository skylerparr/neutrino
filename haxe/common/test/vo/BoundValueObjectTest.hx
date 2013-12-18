package vo;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class BoundValueObjectTest {

    private var _vo: MockBoundValueObject;

    public function new() {

    }

    @Before
    public function setup():Void {
        _vo = new MockBoundValueObject();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldSetProperty(): Void {
        _vo.updateName("foo");
        Assert.areEqual("foo", _vo.name);
    }

    @Test
    public function shouldInvokeBindingFunctionOnUpdate(): Void {
        var propertyUpdated: Bool = false;
        _vo.bindProperty("name", function(): Void {
            propertyUpdated = true;
        });
        _vo.updateName("foo");
        Assert.isTrue(propertyUpdated);
    }

    @Test
    public function shouldInvokeMultipleBindingsOnUpdate(): Void {
        var propertyUpdated: Bool = false;
        _vo.bindProperty("name", function(): Void {
            propertyUpdated = true;
        });
        var propertyUpdated2: Bool = false;
        _vo.bindProperty("name", function(): Void {
            propertyUpdated2 = true;
        });
        _vo.updateName("foo");
        Assert.isTrue(propertyUpdated);
        Assert.isTrue(propertyUpdated2);
    }

    @Test
    public function shouldUnbindProperties(): Void {
        var propertyUpdated: Bool = false;
        _vo.bindProperty("name", function(): Void {
            propertyUpdated = true;
        });
        var propertyUpdated2: Bool = false;
        var bindingFunc: Void->Void = function(): Void {
            propertyUpdated2 = true;
        };
        _vo.bindProperty("name", bindingFunc);
        _vo.unbindProperty("name", bindingFunc);
        _vo.updateName("foo");
        Assert.isTrue(propertyUpdated);
        Assert.isFalse(propertyUpdated2);
    }

    @Test
    public function shouldUnbindAllBindings(): Void {
        var propertyUpdated: Bool = false;
        _vo.bindProperty("name", function(): Void {
            propertyUpdated = true;
        });
        var propertyUpdated2: Bool = false;
        _vo.bindProperty("name", function(): Void {
            propertyUpdated2 = true;
        });
        _vo.unbindAll();
        Assert.isFalse(propertyUpdated);
        Assert.isFalse(propertyUpdated2);
    }

    @Test
    public function shouldNotThrowExceptionIfUnbindIsCalledBeforeAnyBindingsDefined(): Void {
        _vo.unbindProperty("name", function(): Void {});
    }

    @Test
    public function shouldBeAbleToAddBindingsAfterBindingsWereClearedOut(): Void {
        var propertyUpdated: Bool = false;
        var bindingFunc: Void->Void = function(): Void {
            propertyUpdated = true;
        };
        _vo.bindProperty("name", bindingFunc);
        var propertyUpdated2: Bool = false;
        var bindingFunc2: Void->Void = function(): Void {
            propertyUpdated2 = true;
        };
        _vo.bindProperty("name", bindingFunc2);
        _vo.unbindProperty("name", bindingFunc2);
        _vo.unbindProperty("name", bindingFunc);
        _vo.updateName("foo");
        Assert.isFalse(propertyUpdated);
        _vo.bindProperty("name", bindingFunc);
        _vo.updateName("foo");
        Assert.isTrue(propertyUpdated);
    }

    @Test
    public function shouldNotThrowExceptionIfUnbindingAndNothingWasBound(): Void {
        _vo.bindProperty("name", function(): Void {

        });
        _vo.unbindProperty("foo", function(): Void {

        });
    }
}

class MockBoundValueObject extends BoundValueObject {
    @:isVar
    public var name(get, null): String;

    @:isVar
    public var foo(default, null): String;

    public function new() {
        super();
    }

    public function updateName(value: String): Void {
        setProperty("name", value);
    }

    private function get_name(): String {
        return name;
    }

}