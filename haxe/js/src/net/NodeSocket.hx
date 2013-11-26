package net;

import io.InputOutputStream;
import io.InputStream;
import haxe.io.Bytes;
import io.StreamEventHandler;
import js.Node.NodeNetSocket;
import io.InputOutputStream;
import js.Node;
import js.Node.NodeBuffer;

class NodeSocket implements InputOutputStream {
    public var position(get, set): Int;

    public var bytesAvailable(get, null):Int;
    public var objectEncoding:Int;

    private var _socket: NodeNetSocket;
    private var _handler: StreamEventHandler;
    public var buffer: NodeBuffer;
    private var _pos: Int;

    public function new(socket: NodeNetSocket, handler: StreamEventHandler) {
        _socket = socket;
        _handler = handler;
        _socket.addListener("data", onData);
        _socket.addListener("close", onClose);
        _socket.addListener("error", onError);
        _handler.onConnect(this);
    }

    public function set_position(value:Int): Int {
        return 0;
    }

    public function get_position():Int {
        return 0;
    }

    private function get_bytesAvailable():Int {
        return bytesAvailable - _pos;
    }

    private function onData(e: NodeBuffer):Void {
        if(buffer == null) {
            buffer = e;
        } else {
            if(buffer.length == _pos) {
                buffer = e;
            } else {
                buffer = NodeBuffer.concat([buffer, e]);
            }
        }
        bytesAvailable = buffer.length;
        _pos = 0;
        _handler.onData(this);
    }

    private function onClose(e): Void {
        _handler.onDisconnect(this);
    }

    private function onError(e): Void {
        _handler.onError(this);
    }

    public function send(data: String): Void {
        _socket.write(data);
    }

    public function readBoolean():Bool {
        return false;
    }

    public function readByte():Int {
        return 0;
    }

    public function readBytes(bytes:InputOutputStream, offset:Int = 0, length:Int = 0):Void {
        bytes.writeBytes(this, offset + _pos, length + _pos);
        _pos += offset + length;
    }

    public function readDouble():Float {
        return 0;
    }

    public function readFloat():Float {
        var retVal: Float = buffer.readFloatLE(_pos);
        _pos += 4;
        return retVal;
    }

    public function readInt():Int {
        var retVal: Int = buffer.readInt32LE(_pos);
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
        var retVal: String = buffer.toString('utf8', _pos, length);
        _pos += length;
        return retVal;
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

    public function writeByte(value:Int):Void {
        var b = new NodeBuffer(1);
        b.writeInt8(value, 0);
        _socket.write(b);
    }

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

    public function writeBytes(bytes: InputOutputStream, offset: Int = 0, length: Int = 0): Void {
        cast (bytes).buffer.copy(buffer, _pos, offset, length);
    }

    public function clear(): Void {

    }
}