package util;
class StringUtil {

    public static var DECIMAL_POINT: String = ".";
    public static var COMMA: String = ",";

    public function new() {
    }

    public static inline function isBlank(value: String): Bool {
        return (value == null || value == "");
    }

    public static inline function addCommas( integer: Int ): String {
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
}
