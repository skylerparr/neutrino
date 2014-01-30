package display.containers;
import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.events.Event;
import flash.display.Shape;
import flash.display.DisplayObject;
class DefaultMaskContainer extends EventDispatcher implements MaskedContainer {
    @:isVar
    public var mask(get, set): DisplayObject;
    @:isVar
    public var width(get, set): Float;
    @:isVar
    public var height(get, set): Float;
    @:isVar
    public var x(get, set): Float;
    @:isVar
    public var y(get, set): Float;

    private var _mask: DisplayObject;
    private var _width: Float;
    private var _height: Float;
    private var _x: Float = 0;
    private var _y: Float = 0;
    private var _container: Container;
    private var _isWidthSet: Bool;
    private var _isHeightSet: Bool;

    public function new(value: Container) {
        super();
        init(value);
    }

    private function init(value:Container):Void {
        _container = value;
        _container.addEventListener(ContainerEvent.RAW_CHILDREN_CHANGE, onRawChildrenChange, false, 0, true);
        _container.addEventListener(ContainerEvent.RECALCULATE_BOUNDS, onRawChildrenChange, false, 0, true);
        _mask = new Shape();
        applyMask();
    }

    private function onRawChildrenChange(e: Event):Void {
        applyMask();
        dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_REFRESH));
    }

    private inline function applyMask(): Void {
        if(!_isWidthSet) {
            _width = _container.rawChildContainer.width;
        }
        if(!_isHeightSet) {
            _height = _container.rawChildContainer.height;
        }
        var shapeMaskGraphics: Graphics = (cast _mask).graphics;
        shapeMaskGraphics.clear();
        shapeMaskGraphics.beginFill(0, 0);
        shapeMaskGraphics.drawRect(0,0,_width, _height);
        shapeMaskGraphics.endFill();
        if(_container.rawContains(_mask)) {
            _container.removeRawChild(_mask);
        }
        _container.addRawChild(_mask);
        _container.mask = _mask;
    }

    public function set_mask(value:DisplayObject):DisplayObject {
        _mask = value;
        if(_mask != null && _container.rawContains(_mask)) {
            _container.removeRawChild(_mask);
        }
        _container.addRawChild(_mask);
        _container.mask = _mask;
        return _mask;
    }

    public function get_mask(): DisplayObject {
        return _mask;
    }

    public function set_width(value:Float):Float {
        _width = value;
        _isWidthSet = true;
        onRawChildrenChange(null);
        return _width;
    }

    public function set_height(value:Float):Float {
        _height = value;
        _isHeightSet = true;
        onRawChildrenChange(null);
        return _height;
    }

    public function set_x(value:Float):Float {
        _x = value;
        _mask.x = _x;
        return _x;
    }

    public function set_y(value:Float):Float {
        _y = value;
        _mask.y = _y;
        return _y;
    }

    public function get_width():Float {
        return _width;
    }

    public function get_height():Float {
        return _height;
    }

    public function get_x():Float {
        return _x;
    }

    public function get_y():Float {
        return _y;
    }

}
