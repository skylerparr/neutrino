package display.containers;
import flash.events.IEventDispatcher;
interface LayoutContainer extends IEventDispatcher {
    var layoutPolicy(null, set): String;
    var gap(null, set): Float;
    var cellWidth(null, set): Float;
    var cellHeight(null, set): Float;
    var overwritePlacement(null, set):Bool;
    function refresh(): Void;
}
