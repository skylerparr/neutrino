package auth;
class DevelopmentApplicationAuthentication extends DataLoadApplicationAuthentication {
    public function new() {
        super();
    }

    override public function getUniqueId():String {
        return "me";
    }
}
