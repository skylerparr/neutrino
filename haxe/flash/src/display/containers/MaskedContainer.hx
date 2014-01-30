package display.containers;
import flash.display.DisplayObject;
import flash.events.IEventDispatcher;
interface MaskedContainer extends IEventDispatcher {
    var maskDisplay(get, set): DisplayObject;
    var displayWidth(get, set): Float;
    var displayHeight(get, set): Float;
    var displayX(get, set): Float;
    var displayY(get, set): Float;
}
