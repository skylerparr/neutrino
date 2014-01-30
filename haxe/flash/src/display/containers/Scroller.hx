package display.containers;
import flash.display.DisplayObject;
import flash.events.IEventDispatcher;
interface Scroller extends IEventDispatcher {
    var track(get, null): DisplayObject;
    var thumb(get, null): DisplayObject;
    var upButton(get, null): DisplayObject;
    var downButton(get, null): DisplayObject;
    var percent(get, null): Float;
    var scrollLength(null, set): Float;
    function useHorizontalScroll(value: Bool): Void;

}
