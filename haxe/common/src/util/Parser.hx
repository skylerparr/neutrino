package com.thoughtorigin.util;
class Parser {
    public static function parse(s:String, sep:String):Array<String> {
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
}