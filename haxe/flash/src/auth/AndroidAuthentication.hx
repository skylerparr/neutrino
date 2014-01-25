package auth;
import openfl.utils.JNI;
class AndroidAuthentication extends DataLoadApplicationAuthentication {
    private var _uuid: String;

    public function new() {
        super();
        var getUUID: Void->String = JNI.createStaticMethod("AndroidAuthentication", "getUUID", "()Ljava/lang/String;");
        _uuid = getUUID();
    }

    override public function getUniqueId():String {
        return _uuid;
    }

}
