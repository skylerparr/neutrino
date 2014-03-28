package assets;
import data.ApplicationSettings;
import flash.net.URLRequest;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.IOErrorEvent;
import loader.AssetLoader;
class BasicAssetLoader implements AssetLoader {
    @inject
    public var applicationSettings: ApplicationSettings;

    private var _req: URLRequest;
    private var _loadQueue: Array<LoadDef>;
    private var _isLoading: Bool;
    private var _loadMap: Map<String, Array<LoadDef>>;

    public function new() {
        _req = new URLRequest();
        _loadQueue = [];
        _loadMap = new Map();
    }

    public function loadImage(imageName:String, onComplete:BitmapData -> Void, onFail:String -> Void = null):Void {
        load(imageName, function(loaded: Dynamic): Void {
            onComplete(loaded.bitmapData);
        }, onFail);
    }

    public function loadText(name:String, onComplete:String -> Void, onFail:String -> Void = null):Void {
        load(name, onComplete, onFail, true);
    }

    public function load(name:String, onComplete:Dynamic -> Void, onFail:String -> Void = null, loadText: Bool = false): Void {
        var loadDef: LoadDef = {imageName: name, onComplete: onComplete, onFail: onFail, loadText: loadText};
        if(_loadMap.exists(name)) {
            var collection: Array<LoadDef> = _loadMap.get(name);
            collection.push(loadDef);
            return;
        }
        _loadQueue.push(loadDef);
        _loadMap.set(name, [loadDef]);
        if(!_isLoading) {
            _isLoading = true;
            doLoad();
        }
    }

    private function doLoad(): Void {
        var loadDef: LoadDef = _loadQueue.shift();
        if(loadDef != null) {
            var loader: LoaderProxy = getLoader(loadDef.loadText);
            loader.addEventListener(Event.COMPLETE, function(e: Event): Void {
                var loadDefs: Array<LoadDef> = _loadMap.get(loadDef.imageName);
                for(def in loadDefs) {
                    def.onComplete(loader.content);
                }
                _loadMap.remove(loadDef.imageName);
                doLoad();
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR, function(e: IOErrorEvent): Void {
                if(loadDef.onFail != null) {
                    loadDef.onFail(e.text);
                }
                doLoad();
            });
            _req.url = getUrl(loadDef);
            loader.load(_req);
        } else {
            _isLoading = false;
        }
    }

    public function getUrl(loadDef: LoadDef): String {
        return applicationSettings.getBaseAssetsPath() + loadDef.imageName;
    }

    public function getLoader(loadText: Bool = false): LoaderProxy {
        if(loadText) {
            return new RealURLLoader();
        } else {
            return new RealLoader();
        }
    }
}

typedef LoadDef = {
    imageName: String,
    onComplete: Dynamic->Void,
    onFail: String->Void,
    loadText: Bool
}
