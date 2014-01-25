package auth;
#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end
class IOSAuthentication extends DataLoadApplicationAuthentication {
    public function new() {
        super();
    }

    override public function getUniqueId():String {
        var iosauthext_get_unique_device_id: Void->String = Lib.load ("iosauthext", "iosauthext_get_unique_device_id", 0);
        return iosauthext_get_unique_device_id();
    }

}
