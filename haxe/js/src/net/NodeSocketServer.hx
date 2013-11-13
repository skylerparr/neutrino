package net;
import io.StreamEventHandler;
import js.Node;
import js.Node.NodeNetServer;
import net.NodeSocketServer;
import net.NodeSocket;

class NodeSocketServer {
    private var _port: Int;
    private var _socketHandler: StreamEventHandler;

    public function new(port: Int, socketHandler: StreamEventHandler) {
        _port = port;
        _socketHandler = socketHandler;
    }

    public function start():Void {
        var server: NodeNetServer = Node.net.createServer(function(s): Void {
            new NodeSocket(s, _socketHandler);
        });
        server.listen(_port, function(): Void {
            trace("socket server listening on " + _port);
        });
    }

}
