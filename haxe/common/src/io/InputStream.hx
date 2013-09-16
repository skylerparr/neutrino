package com.thoughtorigin.io;
interface InputStream {
    var bytesAvailable(default,null) : Int;
    var objectEncoding : Int;
    function readBoolean() : Bool;
    function readByte() : Int;
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
