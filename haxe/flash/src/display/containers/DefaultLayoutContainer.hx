package display.containers;
import flash.display.DisplayObject;
import flash.events.EventDispatcher;
class DefaultLayoutContainer extends EventDispatcher implements LayoutContainer {
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

    private var _container:Container;

    public function new(value:Container) {
        super();
        _container = value;
        _container.addEventListener(ContainerEvent.RAW_CHILDREN_CHANGE, onRawChildrenChange, false, 0, true);
        layoutPolicy = LayoutPolicy.HORIZONTAL_LAYOUT;
    }

    private function onRawChildrenChange(ce:ContainerEvent):Void {
        refresh();
    }

    public function set_layoutPolicy(value:String):String {
        if (value == LayoutPolicy.HORIZONTAL_LAYOUT || value == LayoutPolicy.VERTICAL_LAYOUT) {
            layoutPolicy = value;
            refresh();
        }
        return layoutPolicy;
    }

    public function set_overwritePlacement(value:Bool):Bool {
        overwritePlacement = value;
        return overwritePlacement;
    }

    public function set_gap(value:Float):Float {
        if (value != gap) {
            gap = value;
            refresh();
        }
        return gap;
    }

    public function set_cellWidth(value:Float):Float {
        if (value != cellWidth) {
            cellWidth = value;
            refresh();
        }
        return cellWidth;
    }

    public function set_cellHeight(value:Float):Float {
        if (value != cellHeight) {
            cellHeight = value;
            refresh();
        }
        return cellHeight;
    }

    public inline function refresh():Void {
        if (layoutPolicy == LayoutPolicy.HORIZONTAL_LAYOUT) {
            refreshHorizontalLayout();
        } else if (layoutPolicy == LayoutPolicy.VERTICAL_LAYOUT) {
            refreshVerticalLayout();
        }

        dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_REFRESH));
        _container.recalculateBounds();
    }

    private inline function refreshHorizontalLayout():Void {
        var xIndex:Float = 0;

        var rawNumChildren:Int = _container.rawChildContainer.numChildren;
        for (i in 0...rawNumChildren) {
            var displayObj:DisplayObject = _container.rawChildContainer.getChildAt(i);
            displayObj.x = xIndex;
            if (overwritePlacement) {
                displayObj.y = 0;
            }
            if (Math.isNaN(cellWidth)) {
                xIndex += displayObj.width + gap;
            } else {
                xIndex += cellWidth + gap;
            }
        }
    }

    private inline function refreshVerticalLayout():Void {
        var yIndex:Float = 0;
        var rawNumChildren:Int = _container.rawChildContainer.numChildren;
        for (i in 0...rawNumChildren) {
            var displayObj:DisplayObject = _container.rawChildContainer.getChildAt(i);
            displayObj.y = yIndex;
            if (overwritePlacement) {
                displayObj.x = 0;
            }
            if (Math.isNaN(cellHeight)) {
                yIndex += displayObj.height + gap;
            } else {
                yIndex += cellHeight + gap;
            }
        }

    }

}
