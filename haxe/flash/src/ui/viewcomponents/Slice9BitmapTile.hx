package ui.viewcomponents;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.display.BitmapData;
import flash.display.Sprite;
class Slice9BitmapTile extends Sprite {

    private static var point: Point = new Point();
    private static var rect: Rectangle = new Rectangle();

    public var bitmapData(null, set): BitmapData;
    @:isVar
    public var slice9Grid(get, set): Rectangle;
    public var do9Slicing(null, set): Bool;

    private var _width: Float = 0;
    private var _height: Float = 0;

    private var _tlbd: BitmapData;
    private var _tcbd: BitmapData;
    private var _trbd: BitmapData;
    private var _lcbd: BitmapData;
    private var _cbd: BitmapData;
    private var _rcbd: BitmapData;
    private var _blbd: BitmapData;
    private var _bcbd: BitmapData;
    private var _brbd: BitmapData;

    private var _topLeft: Sprite;
    private var _topCenter: Sprite;
    private var _topRight: Sprite;
    private var _leftCenter: Sprite;
    private var _center: Sprite;
    private var _rightCenter: Sprite;
    private var _bottomLeft: Sprite;
    private var _bottomCenter: Sprite;
    private var _bottomRight: Sprite;
    
    public function new() {
        super();
    }

    private function createSprite(): Sprite {
        return new Sprite();
    }

    private function set_bitmapData( value: BitmapData ): BitmapData {
        bitmapData = value;
        sliceBitmaps();
        updateDisplay();
        return bitmapData;
    }

    private static inline function getRectangle(x: Float, y: Float, width: Float, height: Float): Rectangle {
        rect.x = x;
        rect.y = y;
        rect.width = width;
        rect.height = height;
        return rect;
    }

    private function sliceBitmaps(): Void {
        if(!do9Slicing) {
            return;
        }
        if ( slice9Grid != null && bitmapData != null ) {
            if ( slice9Grid.y > 0 ) {
                if ( bitmapData.width - slice9Grid.width - slice9Grid.x > 0 ) {
                    //top left
                    _topLeft = createSprite();
                    addChild( _topLeft );
                    _tlbd = new BitmapData( Std.int(slice9Grid.x), Std.int(slice9Grid.y), true, 0xffffff );
                    _tlbd.copyPixels( bitmapData, getRectangle( 0, 0, slice9Grid.x, slice9Grid.y ), point );

                    //top right
                    _topRight = createSprite();
                    addChild( _topRight );
                    _trbd = new BitmapData( Std.int(bitmapData.width - slice9Grid.width - slice9Grid.x), Std.int(slice9Grid.y), true, 0xffffff );
                    _trbd.copyPixels( bitmapData, getRectangle( slice9Grid.x + slice9Grid.width, 0, _trbd.width, _trbd.height ), point );
                }

                //top center
                _topCenter = createSprite();
                addChild( _topCenter );
                _tcbd = new BitmapData( Std.int(slice9Grid.width), Std.int(slice9Grid.y), true, 0xffffff );
                _tcbd.copyPixels( bitmapData, getRectangle( slice9Grid.x, 0, slice9Grid.width, slice9Grid.y ), point );

                //bottom center
                _bottomCenter = createSprite();
                addChild( _bottomCenter );
                _bcbd = new BitmapData( Std.int(slice9Grid.width), Std.int(bitmapData.height - slice9Grid.height - slice9Grid.y), true, 0xffffff );
                _bcbd.copyPixels( bitmapData, getRectangle( slice9Grid.x, slice9Grid.y + slice9Grid.height, slice9Grid.width, bitmapData.height - slice9Grid.y - slice9Grid.height ), point );
            }

            if ( slice9Grid.x > 0 ) {
                if ( bitmapData.height - slice9Grid.height - slice9Grid.y > 0 ) {
                    //bottom left
                    _bottomLeft = createSprite();
                    addChild( _bottomLeft );
                    _blbd = new BitmapData( Std.int(slice9Grid.x), Std.int(bitmapData.height - slice9Grid.height - slice9Grid.y), true, 0xffffff );
                    _blbd.copyPixels( bitmapData, getRectangle( 0, slice9Grid.y + slice9Grid.height, _blbd.width, _blbd.height ), point );

                    //bottom right
                    _bottomRight = createSprite();
                    addChild( _bottomRight );
                    _brbd = new BitmapData( Std.int(bitmapData.width - slice9Grid.x - slice9Grid.width), Std.int(bitmapData.height - slice9Grid.y - slice9Grid.height), true, 0xffffff );
                    _brbd.copyPixels( bitmapData, getRectangle( slice9Grid.x + slice9Grid.width, slice9Grid.y + slice9Grid.height, _brbd.width, _brbd.height ), point );
                }

                //left center
                _leftCenter = createSprite();
                addChild( _leftCenter );
                _lcbd = new BitmapData( Std.int(slice9Grid.x), Std.int(slice9Grid.height), true, 0xffffff );
                _lcbd.copyPixels( bitmapData, getRectangle( 0, slice9Grid.y, slice9Grid.x, slice9Grid.height ), point );

                //right center
                _rightCenter = createSprite();
                addChild( _rightCenter );
                var bdWidth: Float = bitmapData.width - slice9Grid.x - slice9Grid.width;
                _rcbd = new BitmapData( Std.int(bdWidth), Std.int(slice9Grid.height), true, 0xffffff );
                _rcbd.copyPixels( bitmapData, getRectangle( slice9Grid.x + slice9Grid.width, slice9Grid.y, bdWidth, slice9Grid.height ), point );
            }

            //center
            _center = createSprite();
            addChild( _center );
            _cbd = new BitmapData( Std.int(slice9Grid.width), Std.int(slice9Grid.height), true, 0xffffff );
            _cbd.copyPixels( bitmapData, getRectangle( slice9Grid.x, slice9Grid.y, slice9Grid.width, slice9Grid.height ), point );
        }
    }

