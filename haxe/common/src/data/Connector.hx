package data;
import data.DataConnection;
interface Connector extends DataConnection {
    var connected(get, null): Bool;
    function connect(connectCallback: String -> Void): Void;
}
