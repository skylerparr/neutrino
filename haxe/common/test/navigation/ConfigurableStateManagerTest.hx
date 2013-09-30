package navigation;

import massive.munit.Assert;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class ConfigurableStateManagerTest {

    private var _stateManager: ConfigurableStateManager;
    private var _gameState: SampleGameState;
    private var _navigationDispatcher: NavigationDispatcher;

    public function new() {

    }

    @Before
    public function setup():Void {
        _stateManager = new ConfigurableStateManager();
        _gameState = new SampleGameState();
        _navigationDispatcher = mock(NavigationDispatcher);
        _stateManager.navigationDispatcher = _navigationDispatcher;
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldCallTheInitCallbackWhenStateManagerIsReady(): Void {
        var cbCalled: Bool = false;
        _stateManager.init = function(): Void {
            cbCalled = true;
        }
        _stateManager.setup();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldBeAbleToSetTheConfigurationStringAndUpdateTheCurrentStateObject(): Void {
        _stateManager.initialStateData = _gameState;
        _stateManager.configurationString = "/foo/bar/messages";
        _stateManager.defaultStateString = "/mouth/face/carrot";
        Assert.areEqual("mouth", _gameState.foo);
        Assert.areEqual("face", _gameState.bar);
        Assert.areEqual("carrot", _gameState.messages);
    }

    @Test
    public function shouldBuildStateStringFromStateData(): Void {
        _stateManager.initialStateData = _gameState;
        _stateManager.configurationString = "/foo/bar/messages";
        _gameState.foo = "al";
        _gameState.bar = "co";
        _gameState.messages = "hol";
        Assert.areEqual("/al/co/hol", _stateManager.getStateString(_gameState));
    }

    @Test
    public function shouldNotifyTheNavigationDispatcherWhenStateChanges(): Void {
        _stateManager.initialStateData = _gameState;
        _stateManager.configurationString = "/foo/bar/messages";
        _stateManager.defaultStateString = "/mouth/face/carrot";
        _gameState.foo = "yellow";
        _stateManager.updateState(_gameState);
        Assert.isTrue(_navigationDispatcher.update(_gameState).verify());
        Assert.areEqual("yellow", (cast _stateManager.currentState).foo);
    }

    @Test
    public function shouldHaveTheLatestStateButAssignToTheSameStateObject(): Void {
        _stateManager.initialStateData = _gameState;
        _stateManager.configurationString = "/foo/bar/messages";
        _stateManager.defaultStateString = "/mouth/face/carrot";
        var state: SampleGameState = new SampleGameState();
        state.bar = "blue";
        _stateManager.updateState(state);
        Assert.areEqual("blue", (cast _stateManager.currentState).bar);
        Assert.areEqual(_gameState, _stateManager.currentState);
    }

    @Test
    public function shouldNotThrowExceptionIfSetupFunctionIsNull(): Void {
        _stateManager.setup();
    }

    @Test
    public function shouldAppendAnyDataOnTheEndOfTheLastArgEvenIfItHasSlashes(): Void {
        _stateManager.initialStateData = _gameState;
        _stateManager.configurationString = "/foo/bar/messages";
        _stateManager.defaultStateString = "/mouth/face/carrot";
        var state: SampleGameState = new SampleGameState();
        state.messages = "1/2/3/4";
        _stateManager.updateState(state);
        Assert.areEqual("1/2/3/4", (cast _stateManager.currentState).messages);
    }

    @Test
    public function shouldUpdateStateForTheFirstTimeAfterSetupIsCalled(): Void {
        _stateManager.initialStateData = _gameState;
        _stateManager.configurationString = "/foo/bar/messages";
        _stateManager.defaultStateString = "/mouth/face/carrot";
        _stateManager.setup();
        _navigationDispatcher.update(cast isNotNull).verify();
    }
}

class SampleGameState implements StateData {
    public var foo: String;
    public var bar: String;
    public var messages: String;

    public function new() {}
}