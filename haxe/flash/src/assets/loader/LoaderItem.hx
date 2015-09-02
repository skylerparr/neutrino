package assets.loader;
import flash.display.Bitmap;
import openfl.events.IEventDispatcher;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.system.ApplicationDomain;
import openfl.system.LoaderContext;
import openfl.net.URLRequest;
import openfl.display.Loader;
class LoaderItem extends AbstractLoader {

    private var loader: Loader;
    private var _url: String;
    public var success: AbstractLoader->Void;
    public var failFunction: AbstractLoader->Void;
    private var bytesTotal: Float;
    private var bytesLoaded: Float;
    private var paused: Bool;
    private var loadComplete: Bool;
    public var url(default, set): String;

    private function set_url(value: String): String {
        _url = value;
        return _url;
    }

    override public function getUrl(): String {
        return _url;
    }

    override public function getApplicationDomain(): ApplicationDomain {
        return loader.contentLoaderInfo.applicationDomain;
    }

    public function new() {
        super();
    }

    override public function start(success: AbstractLoader->Void, failFunction: AbstractLoader->Void): Void {
        this.success = success;
        this.failFunction = failFunction;
        loader = new Loader();
        setupEvents();

        loadUrl();
    }

    public function loadUrl(): Void {
        var request: URLRequest = new URLRequest(_url);
        var context: LoaderContext = getLoaderContext();
        loader.load(request, context);
    }

    public function getLoaderContext(): LoaderContext {
        return new LoaderContext(true, ApplicationDomain.currentDomain);
    }

    public function setupEvents(): Void {
        getDispatcher().addEventListener(Event.COMPLETE, onLoadComplete);
        getDispatcher().addEventListener(IOErrorEvent.IO_ERROR, onError);
        getDispatcher().addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
        getDispatcher().addEventListener(ProgressEvent.PROGRESS, onProgress);
    }

    private function onProgress(event: ProgressEvent): Void {
        bytesTotal = event.bytesTotal;
        bytesLoaded = event.bytesLoaded;
    }

    public function cleanEvents(): Void {
        getDispatcher().removeEventListener(Event.COMPLETE, onLoadComplete);
        getDispatcher().removeEventListener(IOErrorEvent.IO_ERROR, onError);
        getDispatcher().removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
        getDispatcher().removeEventListener(ProgressEvent.PROGRESS, onProgress);
    }

    private function onError(event: IOErrorEvent): Void {
        cleanEvents();
        if(failFunction != null) {
            failFunction(this);
            failFunction = null;
        }
    }

    public function onLoadComplete(event: Event): Void {
        cleanEvents();
        if ( paused ) {
            loadComplete = true;
            return;
        }
        success(this);
        success = null;
    }

    public function setSuccess(value: AbstractLoader->Void): Void {
        success = value;
    }

    public function setFailFunction(value: AbstractLoader->Void): Void {
        failFunction = value;
    }

    override public function unload(): Void {
        setupEvents();
//        loader.unloadAndStop(true);
        if ( loader.parent != null ) {
            loader.parent.removeChild(loader);
        }
        dispose();
    }

    public function getDispatcher(): IEventDispatcher {
        return loader.contentLoaderInfo;
    }

    override public function getContent(): Dynamic {
        return loader.content;
    }

    override public function pause(): Void {
        paused = true;
    }

    override public function resume(): Void {
        paused = false;
        if ( loadComplete ) {
            onLoadComplete(null);
        }
    }

    override public function stop(): Void {
        unload();
    }

    public function get_progress(): Float {
        return bytesLoaded / bytesTotal;
    }

    public function get_bytesTotal(): Float {
        return bytesTotal;
    }

    public function get_bytesLoaded(): Float {
        return bytesLoaded;
    }

    public inline function dispose(): Void {
        cleanEvents();
        loader = null;
        success = null;
        failFunction = null;
    }
}
