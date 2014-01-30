package display.containers;
import flash.display.DisplayObject;

class VBox extends Container implements MaskedContainer implements ScrollContainer implements LayoutContainer {
    public var horizontalScrollPolicy(default, set): String;
    public var verticalScrollPolicy(default, set): String;

    public var maskDisplay(get, set): DisplayObject;
    public var displayWidth(get, set): Float;
    public var displayHeight(get, set): Float;
    public var displayX(get, set): Float;
    public var displayY(get, set): Float;

    public var layoutPolicy(null, set): String;
    public var gap(null, set): Float;
    public var cellWidth(null, set): Float;
    public var cellHeight(null, set): Float;
    public var overwritePlacement(null, set):Bool;

    private var _maskContainer:DefaultMaskContainer;
    private var _scrollContainer:DefaultScrollContainer;
    private var _layoutContainer:DefaultLayoutContainer;

    public function new() {
        super();

        var hScroll:Scroller = new DefaultScroller();
        var vScroll:Scroller = new DefaultScroller();

        _maskContainer = new DefaultMaskContainer(this);
        _layoutContainer = new DefaultLayoutContainer(this);
        _layoutContainer.layoutPolicy = LayoutPolicy.VERTICAL_LAYOUT;
        _scrollContainer = new DefaultScrollContainer(this, _maskContainer, hScroll, vScroll);
    }

    private function set_horizontalScrollPolicy(value:String):String {
        _scrollContainer.horizontalScrollPolicy = value;
        return _scrollContainer.horizontalScrollPolicy;
    }

    private function set_verticalScrollPolicy(value:String):String {
        _scrollContainer.verticalScrollPolicy = value;
        return _scrollContainer.verticalScrollPolicy;
    }

    private function set_layoutPolicy(value:String):String {
        _layoutContainer.layoutPolicy = value;
        return _layoutContainer.layoutPolicy;
    }

    private function set_gap(value:Float):Float {
        _layoutContainer.gap = value;
        return _layoutContainer.gap;
    }

    private function set_cellWidth(value:Float):Float {
        _layoutContainer.cellWidth = value;
        return _layoutContainer.cellWidth;
    }

    private function set_cellHeight(value:Float):Float {
        _layoutContainer.cellHeight = value;
        return _layoutContainer.cellHeight;
    }

    private function set_overwritePlacement(value:Bool):Bool {
        _layoutContainer.overwritePlacement = value;
        return _layoutContainer.overwritePlacement;
    }

    public function refresh():Void {
        _layoutContainer.refresh();
    }
    public function set_maskDisplay(value:DisplayObject):DisplayObject {
        _maskContainer.maskDisplay = value;
        return _maskContainer.maskDisplay;
    }

    public function get_maskDisplay(): DisplayObject {
        return _maskContainer.maskDisplay;
    }

    public function set_displayWidth(value:Float):Float {
        _maskContainer.displayWidth = value;
        return _maskContainer.displayWidth;
    }

    public function set_displayHeight(value:Float):Float {
        _maskContainer.displayHeight = value;
        return _maskContainer.displayHeight;
    }

    public function set_displayX(value:Float):Float {
        _maskContainer.displayX = value;
        return _maskContainer.displayX;
    }

    public function set_displayY(value:Float):Float {
        _maskContainer.displayY = value;
        return _maskContainer.displayY;
    }

    public function get_displayWidth():Float {
        return _maskContainer.displayWidth;
    }

    public function get_displayHeight():Float {
        return _maskContainer.displayHeight;
    }

    public function get_displayX():Float {
        return _maskContainer.displayX;
    }

    public function get_displayY():Float {
        return _maskContainer.displayY;
    }

    #if cpp
    override public function set_width(value:Float):Float {
        _maskContainer.width = value;
        return _maskContainer.displayWidth;
    }

    override public function get_height():Float {
        return _maskContainer.displayHeight;
    }

    override public function get_width():Float {
        return _maskContainer.displayWidth;
    }

    override public function set_height(value:Float):Float {
        _maskContainer.height = value;
        return _maskContainer.displayHeight;
    }
    #elseif flash
    @:setter(width)
    public function set_width(value:Float):Void {
        _maskContainer.displayWidth = value;
    }

    @:getter(height)
    public function get_height():Float {
        return _maskContainer.displayHeight;
    }

    @:getter(width)
    public function get_width():Float {
        return _maskContainer.displayWidth;
    }

    @:setter(height)
    public function set_height(value:Float):Void {
        _maskContainer.displayHeight = value;
    }
    #end
}
