package assets.loader;
import openfl.net.URLLoaderDataFormat;
import openfl.events.IEventDispatcher;
import openfl.net.URLRequestHeader;
import flash.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.net.URLLoader;
class URLLoaderItem extends LoaderItem {

    private var _urlLoader: URLLoader;
    private var _dataFormat: URLLoaderDataFormat = URLLoaderDataFormat.TEXT;
    private var _method: String = URLRequestMethod.GET;
    private var _postVars: Dynamic = {};
    private var _header: Array<URLRequestHeader> = [];
    private var _urlRequest: URLRequest;

    public function new() {
        super();
    }

    override public function start(success: AbstractLoader->Void, failFunction: AbstractLoader->Void): Void {
        this.success = success;
        this.failFunction = failFunction;
        _urlLoader = new URLLoader();
        _urlLoader.dataFormat = _dataFormat;
        setupEvents();

        _urlRequest = getUrlRequest();
        _urlRequest.url = getUrl();
        _urlRequest.method = _method;
        _urlRequest.data = _postVars;
        _urlRequest.requestHeaders = _header;

        loadUrl();
    }

    public function getUrlLoader(): URLLoader {
        return _urlLoader;
    }

    public function getDataFormat(): URLLoaderDataFormat {
        return _dataFormat;
    }

    public function setDataFormat(value: URLLoaderDataFormat): Void {
        _dataFormat = value;
    }

    public function getMethod(): String {
        return _method;
    }

    public function setMethod( value: String ): Void {
        _method = value;
    }

    public function setPostVars( postVars: Dynamic ): Void {
        _postVars = postVars;
    }

    public function getPostVars(): Dynamic {
        return _postVars;
    }

    public function addHeader(key: String, value: String): Void {
        if(_header == null) {
            _header = new Array<URLRequestHeader>();
        }
        _header.push(new URLRequestHeader(key, value));
    }

    public function getHeader(): Array<URLRequestHeader> {
        return _header;
    }

    override public function loadUrl(): Void {
        _urlLoader.load(_urlRequest);
    }

    public function getUrlRequest(): URLRequest {
        return new URLRequest();
    }

    override public function getDispatcher(): IEventDispatcher {
        return _urlLoader;
    }

    override public function getContent(): Dynamic {
        return _urlLoader.data;
    }

    override public function unload(): Void {
        try {
            _urlLoader.close();
        } catch(e: Dynamic) {
            trace("Error while stopping url loader" + e.message);
        }
        dispose();
    }
}