    private function updateDisplay(): Void {
        if(!do9Slicing) {
            return;
        }
        if ( bitmapData == null ) {
            return;
        }
        if(_width == 0 || _height == 0) {
            return;
        }
        graphics.clear();
        if ( slice9Grid != null ) {
            var slice9GridX: Float = slice9Grid.x;
            var slice9GridY: Float = slice9Grid.y;
            var slice9GridWidth: Float = slice9Grid.width;
            var slice9GridHeight: Float = slice9Grid.height;
            
            var bitmapDataWidth: Float = bitmapData.width;
            var bitmapDataHeight: Float = bitmapData.height;
            
            var currentGraphics: Graphics = null;
            if ( _topLeft != null ) {
                currentGraphics = _topLeft.graphics;
                currentGraphics.clear();
                currentGraphics.beginBitmapFill( _tlbd, null, false );
                currentGraphics.drawRect( 0, 0, slice9GridX, slice9GridY );
                currentGraphics.endFill();
            }

            if ( _topRight != null ) {
                _topRight.x = _width - _trbd.width;
                currentGraphics = _topRight.graphics;
                currentGraphics.clear();
                currentGraphics.beginBitmapFill( _trbd, null, false );
                currentGraphics.drawRect( 0, 0, _trbd.width, _trbd.height );
                currentGraphics.endFill();
            }

            if ( _bottomLeft != null ) {
                _bottomLeft.y = _height - _blbd.height;
                currentGraphics = _bottomLeft.graphics;
                currentGraphics.clear();
                currentGraphics.beginBitmapFill( _blbd );
                currentGraphics.drawRect( 0, 0, _blbd.width, _blbd.height - 1 );
                currentGraphics.endFill();
            }

            if ( _bottomRight != null ) {
                _bottomRight.x = _width - _brbd.width;
                _bottomRight.y = _height - _brbd.height;
                currentGraphics = _bottomRight.graphics;
                currentGraphics.clear();
                currentGraphics.beginBitmapFill( _brbd );
                currentGraphics.drawRect( 0, 0, _brbd.width - 1, _brbd.height - 1 );
                currentGraphics.endFill();
            }

            if ( _topCenter != null ) {
                var tcHeight: Float = slice9GridY;
                if ( _height < slice9GridY ) {
                    tcHeight = _height;
                }
                _topCenter.x = slice9GridX;
                currentGraphics = _topCenter.graphics;
                currentGraphics.clear();
                currentGraphics.beginBitmapFill( _tcbd );
                currentGraphics.drawRect( 0, 0, Math.ceil(_width - (bitmapDataWidth - slice9GridWidth - slice9GridX) - slice9GridX) + 2, tcHeight );
                currentGraphics.endFill();
            }

            if ( _leftCenter != null ) {
                var lcWidth: Float = slice9GridX;
                if ( _width < slice9GridX ) {
                    lcWidth = _width;
                }
                _leftCenter.y = slice9GridY;
                currentGraphics = _leftCenter.graphics;
                currentGraphics.clear();
                currentGraphics.beginBitmapFill( _lcbd );
                currentGraphics.drawRect( 0, 0, lcWidth, Math.ceil(_height - (bitmapDataHeight - slice9GridHeight - slice9GridY) - slice9GridY) + 2 );
                currentGraphics.endFill();
            }

            if ( _bottomCenter != null ) {
                var bcY: Float = _height - _bcbd.height;
                if ( bcY < slice9GridY ) {
                    bcY = slice9GridY;
                }
                var bcHeight: Float = _bcbd.height;
                if ( bcHeight > _height ) {
                    if ( _height < slice9GridHeight - slice9GridY ) {
                        bcHeight = _height - slice9GridY;
                    } else {
                        bcHeight = _height - slice9GridY - slice9GridHeight;
                    }
                } else if ( bcHeight > _height - slice9GridY ) {
                    bcHeight = _height - slice9GridY;
                }
                if ( bcHeight < 0 ) {
                    bcHeight = 0;
                }
                _bottomCenter.x = Math.floor(slice9GridX);
                _bottomCenter.y = bcY;
                currentGraphics = _bottomCenter.graphics;
                currentGraphics.clear();
                currentGraphics.beginBitmapFill( _bcbd );
                currentGraphics.drawRect( 0, 0, Math.ceil(_width - (slice9GridX) - (bitmapDataWidth - slice9GridX - slice9GridWidth) + 1), bcHeight );
                currentGraphics.endFill();
            }

            if ( _rightCenter != null ) {
                var rcX: Float = _width - _rcbd.width;
                if ( rcX < slice9GridX ) {
                    rcX = slice9GridX;
                }
                var rcWidth: Float = _rcbd.width;
                if ( rcWidth > _width ) {
                    if ( _width < slice9GridWidth - slice9GridX ) {
                        rcWidth = _width - slice9GridX;
                    } else {
                        rcWidth = _width - slice9GridX - slice9GridWidth;
                    }
                } else if ( rcWidth > _width - slice9GridX ) {
                    rcWidth = _width - slice9GridX;
                }
                if ( rcWidth < 0 ) {
                    rcWidth = 0;
                }
                _rightCenter.x = rcX;
                _rightCenter.y = slice9GridY;
                currentGraphics = _rightCenter.graphics;
                currentGraphics.clear();
                currentGraphics.beginBitmapFill( _rcbd );
                currentGraphics.drawRect( 0, -1, rcWidth, Math.ceil(_height - (bitmapDataHeight - slice9GridHeight - slice9GridY) - slice9GridY) + 2 );
                currentGraphics.endFill();
            }

            var bdWidth: Float = _width - slice9GridX - (bitmapDataWidth - slice9GridX - slice9GridWidth);
            if ( bdWidth > _width ) {
                bdWidth = _width - slice9GridX - slice9GridWidth;
            } else if ( bdWidth < 0 ) {
                bdWidth = 0;
            }
            var bdHeight: Float = _height - slice9GridY - (bitmapDataHeight - slice9GridY - slice9GridHeight);
            if ( bdHeight > _height ) {
                bdHeight = _height - slice9GridY - slice9GridHeight;
            } else if ( bdHeight < 0 ) {
                bdHeight = 0;
            }
            _center.x = Math.floor(slice9GridX - 1);
            _center.y = Math.floor(slice9GridY);
            currentGraphics = _center.graphics;
            currentGraphics.clear();
            currentGraphics.beginBitmapFill( _cbd );
            currentGraphics.drawRect( 0, 0, Math.ceil(bdWidth + 2), Math.ceil(bdHeight) );
            currentGraphics.endFill();
        } else {
            graphics.beginBitmapFill( bitmapData );
            graphics.drawRect( 0, 0, _width, _height );
            graphics.endFill();
        }
    }

    public function setSize( w: Float, h: Float ): Void {
        _width = w;
        _height = h;
        updateDisplay();
    }

    private function set_slice9Grid( value: Rectangle ): Rectangle {
        slice9Grid = value;
        sliceBitmaps();
        updateDisplay();
        return slice9Grid;
    }

    private function get_slice9Grid(): Rectangle {
        return slice9Grid;
    }

    private function set_do9Slicing( value: Bool ): Bool {
        do9Slicing = value;
        return do9Slicing;
    }

    #if cpp
    override public function set_width(value: Float): Float {
        _width = value;
        updateDisplay();
        return _width;
    }

    override public function set_height(value: Float): Float {
        _height = value;
        updateDisplay();
        return _height;
    }
    #elseif flash
    @:setter(width)
    public function set_width(value: Float): Void {
        _width = value;
        updateDisplay();
    }

    @:setter(height)
    public function set_height(value: Float): Void {
        _height = value;
        updateDisplay();
    }
    #end

}
