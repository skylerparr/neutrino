package util;
class StringUtil {

    public static var DECIMAL_POINT: String = ".";
    public static var COMMA: String = ",";

    public function new() {
    }

    public static inline function isBlank(value: String): Bool {
        return (value == null || value == "");
    }

    public static inline function addCommas( integer: Float ): String {
        var intString: String = integer + "";
        var intLen: Int = intString.length;
        if ( intLen <= 3 ) {
            return integer + "";
        } else {
            var returnString: String = "";
            var start: Int = 0;
            var end: Int = 3;
            var mod: Int = intLen % 3;

            if ( mod != 0 ) {
                returnString += intString.substring( start, ( start + mod ));
                start += mod;
                end += mod;
            }

            while ( intLen >= end ) {
                if ( start == 0 ) {
                    returnString += intString.substring( start, end );
                } else {
                    returnString += COMMA + intString.substring( start, end );
                }
                start += 3;
                end += 3;
            }

            return returnString;
        }
    }

    public static inline function fillDigits(integer: Int, maxDigits): String {
        var intString: String = integer + "";
        var intLen: Int = intString.length;
        var diff: Int = maxDigits - intLen;
        for(i in 0...diff) {
            intString = "0" + intString;
        }
        return intString;
    }

    public static inline function addSpaces(string: String, spaceCount: Int = 1): String {
        var numChars: Int = string.length;
        var arr: List<String> = new List<String>();
        for(i in 0...numChars) {
            arr.add(string.charAt(i));
        }
        var spaces: String = "";
        for(i in 0...spaceCount) {
            spaces += " ";
        }
        return arr.join(spaces);
    }

    public static inline function truncate(string: String, maxChars: Int): String {
        if(string.length > maxChars) {
            string = string.substring(0, maxChars) + "...";
        }
        return string;
    }
}
