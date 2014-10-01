package core;
import data.DataConnection;
import io.InputOutputStream;
class ChannelManagerImpl implements ChannelManager {

    public var mainChannel(get, null): DataConnection;
    public var allChannels(get, null): Array<DataConnection>;

    private var _allChannels: Map<String, Array<DataConnection>>;
    private var _connectionIdMap: Map<DataConnection, Array<String>>;

    public function new() {
        _allChannels = new Map<String, Array<DataConnection>>();
        _connectionIdMap = new Map<DataConnection, Array<String>>();
    }

    private function get_mainChannel(): DataConnection {
        return null;
    }

    private function get_allChannels():Array<DataConnection> {
        var retVal: Array<DataConnection> = [];
        for(cxns in _allChannels) {
            retVal = retVal.concat(cxns);
        }
        return retVal;
    }

    public function getClientChannel(clientId:String):DataConnection {
        var connections: Array<DataConnection> = _allChannels.get(clientId);
        if(connections == null) {
            return null;
        }
        return connections[connections.length - 1];
    }

    public function addChannel(clientId: String, stream: DataConnection): Void {
        var connections: Array<DataConnection> = _allChannels.get(clientId);
        if(connections == null) {
            connections = [];
        }
        connections.push(stream);
        _allChannels.set(clientId, connections);
        var ids: Array<String> = _connectionIdMap.get(stream);
        if(ids == null) {
            ids = [];
        }
        ids.push(clientId);
        _connectionIdMap.set(stream, ids);
    }

    public function removeChannel(clientId: String): Void {
        _allChannels.remove(clientId);
    }

    public function exists(clientId:String):Bool {
        return _allChannels.exists(clientId);
    }

    public function getConnectionFromStream(stream:InputOutputStream): DataConnection {
        throw "not implemented";
        return null;
    }

    public function removeConnection(connection:DataConnection):Void {
        if(connection != null) {
            _connectionIdMap.remove(connection);
            for(channel in _allChannels) {
                if(channel != null) {
                    channel.remove(connection);
                }
            }
        }
    }

    public function getIdsFromConnection(connection:DataConnection):Array<String> {
        if(connection == null) {
            return null;
        }
        return _connectionIdMap.get(connection);
    }

}
