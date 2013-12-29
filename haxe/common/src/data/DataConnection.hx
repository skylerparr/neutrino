package data;
interface DataConnection {
    function subscribe(action: String, handler: TransferVO -> Void): Void;
    function unSubscribe(action: String, handler: TransferVO -> Void): Void;
    function send(action: String, data: Dynamic): Void;
}
