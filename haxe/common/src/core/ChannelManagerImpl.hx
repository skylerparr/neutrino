package core;
import data.DataConnection;
import io.InputOutputStream;
class ChannelManagerImpl implements ChannelManager {

    public var mainChannel(get, null): DataConnection;

    private var _allChannels: Map<String, DataConnection>;

    public function new() {
        _allChannels = new Map<String, DataConnection>();
    }

    private function get_mainChannel(): DataConnection {
        return null;
    }

    public function getClientChannel(clientId:String):DataConnection {
        return _allChannels.get(clientId);
    }

    public function addChannel(clientId: String, stream: DataConnection): Void {
        _allChannels.set(clientId, stream);
    }

    public function removeChannel(clientId: String): Void {
        _allChannels.remove(clientId);
    }

    public function exists(clientId:String):Bool {
        return _allChannels.exists(clientId);
    }

}
