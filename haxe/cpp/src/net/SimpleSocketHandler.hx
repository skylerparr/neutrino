package net;
import io.StreamEventHandler;
import io.InputOutputStream;
import io.OutputStream;
import io.InputStream;
class SimpleSocketHandler implements StreamEventHandler {

    private var _webSocket: InputOutputStream;

    public function new() {
    }

    public function onConnect(webSocket: InputOutputStream):Void {
        trace("connected");
        _webSocket = webSocket;
    }

    public function onData(webSocket: InputOutputStream):Void {
        trace(webSocket.readUTFBytes(webSocket.bytesAvailable));
        trace("writing");
        _webSocket.send("blarg");
    }

    public function onError(webSocket: InputOutputStream):Void {
    }

    public function onDisconnect(webSocket: InputOutputStream):Void {
        trace("Disconnected");
    }


}
