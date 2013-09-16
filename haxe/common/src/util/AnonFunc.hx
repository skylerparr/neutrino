package util;
class AnonFunc {
    public function new() {
    }

    public static function call(func: Dynamic, args: Array<Dynamic>): Dynamic {
        var retVal: Dynamic = null;
        retVal = function(moreargs: Array<Dynamic>): Void {
            if(moreargs == null) {
                Reflect.callMethod(null, func, args);
            } else {
                var allArgs: Array<Dynamic> = args.concat(moreargs);
                Reflect.callMethod(null, func, allArgs);
            }
        }
        return Reflect.makeVarArgs(retVal);
    }
}
