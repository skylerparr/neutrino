package display.containers;
import flash.display.DisplayObject;
import flash.events.IEventDispatcher;
interface MaskedContainer extends IEventDispatcher {
    var mask(default, set): DisplayObject;
    var width(default, set): Float;
    var height(default, set): Float;
    var x(default, set): Float;
    var y(default, set): Float;
}
