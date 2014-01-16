package assets;
import loader.AssetLoader;
import data.ApplicationSettings;
import flash.display.Bitmap;
import flash.display.BitmapData;
class CachedAssetLocator implements AssetLocator {

    @inject
    public var assetLoader: AssetLoader;

    private var _cacheMap: Map<String, CacheCount>;
    private var _loading: Map<String, Array<BitmapData->Void>>;
    private var _loadedSubscriptions: Array<Void->Void>;
    private var _assetsLoading: Array<String>;

    public function new() {
        _cacheMap = new Map<String, CacheCount>();
        _loading = new Map<String, Array<BitmapData->Void>>();
        _loadedSubscriptions = [];
        _assetsLoading = [];
    }

    public function getAssetByName(name:String, onComplete:BitmapData -> Void):Void {
        var cacheCount: CacheCount = _cacheMap.get(name);
        if(cacheCount != null) {
            cacheCount.count++;
            onComplete(cacheCount.bitmapData);
            notifySubscribers();
        } else {
            var load: Array<BitmapData->Void> =_loading.get(name);
            if(load == null) {
                load = [];
            }
            load.push(onComplete);
            _loading.set(name, load);
            if(load.length == 1) {
                _assetsLoading.push(name);
                loadImage(name, cacheCount);
            }
        }
    }

    public function loadImage(name: String, cacheCount: CacheCount): Void {
        assetLoader.loadImage(name, function(bitmapData: BitmapData): Void {
            cacheImage(name, cacheCount, bitmapData);
        }, function(msg: String): Void {
            trace(msg);
            cacheImage(name, cacheCount, null);
        });
    }

    public function cacheImage(name: String, cacheCount: CacheCount, bitmapData: BitmapData) {
        _assetsLoading.remove(name);
        cacheCount = {count: 1, bitmapData: bitmapData};
        _cacheMap.set(name, cacheCount);
        var load: Array<BitmapData->Void> =_loading.get(name);
        for(complete in load) {
            complete(bitmapData);
        }
        _loading.remove(name);
        notifySubscribers();
    }

    public function getLazyAsset(name:String, onComplete:BitmapData -> Void = null):Bitmap {
        var bitmap: Bitmap = new Bitmap();
        bitmap.smoothing = true;
        getAssetByName(name, function(bitmapData: BitmapData): Void {
            bitmap.bitmapData = bitmapData;
            if(onComplete != null) {
                onComplete(bitmapData);
            }
        });
        return bitmap;
    }

    public function getDataAssetByName(name:String, onComplete:String -> Void):Void {
        assetLoader.loadText(name, onComplete, function(message: String): Void {
            trace("unable to load text " + name + " : " + message);
        });
    }

    public function disposeAsset(name:String):Void {
        var cacheCount: CacheCount = _cacheMap.get(name);
        cacheCount.count--;
        if(cacheCount.count == 0) {
            cacheCount.bitmapData.dispose();
            _cacheMap.remove(name);
        }
    }

    public function subscribeAllAssetsLoaded(onComplete:Void -> Void):Void {
        _loadedSubscriptions.remove(onComplete);
        _loadedSubscriptions.push(onComplete);
        notifySubscribers();
    }

    public function unSubscribeAllAssetsLoaded(onComplete:Void -> Void):Void {
        _loadedSubscriptions.remove(onComplete);
    }

    private inline function notifySubscribers(): Void {
        if(_assetsLoading.length == 0) {
            for(cb in _loadedSubscriptions) {
                cb();
            }
        }
    }
}

typedef CacheCount = {
    count: Int,
    bitmapData: BitmapData
}