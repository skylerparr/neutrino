package welding;
class SimpleMetaInformation implements MetaInformation {

    public var _metaName: String;
    public var _metaArgs: Hash<String>;
    public var _object: Dynamic;
    public var _functionName: String;
    public var _functionArgs: List<Class>;

    public function new() {
    }

    public var metaName(getMetaName, null): String;
    public var metaArgs(getMetaArgs, null): Hash<String>;
    public var object(getObject, null): Dynamic;
    public var functionName(getFunctionName, null): String;
    public var functionArgs(getFunctionArgs, null): List<Class>;

    private function getMetaName(): String {
        return _metaName;
    }

    private function getMetaArgs():Hash<String> {
        return _metaArgs;
    }

    private function getObject():Dynamic {
        return _object;
    }

    private function getFunctionName():String {
        return _functionName;
    }

    private function getFunctionArgs():List<Class> {
        return _functionArgs;
    }
}
