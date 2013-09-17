package ui.render;
import flash.display.DisplayObject;
interface UIRenderer {
    function renderView(name: String, onComplete: DisplayObject->Void): Void;
    function dispose(displayObject: DisplayObject, onComplete: Void->Void): Void;
}
