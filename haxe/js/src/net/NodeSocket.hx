package net;

import io.InputStream;
import haxe.io.Bytes;
import io.StreamEventHandler;
import js.Node.NodeNetSocket;
import io.InputOutputStream;
import js.Node;

class NodeSocket implements InputOutputStream {
    public var bytesAvailable(get, null):Int;
    public var objectEncoding:Int;

    private var _socket: NodeNetSocket;
    private var _handler: StreamEventHandler;
    private var _buffer: NodeBuffer;
    private var _pos: Int;

    public function new(socket: NodeNetSocket, handler: StreamEventHandler) {
        _socket = socket;
        _handler = handler;
        _socket.addListener("data", onData);
        _socket.addListener("close", onClose);
        _handler.onConnect(this);
    }

    private function get_bytesAvailable():Int {
        return bytesAvailable;
    }

    private function onData(e):Void {
        _buffer = e;
        _pos = 0;
        bytesAvailable = e.length;
        _handler.onData(this);
    }

    private function onClose(e): Void {
        _handler.onDisconnect(this);
    }

    public function send(data: String): Void {
        _socket.write(data);
        var b = new NodeBuffer(1);
        b.writeInt8(0, 0);
        _socket.write(b);
    }

    public function readBoolean():Bool {
        return false;
    }

    public function readByte():Int {
        return 0;
    }

    public function readBytes(bytes:InputStream, offset:Int = 0, length:Int = 0):Void {
    }

    public function readDouble():Float {
        return 0;
    }

    public function readFloat():Float {
        var retVal: Float = _buffer.readFloatLE(_pos);
        _pos += 4;
        return retVal;
    }

    public function readInt():Int {
        var retVal: Int = _buffer.readInt32LE(_pos);
        _pos += 4;
        return retVal;
    }

    public function readMultiByte(length:Int, charSet:String):String {
        return null;
    }

    public function readShort():Int {
        return 0;
    }

    public function readUTF():String {
        return null;
    }

    public function readUTFBytes(length:Int):String {
        return _buffer.toString('utf8', 0, length - 1);
    }

    public function readUnsignedByte():Int {
        return 0;
    }

    public function readUnsignedInt():Int {
        return 0;
    }

    public function readUnsignedShort():Int {
        return 0;
    }

    public function writeBoolean(value:Bool):Void {}

    public function writeByte(value:Int):Void {}

    public function writeDouble(value:Float):Void {}

    public function writeFloat(value:Float):Void {
        var b = new NodeBuffer(4);
        b.writeFloatLE(value, 0);
        _socket.write(b);
    }

    public function writeInt(value:Int):Void {
        var b = new NodeBuffer(4);
        b.writeInt32LE(value, 0);
        _socket.write(b);
    }

    public function writeMultiByte(value:String, charSet:String):Void {}

    public function writeObject(object:Dynamic):Void {}

    public function writeShort(value:Int):Void {}

    public function writeUTF(value:String):Void {}

    public function writeUTFBytes(value:String):Void {}

    public function writeUnsignedInt(value:Int):Void {}

}