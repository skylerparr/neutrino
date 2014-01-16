package assets;
import flash.net.URLLoader;
import flash.events.Event;
import flash.net.URLRequest;
class RealURLLoader implements LoaderProxy {
    private var _loader: URLLoader;

    public var content(get, set):Dynamic;

    public function new() {
        _loader = new URLLoader();
    }

    public function get_content():Dynamic {
        return cast _loader.data;
    }

    public function set_content(value:Dynamic): Dynamic {
        return null;
    }

    public function addEventListener(type:String, listener:Dynamic -> Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
        _loader.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    public function dispatchEvent(event:Event):Bool {
        return _loader.dispatchEvent(event);
    }

    public function hasEventListener(type:String):Bool {
        return _loader.hasEventListener(type);
    }

    public function removeEventListener(type:String, listener:Dynamic -> Void, useCapture:Bool = false):Void {
        _loader.removeEventListener(type, listener, useCapture);
    }

    public function willTrigger(type:String):Bool {
        return _loader.willTrigger(type);
    }

    public function load(urlRequest:URLRequest):Void {
        _loader.load(urlRequest);
    }
}
