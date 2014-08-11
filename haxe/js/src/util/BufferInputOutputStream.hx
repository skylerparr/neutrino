package util;
import io.InputOutputStream;
import io.OutputStream;
import io.InputStream;
import io.InputOutputStream;
import js.Node;

class BufferInputOutputStream implements InputOutputStream {
    public var position(get, set): Int;
    @:isVar
    public var bytesAvailable(get,null) : Int;
    public var objectEncoding : Int;

    public var buffer: NodeBuffer;
    private var _pos: Int;

    private var _bufferSize: Int;

    public function new() {
        _bufferSize = 128;
        buffer = new NodeBuffer(_bufferSize);
        bytesAvailable = 0;
        _pos = 0;
    }

    public function set_position(value:Int): Int {
        _pos = value;
        return _pos;
    }

    public function get_position():Int {
        return _pos;
    }

    private function get_bytesAvailable():Int {
        return bytesAvailable - _pos;
    }

    public function readBoolean():Bool {
        return false;
    }

    public function readByte():Int {
        return 0;
    }

    public function readBytes(bytes:InputOutputStream, offset:Int = 0, length:Int = 0):Void {
        bytes.writeBytes(this, offset, length);
        _pos += offset + length;
    }

    public function readDouble():Float {
        var retVal: Float = buffer.readDoubleLE(_pos);
        _pos += 8;
        return retVal;
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
        return "";
    }

    public function readShort():Int {
        return 0;
    }

    public function readUTF():String {
        return "";
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

    public function writeBoolean(value:Bool):Void {
    }

    public function writeByte(value:Int):Void {
        buffer.writeInt8(value, 0);
        bytesAvailable += 1;
    }

    public function writeDouble(value:Float):Void {
        buffer.writeDoubleLE(value, 0);
        bytesAvailable += 8;
    }

    public function writeFloat(value:Float):Void {
        buffer.writeFloatLE(value, 0);
        bytesAvailable += 4;
    }

    public function writeInt(value:Int):Void {
        buffer.writeInt32LE(value, 0);
        bytesAvailable += 4;
    }

    public function writeMultiByte(value:String, charSet:String):Void {
    }

    public function writeObject(object:Dynamic):Void {
    }

    public function writeShort(value:Int):Void {
    }

    public function writeUTF(value:String):Void {
    }

    public function writeUTFBytes(value:String):Void {
        var length: Int = value.length;
        if(length > _bufferSize) {
            growBuffer(length);
        }
        buffer.write(value, _pos, length, 'utf8');
        bytesAvailable = length;
        _pos += length;
    }

    public function writeUnsignedInt(value:Int):Void {
    }

    public function writeBytes(bytes: InputOutputStream, offset: Int = 0, length: Int = 0): Void {
        cast (bytes).buffer.copy(buffer, _pos, offset, length);
        bytesAvailable = length;
    }

    public function send(data: String): Void {
        writeUTFBytes(data);
    }

    public function clear(): Void {
        _bufferSize = 128;
        buffer = new NodeBuffer(_bufferSize);
        bytesAvailable = 0;
        _pos = 0;
    }

    private inline function growBuffer(size:Int):Void {
        _bufferSize = size;
        buffer = new NodeBuffer(_bufferSize);
        bytesAvailable = 0;
        _pos = 0;
    }
}
