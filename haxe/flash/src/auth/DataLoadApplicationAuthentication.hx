package auth;
import util.StringUtil;
import auth.ApplicationAuthentication;
import constants.AuthenticationErrorCodes;
import data.DataLoader;
class DataLoadApplicationAuthentication implements ApplicationAuthentication {

    @inject
    public var dataLoader: DataLoader;

    public var createNewPlayerTokenFeedName: String;
    public var getPlayerTokenFeedName: String;

    public var authenticationToken: String;

    public function new() {
    }

    public function createAuthenticationToken(success:String -> Void, fail:Int -> Void): Void {
        dataLoader.save(createNewPlayerTokenFeedName, function(data: Dynamic): Void {
            if(Reflect.hasField(data, "auth_token")) {
                success(data.auth_token);
            } else {
                fail(data.messageId);
            }
        }, function(message: String): Void {
            fail(AuthenticationErrorCodes.SERVER_ERROR);
        }, {device_id: getAuthToken()});
    }

    public function getAuthenticationToken(success:String -> Void, fail:Int -> Void):Void {
        dataLoader.read(getPlayerTokenFeedName, function(dataArr: Array<Dynamic>): Void {
            var data: Dynamic = dataArr[0];
            if(Reflect.hasField(data, "auth_token")) {
                success(data.auth_token);
            } else {
                fail(data.messageId);
            }
        }, function(message: String): Void {
            fail(AuthenticationErrorCodes.SERVER_ERROR);
        }, {device_id: getAuthToken()});
    }

    private function getAuthToken(): String {
        if(StringUtil.isBlank(authenticationToken)) {
            return getUniqueId();
        }
        return authenticationToken;
    }

    public function getUniqueId(): String {
        return null;
    }
}
