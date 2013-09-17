package util;
class NumberFormatter {
    public function new() {
    }

    public static inline function shortifyNumber(value: Float): String {
        var retVal: String = "";
        if(value < 1000) {
            retVal = value + "";
        } else if(value >= 1000 && value < 100000) {
            var truncVal: Int = Std.int(value / 100);
            var floatVal: Float = truncVal / 10;
            retVal = floatVal + "K";
        } else if(value >= 100000 && value < 1000000) {
            var truncVal: Int = Std.int(value / 1000);
            retVal = truncVal + "K";
        } else if(value >= 1000000 && value < 100000000) {
            var truncVal: Int = Std.int(value / 100000);
            var floatVal: Float = truncVal / 10;
            retVal = floatVal + "M";
        } else if(value >= 100000000 && value < 1000000000) {
            var truncVal: Int = Std.int(value / 1000000);
            retVal = truncVal + "M";
        } else if(value >= 1000000000 && value < 100000000000) {
            var truncVal: Int = Std.int(value / 100000000);
            var floatVal: Float = truncVal / 10;
            retVal = floatVal + "B";
        } else if(value >= 10000000000 && value < 1000000000000) {
            var truncVal: Int = Std.int(value / 1000000000);
            retVal = truncVal + "B";
        }
        return retVal;
    }
}
