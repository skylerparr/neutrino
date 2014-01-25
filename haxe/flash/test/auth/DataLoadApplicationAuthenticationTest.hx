package auth;

import data.DataLoader;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class DataLoadApplicationAuthenticationTest {

    private var _authentication: TestableDataLoadApplicationAuthentication;
    private var _dataLoader: DataLoader;

    public function new() {

    }

    @Before
    public function setup():Void {
        _authentication = new TestableDataLoadApplicationAuthentication();
        _dataLoader = mock(DataLoader);
        _authentication.dataLoader = _dataLoader;
        _authentication.createNewPlayerTokenFeedName = "createNewPlayerToken";
        _authentication.getPlayerTokenFeedName = "getPlayerTokenFeedName";
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldCreateANewAuthenticationToken(): Void {
        var authToken: String = "";
        var loadedToken: String = Math.random() * 0xffffff + "";
        _authentication.uniqueId = Math.random() * 0xffffff + "";
        _dataLoader.save("createNewPlayerToken", cast any, cast any, cast any).calls(function(args: Array<Dynamic>): Void {
            var query: Dynamic = args[3];
            Assert.areEqual(_authentication.uniqueId, query.device_id);
            args[1]({auth_token: loadedToken});
        });
        _authentication.createAuthenticationToken(function(token: String): Void {
            authToken = token;
        }, function(message: Int): Void {

        });
        Assert.areEqual(loadedToken, authToken);
    }

    @Test
    public function shouldCallTheFailFunctionIfCreationWasAFailure(): Void {
        var messageId: Int = -1;
        _dataLoader.save("createNewPlayerToken", cast any, cast any, cast any).calls(function(args: Array<Dynamic>): Void {
            args[1]({messageId: 1});
        });
        _authentication.createAuthenticationToken(function(token: String): Void {
        }, function(message: Int): Void {
            messageId = message;
        });
        Assert.areEqual(1, messageId);
    }

    @Test
    public function shouldGetAuthenticationToken(): Void {
        var authToken: String = "";
        var loadedToken: String = Math.random() * 0xffffff + "";
        _authentication.uniqueId = Math.random() * 0xffffff + "";
        _dataLoader.read("getPlayerTokenFeedName", cast any, cast any, cast any).calls(function(args: Array<Dynamic>): Void {
            var query: Dynamic = args[3];
            Assert.areEqual(_authentication.uniqueId, query.device_id);
            args[1]([{auth_token: loadedToken}]);
        });
        _authentication.getAuthenticationToken(function(token: String): Void {
            authToken = token;
        }, function(message: Int): Void {

        });
        Assert.areEqual(loadedToken, authToken);
    }
}

class TestableDataLoadApplicationAuthentication extends DataLoadApplicationAuthentication {

    public var uniqueId: String;

    override public function getUniqueId():String {
        return uniqueId;
    }
}