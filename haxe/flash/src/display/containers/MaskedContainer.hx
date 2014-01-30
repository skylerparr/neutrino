package display.containers;
import flash.display.DisplayObject;
import flash.events.IEventDispatcher;
interface MaskedContainer extends IEventDispatcher {
    var mask(get, set): DisplayObject;
    var width(get, set): Float;
    var height(get, set): Float;
    var x(get, set): Float;
    var y(get, set): Float;
}
