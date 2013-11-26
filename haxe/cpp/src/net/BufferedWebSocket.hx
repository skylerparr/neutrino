package net;
import io.StreamEventHandler;
import io.InputOutputStream;
import haxe.io.Output;
import haxe.io.Error;
import haxe.io.BytesBuffer;
import io.InputStream;
import io.OutputStream;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.Input;
import haxe.io.Output;
import haxe.io.BytesInput;
import sys.net.Socket;

class BufferedWebSocket implements InputOutputStream {

    public var socketInput: Input;
    public var socketOutput: Output;

    private var _socket: Socket;
    private var _socketHandler: StreamEventHandler;
    private var _connected: Bool;
    private var _isFirstRead: Bool;
    private var _firstReadByte: Bytes;
    private var _buffer: Array<Bytes>;

    public var bytesAvailable(get,null) : Int;
    public var objectEncoding : Int;

    public var connected(get_connected, null): Bool;

    private function get_connected(): Bool {
        return _connected;
    }

    private function get_bytesAvailable(): Int {
        return bytesAvailable;
    }

    public function new(socket: Socket, handler: StreamEventHandler) {
        _socket = socket;
        _socketHandler = handler;
        _buffer = new Array<Bytes>();
        socketInput = _socket.input;
        socketOutput = _socket.output;
        _connected = true;
        _socket.setBlocking(false);
        handler.onConnect(this);
        while(connected) {
            _socket.waitForRead();
            _isFirstRead = true;
            fillBuffer();
            if(connected) {
                handler.onData(this);
            }
        }
    }

    public function close(): Void {
        if(connected) {
            _connected = false;
            _socket.close();
            _socketHandler.onDisconnect(this);
            _socket = null;
            _socketHandler = null;
            socketInput = null;
        }
    }

    public function read(): Bytes {
        try {
            var retVal: Bytes = socketInput.read(1);
            _isFirstRead = false;
            return retVal;
        } catch(e: Dynamic) {
            if(_isFirstRead) {
                close();
            }
        }
        return null;
    }

    private inline function readByteFromBuffer(num: Int = 1): Input {
        var byteBuffer: BytesBuffer = new BytesBuffer();
        for(i in 0...num) {
            byteBuffer.add(_buffer.shift());
        }
        bytesAvailable = _buffer.length;
        return new BytesInput(byteBuffer.getBytes());
    }

    private inline function fillBuffer(): Void {
        var readByte: Bytes = null;
        while(true) {
            readByte = read();
            if(readByte == null) {
                break;
            }
            _buffer.push(readByte);
        }
        bytesAvailable = _buffer.length;
    }

    public function readBoolean():Bool {
        return readByteFromBuffer().readByte() == 1 ? true : false;
    }

    public function readByte():Int {
        return readByteFromBuffer().readByte();
    }

    public function readBytes(bytes:InputStream, offset:Int = 0, length:Int = 0):Void {
        throw "unsupported";
    }

    public function readDouble():Float {
        return readByteFromBuffer(8).readDouble();
    }

    public function readFloat():Float {
        return readByteFromBuffer(4).readFloat();
    }

    public function readInt():Int {
        return readByteFromBuffer(4).readInt32();
    }

    public function readMultiByte(length:Int, charSet:String):String {
        return readUTFBytes(length);
    }

    public function readShort():Int {
        return readByteFromBuffer(2).readInt16();
    }

    public function readUTF():String {
        return readUTFBytes(1);
    }

    public function readUTFBytes(length:Int):String {
        return readByteFromBuffer(length).readString(length);
    }

    public function readUnsignedByte():Int {
        return socketInput.readByte();
    }

    public function readUnsignedInt():Int {
        return readInt();
    }

    public function readUnsignedShort():Int {
        return readShort();
    }

    public function writeBoolean( value:Bool ):Void {
        if(!_connected) {
            return;
        }
        if(value) {
            socketOutput.writeByte(1);
        } else {
            socketOutput.writeByte(0);
        }
    }

    public function writeByte( value:Int ):Void {
        if(!_connected) {
            return;
        }
        socketOutput.writeByte(value);
    }

    public function writeDouble( value:Float ):Void {
        if(!_connected) {
            return;
        }
        socketOutput.writeDouble(value);
    }

    public function writeFloat( value:Float ):Void {
        if(!_connected) {
            return;
        }
        socketOutput.writeFloat(value);
    }

    public function writeInt( value:Int ):Void {
        if(!_connected) {
            return;
        }
        socketOutput.writeInt32(value);
    }

    public function writeMultiByte( value:String, charSet:String ):Void {
        if(!_connected) {
            return;
        }
        socketOutput.writeString(value);
    }

    public function writeObject( object:Dynamic ):Void {
        trace("unsupported");
    }

    public function writeShort( value:Int ):Void {
        if(!_connected) {
            return;
        }
        socketOutput.writeInt16(value);
    }

    public function writeUTF( value:String ):Void {
        if(!_connected) {
            return;
        }
        socketOutput.writeString(value);
    }

    public function writeUTFBytes( value:String ):Void {
        if(!_connected) {
            return;
        }
        socketOutput.writeString(value);
    }

    public function writeUnsignedInt( value:Int ):Void {
        if(!_connected) {
            return;
        }
        socketOutput.writeUInt24(value);
    }

    public function writeBytes(bytes: InputOutputStream, offset: Int = 0, length: Int = 0): Void {

    }

    public function send(data: String): Void {
        writeUTFBytes(data);
        writeByte(0);
    }

    public function clear(): Void {

    }
}

