package display.containers;
import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.events.Event;
import flash.display.Shape;
import flash.display.DisplayObject;
class DefaultMaskContainer extends EventDispatcher implements MaskedContainer {
    @:isVar
    public var mask(default, set): DisplayObject;
    @:isVar
    public var width(default, set): Float;
    @:isVar
    public var height(default, set): Float;
    @:isVar
    public var x(default, set): Float;
    @:isVar
    public var y(default, set): Float;

    private var _mask: DisplayObject;
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
            width = _container.rawChildContainer.width;
        }
        if(!_isHeightSet) {
            height = _container.rawChildContainer.height;
        }
        var shapeMaskGraphics: Graphics = (cast _mask).graphics;
        shapeMaskGraphics.clear();
        shapeMaskGraphics.beginFill(0, 0);
        shapeMaskGraphics.drawRect(0,0,width, height);
        shapeMaskGraphics.endFill();
        if(_container.rawContains(_mask)) {
            _container.removeRawChild(_mask);
        }
        _container.addRawChild(_mask);
        _container.mask = _mask;
    }

    public function set_mask(value:DisplayObject):DisplayObject {
        if(_mask != null) {
            _container.removeRawChild(_mask);
        }
        _container.addRawChild(_mask);
        _mask = value;
        _container.mask = _mask;
        return _mask;
    }

    public function set_width(value:Float):Float {
        width = value;
        _isWidthSet = true;
        onRawChildrenChange(null);
        return width;
    }

    public function set_height(value:Float):Float {
        height = value;
        _isHeightSet = true;
        onRawChildrenChange(null);
        return height;
    }

    public function set_x(value:Float):Float {
        x = value;
        _mask.x = x;
        return x;
    }

    public function set_y(value:Float):Float {
        y = value;
        _mask.y = y;
        return y;
    }

}
