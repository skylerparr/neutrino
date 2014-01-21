package util;
import io.InputOutputStream;
import haxe.Json;
class Parser {

    private var _dataBuffer: InputOutputStream;

    public function new(buffer: InputOutputStream) {
        _dataBuffer = buffer;
    }

    public inline function parse(s:String, sep:String):Array<String> {
        var inQuote: Bool = false;
        var char: Int, len = s.length, ret = [], buf = new StringBuf();
        for(i in 0...len) {
            char = StringTools.fastCodeAt(s, i);
            if(char == StringTools.fastCodeAt(",", 0)) {
                if(inQuote) {
                    buf.addChar(char);
                    continue;
                }
                ret.push(buf.toString());
                buf = new StringBuf();
                continue;
            }
            if(char == StringTools.fastCodeAt("\"", 0) || char == StringTools.fastCodeAt("'", 0)) {
                if(inQuote) {
                    inQuote = false;
                    continue;
                }
                inQuote = true;
                continue;
            }
            buf.addChar(char);
        }
        ret.push(buf.toString());

        return ret;
    }

    /**
     * Attempts to join fragmented data and recreate them as functional json objects to be redistributed to the rest
     * of the application
     *
     * @param stringData
     * @return
     */
    public inline function parseJSON(stringData:String):Array<Dynamic> {
        if(_dataBuffer != null && _dataBuffer.bytesAvailable > 0) {
            stringData = _dataBuffer.readUTFBytes(_dataBuffer.bytesAvailable) + stringData;
            _dataBuffer.clear();
        }
        var retVal:Array<Dynamic> = new Array<Dynamic>();
        var braceCounter:Int = 0;
        var strLength:Int = stringData.length;
        var insideQuotes:Bool = false;
        var isEscaping:Bool = false;
        var i: Int = 0;
        while(i < strLength) {
            var char:String = stringData.charAt(i);
            i = i + 1;
            if (char == "\\") {
                isEscaping = true;
                continue;
            }
            if (isEscaping) {
                isEscaping = false;
                continue;
            }
            if (char == "\"") {
                if (insideQuotes) {
                    insideQuotes = false;
                } else {
                    insideQuotes = true;
                }
                continue;
            }
            if (insideQuotes) {
                continue;
            }
            if (char == "{") {
                braceCounter++;
                continue;
            }
            if (char == "}") {
                braceCounter--;
                if (braceCounter == 0) {
                    var strObj:String = stringData.substring(0, i + 1);
                    if(StringTools.fastCodeAt(strObj, 0) == 0) {
                        strObj = stringData.substring(1, i + 1);
                    }
                    try {
                        var obj:Dynamic = null;
                        try {
                            obj = Json.parse(strObj);
                            stringData = stringData.substring(i + 1);
                        } catch(e: Dynamic) {
                            obj = Json.parse(strObj.substring(0, strObj.length - 1));
                            stringData = stringData.substring(i);
                        }
                        retVal.push(obj);
                        strLength = stringData.length;
                        i = -1;
                    } catch(e: Dynamic) {
                        trace(e);
                        trace(strObj);
                        break;
                    }
                }
            }
        }

        if (insideQuotes || braceCounter > 0 && _dataBuffer != null) {
            _dataBuffer.writeUTFBytes(stringData.substring(0));
            _dataBuffer.position = 0;
        }
        return retVal;
    }

}
