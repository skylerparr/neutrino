package auth;
import util.StringUtil;
import data.ApplicationSettings;
class WebFacebookAuthentication extends DataLoadApplicationAuthentication {

    public function new() {
        super();
    }

    override public function getUniqueId():String {
        var auth_token: String = Reflect.getProperty(flash.Lib.current.stage.loaderInfo.parameters, "auth_token");
        if(StringUtil.isBlank(auth_token)) {
            auth_token = "me";
        }
        return auth_token;
    }

}
