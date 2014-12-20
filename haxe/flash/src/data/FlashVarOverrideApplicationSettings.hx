package data;
import util.StringUtil;
class FlashVarOverrideApplicationSettings implements ApplicationSettings {

    public var baseAssetsPath(default, set): String;
    private var settingsMap: Map<String,Dynamic>;

    public function new() {
        #if flash
        var params: Dynamic = flash.Lib.current.loaderInfo.parameters;
        #else
        var params: Dynamic = {};
        #end
        settingsMap = new Map<String,Dynamic>();
        baseAssetsPath = params.baseAssetsPath;
        var fields: Array<String> = Reflect.fields(params);
        for(field in fields) {
            if(field != "baseAssetsPath") {
                settingsMap.set(field, Reflect.field(params, field));
            }
        }
    }

    private function set_baseAssetsPath(value:String):String {
        if(StringUtil.isBlank(baseAssetsPath)) {
            baseAssetsPath = value;
        }
        return baseAssetsPath;
    }

    public function getBasePath():String {
        return null;
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

    public function setSetting(name: String, value: Dynamic): Void {
        var mappedValue: Dynamic = settingsMap.get(name);
        if(mappedValue == null) {
            settingsMap.set(name, value);
        }
    }
}
