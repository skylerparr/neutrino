package navigation;
interface ApplicationState {
    var currentState(get, null): StateData;
    function updateState(newState: StateData): Void;
}
