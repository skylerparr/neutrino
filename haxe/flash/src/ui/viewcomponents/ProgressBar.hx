package ui.viewcomponents;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import flash.display.BitmapData;
import flash.display.Sprite;
class ProgressBar extends Sprite {

    public var bgBitmapData(default, set): BitmapData;
    public var fillBitmapData(default, set): BitmapData;
    public var fgBitmapData(default, set): BitmapData;

    public var barWidth(default, set): Float;

    public var fillRect(default, set): Rectangle;
    public var bgRect(default, set): Rectangle;
    public var fgRect(default, set): Rectangle;

    public var fillXOffset(default, set): Float;
    public var fillYOffset(default, set): Float;

    public var progressValue(default, set): Float;

    private var _bgBitmap: Bitmap;
    private var _fillBitmap: Bitmap;
    private var _fgBitmap: Bitmap;

    private var _slice9BitmapFill: Slice9BitmapTile;

    public function new() {
        super();
        progressValue = 0;
    }

    private inline function assignFillBitmapData(): Void {
        _slice9BitmapFill.bitmapData = fillBitmapData;
        _slice9BitmapFill.height = fillBitmapData.height;
    }

    public function set_bgBitmapData(value:BitmapData): BitmapData {
        this.bgBitmapData = value;
        if(_bgBitmap == null) {
            _bgBitmap = new Bitmap();
            addChildAt(_bgBitmap, 0);
        }
        _bgBitmap.bitmapData = this.bgBitmapData;
        return this.bgBitmapData;
    }

    public function set_fillBitmapData(value:BitmapData): BitmapData {
        this.fillBitmapData = value;
        showFillBitmap();
        assignFillBitmapData();
        return this.fillBitmapData;
    }

    private inline function showFillBitmap():Void {
        if(_slice9BitmapFill == null) {
            _slice9BitmapFill = new Slice9BitmapTile();
            _slice9BitmapFill.do9Slicing = true;
        }
        _slice9BitmapFill.slice9Grid = fillRect;

        if(numChildren > 1) {
            addChildAt(_slice9BitmapFill, 1);
        } else {
            addChild(_slice9BitmapFill);
        }
        _slice9BitmapFill.x = fillXOffset;
        _slice9BitmapFill.y = fillYOffset;
    }

    public function set_fgBitmapData(value:BitmapData): BitmapData {
        this.fgBitmapData = value;
        if(_fgBitmap == null) {
            _fgBitmap = new Bitmap();
            addChild(_fgBitmap);
        }
        _fgBitmap.bitmapData = fgBitmapData;
        return this.fgBitmapData;
    }

    public function set_barWidth(value:Float): Float {
        this.barWidth = value;
        return this.barWidth;
    }

    public function set_fillRect(value:Rectangle): Rectangle {
        this.fillRect = value;
        showFillBitmap();
        return this.fillRect;
    }

    public function set_bgRect(value:Rectangle): Rectangle {
        this.bgRect = value;
        return this.bgRect;
    }

    public function set_fgRect(value:Rectangle): Rectangle {
        this.fgRect = value;
        return this.fgRect;
    }

    public function set_fillXOffset(value:Float): Float {
        this.fillXOffset = value;
        showFillBitmap();
        return this.fillXOffset;
    }

    public function set_fillYOffset(value:Float): Float {
        this.fillYOffset = value;
        showFillBitmap();
        return this.fillYOffset;
    }

    public function set_progressValue(value:Float): Float {
        if(value > 1) {
            value = 1;
        } else if(value < 0) {
            value = 0;
        }
        this.progressValue = value;
        showProgress();
        return this.progressValue;
    }

    private inline function showProgress(): Void {
        if(_slice9BitmapFill != null) {
            _slice9BitmapFill.width = barWidth * progressValue;
        }
    }

}
