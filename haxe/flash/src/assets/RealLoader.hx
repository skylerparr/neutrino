package assets;
import flash.net.URLRequest;
import flash.display.Loader;
import flash.events.Event;
class RealLoader implements LoaderProxy {

    private var _loader: Loader;

    public var content(get, set):Dynamic;

    public function new() {
        _loader = new Loader();
    }

    public function get_content():Dynamic {
        return cast _loader.content;
    }

    public function set_content(value:Dynamic): Dynamic {
        return null;
    }

    public function addEventListener(type:String, listener:Dynamic -> Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
        trace("adding event listener");
        _loader.contentLoaderInfo.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    public function dispatchEvent(event:Event):Bool {
        return _loader.contentLoaderInfo.dispatchEvent(event);
    }

    public function hasEventListener(type:String):Bool {
        return _loader.contentLoaderInfo.hasEventListener(type);
    }

    public function removeEventListener(type:String, listener:Dynamic -> Void, useCapture:Bool = false):Void {
        _loader.contentLoaderInfo.removeEventListener(type, listener, useCapture);
    }

    public function willTrigger(type:String):Bool {
        return _loader.contentLoaderInfo.willTrigger(type);
    }

    public function load(urlRequest:URLRequest):Void {
        _loader.load(urlRequest);
    }
}
