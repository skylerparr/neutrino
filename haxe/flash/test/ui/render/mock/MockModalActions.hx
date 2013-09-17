package ui.render.mock;
import core.BaseObject;
class MockModalActions implements BaseObject {

    public var controller: MockModalController;
    public var view(default, default): MockModalView;

    public var disposed: Bool;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
        disposed = true;
    }
}
