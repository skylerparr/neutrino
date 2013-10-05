package io;
interface InputStream {
    var bytesAvailable(get,null) : Int;
    var objectEncoding : Int;
    function readBoolean() : Bool;
    function readByte() : Int;
    function readBytes(bytes: InputStream, offset: Int = 0, length: Int = 0) : Void;
    function readDouble() : Float;
    function readFloat() : Float;
    function readInt() : Int;
    function readMultiByte( length : Int, charSet : String ) : String;
    function readShort() : Int;
    function readUTF() : String;
    function readUTFBytes( length : Int ) : String;
    function readUnsignedByte() : Int;
    function readUnsignedInt() : Int;
    function readUnsignedShort() : Int;
}
