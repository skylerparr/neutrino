package display.containers;

import flash.display.DisplayObject;
import flash.events.Event;

class ContainerEvent extends Event {

    public static inline var RAW_CHILDREN_CHANGE:String = "rawChildrenChange";
    public static inline var RECALCULATE_BOUNDS:String = "recalculateBounds";

    public var child(default, null):DisplayObject;
    public var container(default, null):Container;

    public function new(type:String, child:DisplayObject, container:Container) {
        super(type, bubbles, cancelable);
        this.child = child;
        this.container = container;
    }

}