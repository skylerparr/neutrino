package data;
class ConfigurableApplicationSettings implements ApplicationSettings {

    public var baseAssetsPath: String;
    public var settingsMap: Map<String,Dynamic>;

    public function new() {
        settingsMap = new Map<String, Dynamic>();
    }

    public function getBasePath():String {
        return "";
    }

    public function getBaseAssetsPath():String {
        return baseAssetsPath;
    }

    public function getFeeds():Map<String,Dynamic> {
        return null;
    }

    public function getSetting(name:String):Dynamic {
        return settingsMap.get(name);
    }

}
