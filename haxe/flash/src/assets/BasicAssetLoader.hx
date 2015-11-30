package assets;
import assets.loader.URLLoaderItem;
import assets.loader.LoaderItem;
import assets.loader.AbstractLoader;
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
    private var _loadMap: Map<String, Array<LoadDef>>;

    public function new() {
        _req = new URLRequest();
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
        _loadMap.set(name, [loadDef]);
        doLoad(loadDef);
    }

    private inline function doLoad(loadDef: LoadDef): Void {
        var loader: AbstractLoader = getLoader(getUrl(loadDef), loadDef.loadText);
        loader.start(function(l: AbstractLoader): Void {
            var loadDefs: Array<LoadDef> = _loadMap.get(loadDef.imageName);
            for(def in loadDefs) {
                def.onComplete(loader.getContent());
            }
            _loadMap.remove(loadDef.imageName);
        }, function(l: AbstractLoader): Void {
            trace("load failed");
            if(loadDef.onFail != null) {
                loadDef.onFail("load failed");
            }
        });
    }

    public function getUrl(loadDef: LoadDef): String {
        return applicationSettings.getBaseAssetsPath() + loadDef.imageName;
    }

    public function getLoader(url: String, loadText: Bool = false): AbstractLoader {
        if(loadText) {
            var l = new URLLoaderItem();
            l.url = url;
            return l;
        } else {
            var l = new LoaderItem();
            l.url = url;
            return l;
        }
    }
}

typedef LoadDef = {
    imageName: String,
    onComplete: Dynamic->Void,
    onFail: String->Void,
    loadText: Bool
}
