package util;
interface Subscriber {
    function subscribe(name: String, handler: Dynamic): Void;
    function unSubscribe(name: String, handler: Dynamic): Void;
    function notify(name: String, args: Array<Dynamic> = null): Void;
}
