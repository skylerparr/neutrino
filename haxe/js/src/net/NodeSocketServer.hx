package net;
import js.node.net.Server;
import js.Node;
import io.StreamEventHandler;

class NodeSocketServer {
    private var _port: Int;
    private var _socketHandler: StreamEventHandler;

    public function new(port: Int, socketHandler: StreamEventHandler) {
        _port = port;
        _socketHandler = socketHandler;
    }

    public function start():Void {
        var server: Server = js.node.Net.createServer(function(s): Void {
            trace("connected to server");
            new NodeSocket(s, _socketHandler);
        });
        server.listen(_port, function(): Void {
            trace("socket server listening on " + _port);
        });
    }

}
