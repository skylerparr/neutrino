package display.containers;
class BasicHBox extends Container implements LayoutContainer {
    @:isVar
    public var layoutPolicy(default, set):String;
    @:isVar
    public var gap(default, set):Float;
    @:isVar
    public var cellWidth(default, set):Float;
    @:isVar
    public var cellHeight(default, set):Float;
    @:isVar
    public var overwritePlacement(default, set):Bool;

    private var _layoutContainer:LayoutContainer;

    public function new() {
        super();
        _layoutContainer = new DefaultLayoutContainer(this);
        _layoutContainer.layoutPolicy = LayoutPolicy.HORIZONTAL_LAYOUT;
    }

    public function set_layoutPolicy(value:String):String {
        _layoutContainer.layoutPolicy = value;
        return _layoutContainer.layoutPolicy;
    }

    public function set_gap(value:Float):Float {
        _layoutContainer.gap = value;
        return _layoutContainer.gap;
    }

    public function set_cellWidth(value:Float):Float {
        _layoutContainer.cellWidth = value;
        return _layoutContainer.cellWidth;
    }

    public function set_cellHeight(value:Float):Float {
        _layoutContainer.cellHeight = value;
        return _layoutContainer.cellHeight;
    }

    public function set_overwritePlacement(value:Bool):Bool {
        _layoutContainer.overwritePlacement = value;
        return _layoutContainer.overwritePlacement;
    }

    public function refresh():Void {
        _layoutContainer.refresh();
    }

}
