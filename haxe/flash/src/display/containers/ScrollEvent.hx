package display.containers;
import flash.events.Event;
class ScrollEvent extends Event {
    public static inline var SCROLL_UPDATE: String = "scrollUpdate";

    @:isVar
    public var scroller(default, null): Scroller;

    public function new(type: String, scroller: Scroller) {
        super(type, bubbles, cancelable);
        this.scroller = scroller;
    }
}
