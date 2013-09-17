package ui.render;
import core.BaseObject;
interface Renderable extends BaseObject {
    function render(onComplete: Void->Void): Void;
}
