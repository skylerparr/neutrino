package display.containers;
import flash.display.Graphics;
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.display.Stage;
import flash.events.Event;
import flash.display.Sprite;
class DefaultScroller extends AbstractScroller {

    private static inline var SCROLL_WIDTH:Float = 5;

    public var trackSkin(null, set): Sprite;
    public var thumbSkin(null, set): Sprite;

    private var _trackSkin:Sprite;
    private var _thumbSkin:Sprite;
    private var _dragArea:Sprite;
    private var _scrollLength:Float = 100;
    private var _stage:Stage;

    public function new() {
        super();
        buildSkin();
    }

    public function buildSkin():Void {
        _trackSkin = new Sprite();
        _thumbSkin = new Sprite();
        drawShape(_trackSkin, 0xAAAAAA, SCROLL_WIDTH, _scrollLength);
        drawShape(_thumbSkin, 0x555555, SCROLL_WIDTH, SCROLL_WIDTH);

        addChild(_trackSkin);
        addChild(_thumbSkin);

        _dragArea = new Sprite();
        drawShape(_dragArea, 0, _trackSkin.width - _thumbSkin.width, _trackSkin.height - _thumbSkin.height);

        _thumbSkin.buttonMode = true;

        var handler:Event -> Void = null;
        handler = function(e:Event):Void {
            removeEventListener(Event.ADDED_TO_STAGE, handler);

            _stage = _thumbSkin.stage;

            _thumbSkin.addEventListener(MouseEvent.MOUSE_DOWN, onThumbSkinMouseDown, false, 0, true);
            _stage.addEventListener(MouseEvent.MOUSE_UP, onThumbSkinMouseUp, false, 0, true);
        }
        addEventListener(Event.ADDED_TO_STAGE, handler);
    }

    override public function useHorizontalScroll(value:Bool):Void {
        if (value) {
            rotation = 270;
        } else {
            rotation = 0;
        }
    }

    override public function set_scrollLength(value:Float):Float {
        _scrollLength = value;
        drawShape(_trackSkin, 0xAAAAAA, SCROLL_WIDTH, _scrollLength);
        drawShape(_dragArea, 0, _trackSkin.width - _thumbSkin.width, _trackSkin.height - _thumbSkin.height);
        return _scrollLength;
    }

    private function onThumbSkinMouseUp(event:MouseEvent):Void {
        _thumbSkin.stopDrag();
        _stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }

    private function onThumbSkinMouseDown(event:MouseEvent):Void {
        _thumbSkin.startDrag(true, _dragArea.getRect(_dragArea));
        _stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
    }

    private function onMouseMove(event:MouseEvent):Void {
        dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_UPDATE, this));
    }

    override public function get_percent():Float {
        return _thumbSkin.y / _dragArea.height;
    }

    private inline function drawShape(control:Sprite, color:Int, width:Float, height:Float):Void {
        var controlGraphics: Graphics = control.graphics;
        controlGraphics.clear();
        controlGraphics.beginFill(color);
        controlGraphics.drawRect(0, 0, width, height);
        controlGraphics.endFill();
    }

    private function set_trackSkin(value: Sprite):Sprite {
        _trackSkin = value;
        return _trackSkin;
    }

    private function set_thumbSkin(value: Sprite):Sprite {
        _thumbSkin = value;
        return _thumbSkin;
    }
}
