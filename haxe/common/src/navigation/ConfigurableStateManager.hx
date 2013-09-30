package navigation;
import util.StringUtil;
class ConfigurableStateManager implements StateManager {
    @inject
    public var navigationDispatcher: NavigationDispatcher;

    @:isVar
    public var init(null, set): Void->Void;
    @:isVar
    public var currentState(get, null): StateData;

    public var initialStateData(null, set): StateData;
    public var configurationString(null, set): String;
    public var defaultStateString(null, set): String;

    private var _configData: Array<String>;

    public function new() {
    }

    private function set_init(value: Void->Void): Void->Void {
        init = value;
        return value;
    }

    private function get_currentState():StateData {
        return currentState;
    }

    private function set_initialStateData(value: StateData): StateData {
        currentState = value;
        return currentState;
    }

    private function set_configurationString(value:String):String {
        var frags: Array<String> = value.split("/");
        _configData = frags.splice(1, frags.length);
        configurationString = value;
        return configurationString;
    }

    private function set_defaultStateString(value: String): String {
        defaultStateString = value;
        populateStateData(defaultStateString);
        return defaultStateString;
    }

    private inline function populateStateData(value: String): Void {
        var frags:Array<String> = value.split("/");
        for (i in 0..._configData.length) {
            var field:String = _configData[i];
            var frag:String = frags[i + 1];
            if (StringUtil.isBlank(frag)) {
                frag = "";
            }
            if(i == _configData.length - 1) {
                frags = frags.splice(_configData.length, frags.length);
                Reflect.setProperty(currentState, field, frags.join("/"));
            } else {
                Reflect.setProperty(currentState, field, frag);
            }
        }
    }

    public function getStateString(stateData: StateData): String {
        var retVal: Array<String> = new Array<String>();

        for(i in 0..._configData.length) {
            var fieldName: String = _configData[i];
            var value: String = Reflect.getProperty(stateData, fieldName);
            if ( StringUtil.isBlank(value) ) {
                value = "";
            }
            retVal[i] = value;
        }

        return "/" + retVal.join("/");
    }

    public function setup():Void {
        if(init != null) {
            init();
        }
        navigationDispatcher.update(currentState);
    }

    public function updateState(newState:StateData):Void {
        populateStateData(getStateString(newState));
        navigationDispatcher.update(currentState);
    }
}
