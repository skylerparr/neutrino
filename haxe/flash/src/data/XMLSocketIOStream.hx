package data;
import io.InputStream;
import io.StreamEventHandler;
import io.InputOutputStream;
import flash.net.XMLSocket;
import flash.events.IOErrorEvent;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.EventDispatcher;

class XMLSocketIOStream implements InputOutputStream {
    @:isVar
    public var position(get, set): Int;

    public var bytesAvailable(get,null) : Int;
    public var objectEncoding : Int;

    private var _xmlSocket: XMLSocket;
    private var _buffer: String;
    private var _handler: StreamEventHandler;
    private var _onConnected: Void->Void;

    public function new() {
    }

    public function set_position(value:Int): Int {
        this.position = value;
        return position;
    }

    public function get_position():Int {
        return position;
    }

    private function get_bytesAvailable(): Int {
        return bytesAvailable;
    }

    public function dispose(): Void {
        _xmlSocket.close();
        _xmlSocket.addEventListener(DataEvent.DATA, onDataReceived);
        _xmlSocket.addEventListener(Event.CONNECT, onConnect);
        _xmlSocket.addEventListener(Event.CLOSE, onDisconnect);
        _xmlSocket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        _handler.onDisconnect(this);
        _handler = null;
        _buffer = null;
        _xmlSocket = null;
    }

    public function connect(host: String, port: Int, handler: StreamEventHandler, onConnected: Void->Void = null): Void {
        _handler = handler;
        _onConnected = onConnected;
        _xmlSocket = new XMLSocket();
        _xmlSocket.addEventListener(DataEvent.DATA, onDataReceived);
        _xmlSocket.addEventListener(Event.CONNECT, onConnect);
        _xmlSocket.addEventListener(Event.CLOSE, onDisconnect);
        _xmlSocket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        _xmlSocket.connect(host, port);
    }

    private function onConnect(e:Event):Void {
        if(_onConnected != null) {
            _onConnected();
        }
        _handler.onConnect(this);
    }

    private function onDataReceived(de:DataEvent):Void {
        _buffer = de.data;
        _handler.onData(this);
    }

    private function onDisconnect(e:Event):Void {
        _handler.onDisconnect(this);
    }

    private function onIOError(ioee:IOErrorEvent):Void {
        _handler.onError(this);
    }

    public function send(data: String): Void {
        if(_xmlSocket.connected) {
            _xmlSocket.send(data);
        }
    }

    public function readUTF():String {
        var tmp: String = _buffer;
        _buffer = null;
        return tmp;
    }

    public function readUTFBytes(length:Int):String {
        throw("not supported, use readUTF");
        return "";
    }

    public function readBoolean():Bool {
        throw("not supported, use readUTF");
        return false;
    }

    public function readByte():Int {
        throw("not supported, use readUTF");
        return 0;
    }

    public function readBytes(bytes:InputStream, offset:Int = 0, length:Int = 0):Void {
        throw("not supported, use readUTF");
    }

    public function readDouble():Float {
        throw("not supported, use readUTF");
        return 0;
    }

    public function readFloat():Float {
        throw("not supported, use readUTF");
        return 0;
    }

    public function readInt():Int {
        throw("not supported, use readUTF");
        return 0;
    }

    public function readMultiByte(length:Int, charSet:String):String {
        throw("not supported, use readUTF");
        return "";
    }

    public function readShort():Int {
        throw("not supported, use readUTF");
        return 0;
    }

    public function readUnsignedByte():Int {
        throw("not supported, use readUTF");
        return 0;
    }

    public function readUnsignedInt():Int {
        throw("not supported, use readUTF");
        return 0;
    }

    public function readUnsignedShort():Int {
        throw("not supported, use readUTF");
        return 0;
    }

    public function writeBoolean(value:Bool):Void {
        throw("not supported, use send");
    }

    public function writeByte(value:Int):Void {
        throw("not supported, use send");
    }

    public function writeDouble(value:Float):Void {
        throw("not supported, use send");
    }

    public function writeFloat(value:Float):Void {
        throw("not supported, use send");
    }

    public function writeInt(value:Int):Void {
        throw("not supported, use send");
    }

    public function writeMultiByte(value:String, charSet:String):Void {
        throw("not supported, use send");
    }

    public function writeObject(object:Dynamic):Void {
        throw("not supported, use send");
    }

    public function writeShort(value:Int):Void {
        throw("not supported, use send");
    }

    public function writeUTF(value:String):Void {
        throw("not supported, use send");
    }

    public function writeUTFBytes(value:String):Void {
        throw("not supported, use send");
    }

    public function writeBytes(bytes: InputOutputStream, offset: Int = 0, length: Int = 0): Void {
        throw("not supported, use send");
    }

    public function writeUnsignedInt(value:Int):Void {
        throw("not supported, use send");
    }

    public function clear(): Void {

    }
}
