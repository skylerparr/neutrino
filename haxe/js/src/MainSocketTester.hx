package ;

import io.InputOutputStream;
import io.StreamEventHandler;
import net.NodeSocketServer;
import net.NodeSocketServer;
import net.NodeSocket;
import js.Node;
import js.Node.NodeNetServer;

class MainSocketTester {
    public function new() {
    }

    public static function main():Void {
        var socketServer:NodeSocketServer = new NodeSocketServer("localhost", 7100, new SampleHandler());
        socketServer.start();
    }
}


class SampleHandler implements StreamEventHandler {

    public function new():Void {
    }

    public function onConnect(stream:InputOutputStream):Void {
        trace("connected");
        stream.send("hi hi?");
    }

    public function onData(stream:InputOutputStream):Void {
        trace("data");
    }

    public function onError(stream:InputOutputStream):Void {
        trace("error");
    }

    public function onDisconnect(stream:InputOutputStream):Void {
        trace("disconnect!");
    }
}
