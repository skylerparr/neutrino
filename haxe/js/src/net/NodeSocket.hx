package net;

import haxe.io.Bytes;
import io.StreamEventHandler;
import js.Node.NodeNetSocket;
import io.InputOutputStream;
import js.Node;

class NodeSocket implements InputOutputStream {
    private var _socket: NodeNetSocket;
    private var _handler: StreamEventHandler;
    private var _buffer: Array<Bytes>;

    public function new(socket: NodeNetSocket, handler: StreamEventHandler) {
        _socket = socket;
        _handler = handler;
        _handler.onConnect(this);
        _buffer = new Array<Bytes>();
        _socket.addListener("data", onData);

    }

    private function onData(e):Void {
        trace("e = " + Type.getClass(e));
        _handler.onData(this);
    }

    public var bytesAvailable:Int;

    public var objectEncoding:Int;

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

    public function readDouble():Float {
        return 0;
    }

    public function readFloat():Float {
        return 0;
    }

    public function readInt():Int {
        return 0;
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
        return null;
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

    public function writeFloat(value:Float):Void {}

    public function writeInt(value:Int):Void {}

    public function writeMultiByte(value:String, charSet:String):Void {}

    public function writeObject(object:Dynamic):Void {}

    public function writeShort(value:Int):Void {}

    public function writeUTF(value:String):Void {}

    public function writeUTFBytes(value:String):Void {}

    public function writeUnsignedInt(value:Int):Void {}

}