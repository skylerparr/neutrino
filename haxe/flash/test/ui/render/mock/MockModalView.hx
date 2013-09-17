package ui.render.mock;
import ui.render.Renderable;
import core.BaseObject;
import flash.display.Sprite;
class MockModalView extends Sprite implements BaseObject implements Renderable {

    public var controller: MockModalController;
    public var actions(default, set): MockModalActions;

    public var disposed: Bool;
    public var rendered: Bool;

    public function new() {
        super();
    }

    private function set_actions(value: MockModalActions): MockModalActions {
        actions = value;
        return actions;
    }

    public function init():Void {
    }

    public function dispose():Void {
        disposed = true;
    }

    public function render(onComplete:Void -> Void):Void {
        rendered = true;
        onComplete();
    }
}
