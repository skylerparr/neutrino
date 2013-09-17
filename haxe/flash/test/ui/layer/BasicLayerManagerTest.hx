package ui.layer;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;

using mockatoo.Mockatoo;

class BasicLayerManagerTest 
{
    private var _layerManager: BasicLayerManager;
    private var _topContainer: Sprite;

    public function new() {

    }

    @Before
    public function setup():Void {
        _topContainer = new Sprite();
        _layerManager = new BasicLayerManager(_topContainer);
    }

    @After
    public function tearDown():Void {
        _topContainer = null;
    }

    @Test
    public function shouldAddALayerByName(): Void {
        var layer: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer);
        Assert.areEqual(1, _topContainer.numChildren);
        Assert.areEqual(layer, _topContainer.getChildAt(0));
    }

    @Test
    public function shouldNotAddANullLayer(): Void {
        _layerManager.addLayerByName("layer1", null);
        Assert.areEqual(0, _topContainer.numChildren);
    }

    @Test
    public function shouldNotAddALayerNamedNull(): Void {
        var layer: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName(null, layer);
        Assert.areEqual(0, _topContainer.numChildren);
    }

    @Test
    public function shouldGetLayerByName(): Void {
        var layer: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer);
        Assert.areEqual(layer, _layerManager.getLayerByName("layer1"));
    }

    @Test
    public function shouldReturnNullIfLayerWasNotFound(): Void {
        var layer: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer);
        Assert.isNull(_layerManager.getLayerByName("layer2"));
    }
    
    @Test
    public function shouldNotReplaceALayerIfTheNameAlreadyExists(): Void {
        var layer: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer);
        _layerManager.addLayerByName("layer1", new Sprite());
        Assert.areEqual(1, _topContainer.numChildren);
        Assert.areEqual(layer, _topContainer.getChildAt(0));
    }

    @Test
    public function shouldGetLayerName(): Void {
        var layer: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer);
        Assert.areEqual("layer1", _layerManager.getLayerName(layer));
    }

    @Test
    public function shouldReturnNullIfLayerNotFound(): Void {
        var layer: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer);
        Assert.isNull(_layerManager.getLayerName(new Sprite()));
    }

    @Test
    public function shouldRemoveALayerByName(): Void {
        var layer: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer);
        _layerManager.removeLayerByName("layer1");
        Assert.areEqual(0, _topContainer.numChildren);
        Assert.isNull(_layerManager.getLayerByName("layer1"));
    }

    @Test
    public function shouldNotThrowExceptionIfRequestedLayerToRemoveIsNotFound(): Void {
        var layer: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer);
        _layerManager.removeLayerByName("layer2");
        Assert.areEqual(1, _topContainer.numChildren);
        Assert.areEqual(layer, _topContainer.getChildAt(0));
    }

    @Test
    public function shouldRemoveLayer(): Void {
        var layer: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer);
        _layerManager.removeLayer(layer);
        Assert.areEqual(0, _topContainer.numChildren);
        Assert.isNull(_layerManager.getLayerByName("layer1"));
    }

    @Test
    public function shouldNotThrowExceptionIfLayerWasNotFound(): Void {
        var layer: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer);
        _layerManager.removeLayer(new Sprite());
    }

    @Test
    public function shouldNotThrowExceptionIfRemoveLayerIsNull(): Void {
        var layer: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer);
        _layerManager.removeLayer(null);
    }

    @Test
    public function shouldAddLayersToTheTopOfEachNewLayer(): Void {
        var layer1: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer1);
        var layer2: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer2", layer2);
        var layer3: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer3", layer3);
        Assert.areEqual(3, _topContainer.numChildren);
        Assert.areEqual(layer1, _topContainer.getChildAt(0));
        Assert.areEqual(layer2, _topContainer.getChildAt(1));
        Assert.areEqual(layer3, _topContainer.getChildAt(2));
    }

    @Test
    public function shouldSquashTheLayersIfALayerIsRemoved(): Void {
        var layer1: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer1);
        var layer2: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer2", layer2);
        var layer3: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer3", layer3);
        Assert.areEqual(3, _topContainer.numChildren);
        _layerManager.removeLayer(layer2);
        Assert.areEqual(layer1, _topContainer.getChildAt(0));
        Assert.areEqual(layer3, _topContainer.getChildAt(1));

    }

    @Test
    public function shouldReturnAllLayers(): Void {
        var layer1: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer1", layer1);
        var layer2: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer2", layer2);
        var layer3: DisplayObjectContainer = new Sprite();
        _layerManager.addLayerByName("layer3", layer3);
        var allLayers: Array<DisplayObjectContainer> = _layerManager.getAllLayers();
        Assert.areEqual(3, allLayers.length);
        Assert.isTrue(isFound(layer1, allLayers));
        Assert.isTrue(isFound(layer2, allLayers));
        Assert.isTrue(isFound(layer3, allLayers));
    }

    private function isFound(layer: DisplayObjectContainer, collection: Array<DisplayObjectContainer>): Bool {
        for(item in collection) {
            if(layer == item) {
                return true;
            }
        }
        return false;
    }
}
