package data;
import io.InputStream;
import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.events.IOErrorEvent;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.net.Socket;
import io.StreamEventHandler;
import io.OutputStream;
import io.InputOutputStream;
class ByteArrayIOStream implements InputOutputStream {

    public var bytesAvailable(get,null) : Int;
    public var objectEncoding : Int;

    public var byteArray: ByteArray;

    public function new() {
        byteArray = new ByteArray();
        byteArray.endian = Endian.LITTLE_ENDIAN;
    }

    private function get_bytesAvailable(): Int {
        return byteArray.bytesAvailable;
    }

    public function dispose(): Void {
        byteArray = null;
    }

    public function readBoolean():Bool {
        return byteArray.readBoolean();
    }

    public function readByte():Int {
        return byteArray.readByte();
    }

    public function readBytes(bytes:InputStream, offset:Int = 0, length:Int = 0):Void {
        byteArray.readBytes(cast(bytes, ByteArrayIOStream).byteArray, offset, length);
    }

    public function readDouble():Float {
        return byteArray.readDouble();
    }

    public function readFloat():Float {
        return byteArray.readFloat();
    }

    public function readInt():Int {
        return byteArray.readInt();
    }

    public function readMultiByte(length:Int, charSet:String):String {
        return byteArray.readMultiByte(length, charSet);
    }

    public function readShort():Int {
        return byteArray.readShort();
    }

    public function readUTF():String {
        return byteArray.readUTF();
    }

    public function readUTFBytes(length:Int):String {
        return byteArray.readUTFBytes(length);
    }

    public function readUnsignedByte():Int {
        return byteArray.readUnsignedByte();
    }

    public function readUnsignedInt():Int {
        return byteArray.readUnsignedInt();
    }

    public function readUnsignedShort():Int {
        return byteArray.readUnsignedShort();
    }

    public function writeBoolean(value:Bool):Void {
        byteArray.writeBoolean(value);
    }

    public function writeByte(value:Int):Void {
        byteArray.writeByte(value);
    }

    public function writeDouble(value:Float):Void {
        byteArray.writeDouble(value);
    }

    public function writeFloat(value:Float):Void {
        byteArray.writeFloat(value);
    }

    public function writeInt(value:Int):Void {
        byteArray.writeInt(value);
    }

    public function writeMultiByte(value:String, charSet:String):Void {
        byteArray.writeMultiByte(value, charSet);
    }

    public function writeObject(object:Dynamic):Void {
        byteArray.writeObject(object);
    }

    public function writeShort(value:Int):Void {
        byteArray.writeShort(value);
    }

    public function writeUTF(value:String):Void {
        byteArray.writeUTF(value);
    }

    public function writeUTFBytes(value:String):Void {
        byteArray.writeUTFBytes(value);
    }

    public function writeUnsignedInt(value:Int):Void {
        byteArray.writeUnsignedInt(value);
    }

    public function send(data: String): Void {
        writeUTFBytes(data);
    }

}
