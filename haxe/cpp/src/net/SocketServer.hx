package net;
import io.StreamEventHandler;
import cpp.vm.Thread;
import sys.net.Socket;
import sys.net.Host;
class SocketServer {

    var server: Socket;
    private var _socketHandler: StreamEventHandler;
    private var _port: Int;
    private var _hostName: String;

    public function new(hostName: String, port: Int, socketHandler: StreamEventHandler) {
        server = new Socket();
        _socketHandler = socketHandler;
        _port = port;
        _hostName = hostName;
    }

    public function start(): Void {
        var thread: Thread = Thread.create(onThreadCreated);
        thread.sendMessage(Thread.current());
    }

    private function onThreadCreated(): Void {
        var main: Thread = Thread.readMessage (true);
        var host: Host = new Host(_hostName);
        try {
            server.bind(host, _port);
        } catch(e: Dynamic) {
            trace(e);
        }
        main.sendMessage("Socket ready");
        server.listen(10);
        while(true) {
            server.setBlocking(false);
            server.waitForRead();
            var clientSocket: Socket = server.accept();
            Thread.create(function(): Void {
                new BufferedWebSocket(clientSocket, _socketHandler);
            });
        }
    }

}
