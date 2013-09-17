package ui.render.mock;
import ui.render.Controller;
import core.BaseObject;
class MockModalController implements BaseObject implements Controller {

    public var view: MockModalView;
    public var actions(default, default): MockModalActions;

    public var disposed: Bool;
    public var isSetup: Bool;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
        disposed = true;
    }

    public function setup(onComplete:Void -> Void):Void {
        isSetup = true;
        onComplete();
    }

}
