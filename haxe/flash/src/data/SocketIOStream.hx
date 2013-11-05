package data;
import flash.utils.ByteArray;
import io.InputStream;
import flash.utils.Endian;
import flash.events.IOErrorEvent;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.net.Socket;
import io.StreamEventHandler;
import io.OutputStream;
import io.InputOutputStream;
class SocketIOStream implements InputOutputStream {

    public var bytesAvailable(get,null) : Int;
    public var objectEncoding : Int;

    private var _socket: Socket;
    private var _onConnected: Void->Void;
    private var _handler: StreamEventHandler;

    public function new() {
    }

    private function get_bytesAvailable(): Int {
        return _socket.bytesAvailable;
    }

    public function dispose(): Void {
        _socket.close();
        _socket.addEventListener(ProgressEvent.SOCKET_DATA, onDataReceived);
        _socket.addEventListener(Event.CONNECT, onConnect);
        _socket.addEventListener(Event.CLOSE, onDisconnect);
        _socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        _handler.onDisconnect(this);
        _handler = null;
        _socket = null;
    }

    public function connect(host: String, port: Int, handler: StreamEventHandler, onConnected: Void->Void = null): Void {
        _handler = handler;
        _onConnected = onConnected;
        _socket = new Socket();
        _socket.endian = Endian.LITTLE_ENDIAN;
        _socket.addEventListener(ProgressEvent.SOCKET_DATA, onDataReceived);
        _socket.addEventListener(Event.CONNECT, onConnect);
        _socket.addEventListener(Event.CLOSE, onDisconnect);
        _socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        _socket.connect(host, port);
    }

    public function flush(): Void {
        _socket.flush();
    }

    private function onDataReceived(e: ProgressEvent): Void {
        _handler.onData(this);
    }

    private function onConnect(e:Event):Void {
        if(_onConnected != null) {
            _onConnected();
        }
        _handler.onConnect(this);
    }

    private function onDisconnect(e:Event):Void {
        _handler.onDisconnect(this);
    }

    private function onIOError(e:IOErrorEvent):Void {
        _handler.onError(this);
    }

    public function readBoolean():Bool {
        return _socket.readBoolean();
    }

    public function readByte():Int {
        return _socket.readByte();
    }

    public function readBytes(bytes:InputStream, offset:Int = 0, length:Int = 0):Void {
        _socket.readBytes(cast(bytes, ByteArrayIOStream).byteArray, offset, length);
        cast(bytes, ByteArrayIOStream).byteArray.position = 0;
    }

    public function readDouble():Float {
        return _socket.readDouble();
    }

    public function readFloat():Float {
        return _socket.readFloat();
    }

    public function readInt():Int {
        return _socket.readInt();
    }

    public function readMultiByte(length:Int, charSet:String):String {
        return _socket.readMultiByte(length, charSet);
    }

    public function readShort():Int {
        return _socket.readShort();
    }

    public function readUTF():String {
        return _socket.readUTF();
    }

    public function readUTFBytes(length:Int):String {
        return _socket.readUTFBytes(length);
    }

    public function readUnsignedByte():Int {
        return _socket.readUnsignedByte();
    }

    public function readUnsignedInt():Int {
        return _socket.readUnsignedInt();
    }

    public function readUnsignedShort():Int {
        return _socket.readUnsignedShort();
    }

    public function writeBoolean(value:Bool):Void {
        _socket.writeBoolean(value);
    }

    public function writeByte(value:Int):Void {
        _socket.writeByte(value);
    }

    public function writeDouble(value:Float):Void {
        _socket.writeDouble(value);
    }

    public function writeFloat(value:Float):Void {
        _socket.writeFloat(value);
    }

    public function writeInt(value:Int):Void {
        _socket.writeInt(value);
    }

    public function writeMultiByte(value:String, charSet:String):Void {
        _socket.writeMultiByte(value, charSet);
    }

    public function writeObject(object:Dynamic):Void {
        #if flash
        _socket.writeObject(object);
        #end
    }

    public function writeShort(value:Int):Void {
        _socket.writeShort(value);
    }

    public function writeUTF(value:String):Void {
        _socket.writeUTF(value);
    }

    public function writeUTFBytes(value:String):Void {
        _socket.writeUTFBytes(value);
    }

    public function writeUnsignedInt(value:Int):Void {
        _socket.writeUnsignedInt(value);
    }

    public function send(data: String): Void {
        writeUTFBytes(data);
    }

}
