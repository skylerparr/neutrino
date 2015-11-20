package auth;
class DevelopmentApplicationAuthentication extends DataLoadApplicationAuthentication {
    public function new() {
        super();
    }

    override public function getUniqueId():String {
        #if player
        trace("you");
        return "you";
        #else
        trace("me");
        return "me";
        #end
    }
}
