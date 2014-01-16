package assets;
import flash.net.URLRequest;
import flash.display.Bitmap;
import flash.events.IEventDispatcher;
interface LoaderProxy extends IEventDispatcher {
    var content(get, set): Dynamic;
    function load(urlRequest: URLRequest): Void;
}
