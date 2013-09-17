package ui.layer;
import flash.display.DisplayObjectContainer;
class BasicLayerManager implements LayerManager {

    private var _topContainer: DisplayObjectContainer;
    private var _layerMap: Map<String, DisplayObjectContainer>;

    public function new(topContainer: DisplayObjectContainer) {
        _topContainer = topContainer;
        _layerMap = new Map<String, DisplayObjectContainer>();
    }

    public function addLayerByName(name:String, layer:DisplayObjectContainer):Void {
        if(layer == null || name == null) {
            return;
        }
        if(_layerMap.exists(name)) {
            return;
        }
        layer.name = name;
        _topContainer.addChild(layer);
        _layerMap.set(name, layer);
    }

    public function getLayerByName(name:String):DisplayObjectContainer {
        return _layerMap.get(name);
    }

    public function getLayerName(layer:DisplayObjectContainer):String {
        for(name in _layerMap.keys()) {
            var searchLayer: DisplayObjectContainer = _layerMap.get(name);
            if(layer == searchLayer) {
                return name;
            }
        }
        return null;
    }

    public function removeLayerByName(name:String):Void {
        var layer: DisplayObjectContainer = _layerMap.get(name);
        if(layer != null) {
            _topContainer.removeChild(layer);
            _layerMap.remove(name);
        }
    }

    public function removeLayer(layer:DisplayObjectContainer):Void {
        var layerName: String = getLayerName(layer);
        removeLayerByName(layerName);
    }

    public function getAllLayers():Array<DisplayObjectContainer> {
        var retVal: Array<DisplayObjectContainer> = [];
        for(layer in _layerMap) {
            retVal.push(layer);
        }
        return retVal;
    }
}
