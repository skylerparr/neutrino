package util;

import io.InputOutputStream;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class ParserTest {

    private var _parser: Parser;
    private var _buffer: InputOutputStream;

    public function new() {

    }

    @Before
    public function setup():Void {
        _buffer = new MockInputOutputStream();
        _parser = new Parser(_buffer);
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldPutManyFragmentedPiecesOfDataTogether(): Void {
        var objs: Array<Dynamic> = _parser.parseJSON('{"item1":"hello');
        Assert.areEqual(0, objs.length);
        var objs: Array<Dynamic> = _parser.parseJSON('wor');
        Assert.areEqual(0, objs.length);
        var objs: Array<Dynamic> = _parser.parseJSON('ld"}');
        Assert.areEqual(1, objs.length);

    }
}

class MockInputOutputStream implements InputOutputStream {
    public var position(get, set): Int;
    @:isVar
    public var bytesAvailable(get,null) : Int;
    public var objectEncoding : Int;

    public var buffer: Array<String>;
    private var _pos: Int;

    public function new() {
        buffer = [];
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
        return buffer.length - _pos;
    }

    public function readBoolean():Bool {
        return false;
    }

    public function readByte():Int {
        return 0;
    }

    public function readBytes(bytes:InputOutputStream, offset:Int = 0, length:Int = 0):Void {
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
        return "";
    }

    public function readShort():Int {
        return 0;
    }

    public function readUTF():String {
        return "";
    }

    public function readUTFBytes(length:Int):String {
        var retVal: String = buffer.join("");
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
    }

    public function writeDouble(value:Float):Void {
    }

    public function writeFloat(value:Float):Void {
    }

    public function writeInt(value:Int):Void {
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
        for(i in _pos...value.length) {
            buffer.push(value.charAt(i));
            _pos++;
        }
    }

    public function writeUnsignedInt(value:Int):Void {
    }

    public function writeBytes(bytes: InputOutputStream, offset: Int = 0, length: Int = 0): Void {
    }

    public function send(data: String): Void {
    }

    public function clear(): Void {
        buffer = [];
        _pos = 0;
    }

}

