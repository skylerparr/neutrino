package display.containers;
import flash.display.DisplayObject;
import flash.display.Sprite;
class AbstractScroller extends Sprite implements Scroller {

    public var track(get, null):DisplayObject;
    public var thumb(get, null):DisplayObject;
    public var upButton(get, null):DisplayObject;
    public var downButton(get, null):DisplayObject;
    public var percent(get, null):Float;
    public var scrollLength(null, set):Float;

    private var _useHorizontalScroll:Bool;

    public function new() {
        super();
    }

    public function get_track():DisplayObject {
        return null;
    }

    public function get_thumb():DisplayObject {
        return null;
    }

    public function get_upButton():DisplayObject {
        return null;
    }

    public function get_downButton():DisplayObject {
        return null;
    }

    public function useHorizontalScroll(value:Bool):Void {
        _useHorizontalScroll = value;
    }

    public function getUseHorizontalScroll():Bool {
        return _useHorizontalScroll;
    }

    public function get_percent():Float {
        return 0;
    }

    public function set_scrollLength(value:Float):Float {
        return 0;
    }
}
