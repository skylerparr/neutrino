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

    public function new() {
        _req = new URLRequest();
        _loadQueue = [];
    }

    public function loadImage(imageName:String, onComplete:BitmapData -> Void, onFail:String -> Void = null):Void {
        load(imageName, function(loaded: Dynamic): Void {
            onComplete(loaded.bitmapData);
        }, onFail);
    }

    public function loadText(name:String, onComplete:String -> Void, onFail:String -> Void = null):Void {
        load(name, onComplete, onFail, true);
    }

    private inline function load(name:String, onComplete:Dynamic -> Void, onFail:String -> Void = null, loadText: Bool = false): Void {
        _loadQueue.push({imageName: name, onComplete: onComplete, onFail: onFail, loadText: loadText});
        if(!_isLoading) {
            _isLoading = true;
            doLoad(loadText);
        }
    }

    private function doLoad(loadText: Bool = false): Void {
        var loadDef: LoadDef = _loadQueue.shift();
        if(loadDef != null) {
            var loader: LoaderProxy = getLoader(loadDef.loadText);
            loader.addEventListener(Event.COMPLETE, function(e: Event): Void {
                loadDef.onComplete(loader.content);
                doLoad(loadDef.loadText);
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR, function(e: IOErrorEvent): Void {
                if(loadDef.onFail != null) {
                    loadDef.onFail(e.text);
                }
                doLoad(loadDef.loadText);
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
