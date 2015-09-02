package data;
class ConfigurableApplicationSettings implements ApplicationSettings {

    public var baseAssetsPath: String;
    public var basePath: String;
    public var feeds: Map<String, Dynamic>;
    public var settingsMap: Map<String,Dynamic>;

    public function new() {
        settingsMap = new Map<String, Dynamic>();
    }

    public function getBasePath():String {
        return basePath;
    }

    public function getBaseAssetsPath():String {
        return baseAssetsPath;
    }

    public function getFeeds():Map<String,Dynamic> {
        return feeds;
    }

    public function getSetting(name:String):Dynamic {
        return settingsMap.get(name);
    }

}
