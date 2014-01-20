package data;
import data.DataConnection;
interface SocketConnector extends DataConnection {
    function connect(ipAddress: String, port: Int, connectCallback: Void -> Void, disconnectCallback: Void->Void = null): Void;
}
