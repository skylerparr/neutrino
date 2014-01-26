package util;
class MapSubscriber implements Subscriber {

    private var _subscribeMap: Map<String, List<Dynamic>>;

    public function new() {
        _subscribeMap = new Map();
    }

    public function subscribe(name:String, handler:Dynamic):Void {
        var handlers: List<Dynamic> = _subscribeMap.get(name);
        if(handlers == null) {
            handlers = new List<Dynamic>();
        }
        handlers.push(handler);
        _subscribeMap.set(name, handlers);
    }

    public function unSubscribe(name:String, handler:Dynamic):Void {
        var handlers: List<Dynamic> = _subscribeMap.get(name);
        if(handlers != null) {
            handlers.remove(handler);
            if(handlers.length == 0) {
                _subscribeMap.remove(name);
            }
        }
    }

    public function notify(name:String, ?args: Array<Dynamic> = null):Void {
        var handlers: List<Dynamic> = _subscribeMap.get(name);
        if(handlers != null) {
            for(handler in handlers) {
                Reflect.callMethod(null, handler, args);
            }
        }
    }
}
