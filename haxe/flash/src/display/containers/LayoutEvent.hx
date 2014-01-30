package display.containers;
import flash.events.Event;
class LayoutEvent extends Event {
    public static inline var LAYOUT_REFRESH: String = "layoutRefresh";

    public function new(type:String) {
        super(type, bubbles, cancelable);
    }
}
