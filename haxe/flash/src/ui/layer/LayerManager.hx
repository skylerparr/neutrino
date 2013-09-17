package ui.layer;
import flash.display.DisplayObjectContainer;
interface LayerManager {
   /**
    * Every new layer goes on top.  So layers are added from background to foreground
    */
    function addLayerByName(name: String, layer: DisplayObjectContainer): Void;

    function getLayerByName(name: String): DisplayObjectContainer;

    function getLayerName(layer: DisplayObjectContainer): String;

    function removeLayerByName(name: String): Void;

    function removeLayer(layer: DisplayObjectContainer): Void;

    function getAllLayers(): Array<DisplayObjectContainer>;
}
