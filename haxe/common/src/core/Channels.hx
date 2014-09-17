package core;
import data.DataConnection;
import io.InputOutputStream;
interface Channels {
    var mainChannel(get, null): DataConnection;
    var allChannels(get, null): Array<DataConnection>;
    function getClientChannel(clientId: String): DataConnection;
}
