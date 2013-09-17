package navigation;
interface StateManager extends ApplicationState {
    var init(null, set): Void->Void;
    function setup(): Void;
}
