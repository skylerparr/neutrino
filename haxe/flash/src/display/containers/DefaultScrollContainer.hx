package display.containers;
import flash.display.DisplayObject;
import flash.events.Event;
class DefaultScrollContainer implements ScrollContainer {

    public var horizontalScrollPolicy(default, set): String;
    public var verticalScrollPolicy(default, set): String;

    private var _container: Container;
    private var _maskedContainer: MaskedContainer;
    private var _hScroll: Scroller;
    private var _vScroll: Scroller;

    private var _horizontalScrollPolicy: String = ScrollPolicy.AUTO;
    private var _verticalScrollPolicy: String = ScrollPolicy.AUTO;

    public function new(container: Container, maskedContainer: MaskedContainer, hScroll: Scroller, vScroll: Scroller) {
        _container = container;
        _maskedContainer = maskedContainer;
        _hScroll = hScroll;
        _vScroll = vScroll;

        _hScroll.useHorizontalScroll(true);

        _vScroll.addEventListener(ScrollEvent.SCROLL_UPDATE, onVerticalScrollUpdate);
        _hScroll.addEventListener(ScrollEvent.SCROLL_UPDATE, onHorizontalScrollUpdate);

        if(Std.is(hScroll, DisplayObject)) {
            _container.addRawChild(cast hScroll);
            (cast _hScroll).visible = false;
        }
        if(Std.is(vScroll, DisplayObject)) {
            _container.addRawChild(cast vScroll);
            (cast _vScroll).visible = false;
        }


        _container.addEventListener(ContainerEvent.RAW_CHILDREN_CHANGE, onRawChildrenChange, false, 0, true);
        _container.addEventListener(ContainerEvent.RECALCULATE_BOUNDS, onRawChildrenChange, false, 0, true);
        _maskedContainer.addEventListener(LayoutEvent.LAYOUT_REFRESH, onRawChildrenChange, false, 0, true);
    }

    private function onHorizontalScrollUpdate(event:ScrollEvent):Void {
        var percent: Float = event.scroller.percent;
        _container.rawChildContainer.x = (_container.rawChildContainer.width - _maskedContainer.displayWidth) * percent * -1;
    }

    private function onVerticalScrollUpdate(event:ScrollEvent):Void {
        var percent: Float = event.scroller.percent;
        _container.rawChildContainer.y = (_container.rawChildContainer.height - _maskedContainer.displayHeight) * percent * -1;
    }

    private function onRawChildrenChange(event: Event):Void {
        if(shouldShowVerticalScroller()) {
            showVerticalScroller();
        } else {
            (cast _vScroll).visible = false;
        }

        if(shouldShowHorizontalScroller()) {
            showHorizontalScroller();
        } else {
            (cast _hScroll).visible = false;
        }
    }

    private function shouldShowVerticalScroller():Bool {
        if(_verticalScrollPolicy == ScrollPolicy.ALWAYS) {
            return true;
        }
        if(_verticalScrollPolicy == ScrollPolicy.AUTO && _container.rawChildContainer.height > _maskedContainer.displayHeight) {
            return true;
        }
        return false;
    }

    private function shouldShowHorizontalScroller():Bool {
        if(_horizontalScrollPolicy == ScrollPolicy.ALWAYS) {
            return true;
        }
        if(_horizontalScrollPolicy == ScrollPolicy.AUTO && _container.rawChildContainer.width > _maskedContainer.displayWidth) {
            return true;
        }

        return false;
    }

    private function showHorizontalScroller():Void {
        //show the scroll bar
        (cast _hScroll).visible = true;
        _hScroll.scrollLength = _maskedContainer.displayWidth;
        (cast _hScroll).y = _maskedContainer.displayHeight;

    }

    private function showVerticalScroller():Void {
        //show the scroll bar
        (cast _vScroll).visible = true;
        _vScroll.scrollLength = _maskedContainer.displayHeight;
        (cast _vScroll).x = _maskedContainer.displayWidth - (cast _vScroll).width;
    }

    public function set_horizontalScrollPolicy(value:String):String {
        _horizontalScrollPolicy = value;
        onRawChildrenChange(null);
        return _horizontalScrollPolicy;
    }

    public function set_verticalScrollPolicy(value:String):String {
        _verticalScrollPolicy = value;
        onRawChildrenChange(null);
        return _verticalScrollPolicy;
    }
}
