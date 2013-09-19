package navigation;
import navigation.ModalManager;
import ui.render.UIRenderer;
import flash.events.MouseEvent;
import flash.display.Sprite;
import util.AnonFunc;
import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;
class DictionaryModalManager implements ModalManager {

    @inject
    public var uiRenderer: UIRenderer;

    public var viewNameMap: Map<String, DisplayObject>;

    public var dialogLayer(null, set): DisplayObjectContainer;
    public var shadeLayer(null, set): DisplayObjectContainer;
    private var _shadeChild: DisplayObject;

    public function new() {
        viewNameMap = new Map<String, DisplayObject>();
    }

    public function openModal(name:String, ?dialogData: Dynamic = null):Void {
        closeAllModals();
        appendModal(name);
    }

    private function set_dialogLayer(value: DisplayObjectContainer): DisplayObjectContainer {
        dialogLayer = value;
        return dialogLayer;
    }

    private function set_shadeLayer(value: DisplayObjectContainer): DisplayObjectContainer {
        shadeLayer = value;
        _shadeChild = createInputBlocker();
        return dialogLayer;
    }

    private function onRenderComplete(name: String, isContextual: Bool, display: DisplayObject):Void {
        if(display == null) {
            return;
        }
        if(dialogLayer == null) {
            throw "dialog layer must be set";
        }
        if(shadeLayer == null) {
            throw "shade layer must be set";
        }
        dialogLayer.addChild(display);
        if(!shadeLayer.contains(_shadeChild)) {
            if(isContextual) {
                _shadeChild.addEventListener(MouseEvent.CLICK, onShadeClick);
            }
            shadeLayer.addChild(_shadeChild);
        }
        viewNameMap.set(name, display);
    }

    public function createInputBlocker():DisplayObject {
        var retVal: Sprite = new Sprite();
        return retVal;
    }

    private function onShadeClick(me: MouseEvent):Void {
        closeContextualMenu();
    }

    public function appendModal(name:String, ?dialogData: Dynamic = null):Void {
        uiRenderer.renderView(name, AnonFunc.call(onRenderComplete, [name, false]));
    }

    public function closeModal(name:String):Void {
        var display: DisplayObject = viewNameMap.get(name);
        if(display == null) {
            return;
        }
        viewNameMap.remove(name);
        uiRenderer.dispose(display, null);
        if(dialogLayer.contains(display)) {
            dialogLayer.removeChild(display);
        }
        if(allModalsClosed() && shadeLayer.contains(_shadeChild)) {
            _shadeChild.removeEventListener(MouseEvent.CLICK, onShadeClick);
            shadeLayer.removeChild(_shadeChild);
        }
    }

    private inline function allModalsClosed(): Bool {
        var retVal: Bool = true;
        for(view in viewNameMap) {
            //this means there are still modals open
            retVal = false;
            break;
        }
        return retVal;
    }

    public function closeAllModals():Void {
        for(view in viewNameMap.keys()) {
            closeModal(view);
        }
    }

    public function openContextualMenu(name:String, ?dialogData: Dynamic = null):Void {
        uiRenderer.renderView(name, AnonFunc.call(onRenderComplete, [name, true]));
    }

    public function closeContextualMenu():Void {
        closeAllModals();
    }

}
