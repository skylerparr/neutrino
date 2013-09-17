package data;

class StaticApplicationSettings implements ApplicationSettings {
    public function new():Void {

    }

    public function getBasePath():String {
        return "data/";
    }

    public function getBaseAssetsPath():String {
        return "assets/";
    }

    public function getFeeds():Map<String, String> {
        return null;
    }

    public function getSetting(name:String):String {
    }
}
