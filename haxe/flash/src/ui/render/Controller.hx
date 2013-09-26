package ui.render;
import core.BaseObject;
interface Controller extends BaseObject {
    function setup(onComplete: Void->Void): Void;
}
