package signal;

import msignal.Signal;
import massive.munit.Assert;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class NoArgSignalFactoryTest {

    private var _signalFactory: NoArgSignalFactory;

    public function new() {

    }

    @Before
    public function setup():Void {
        _signalFactory = new NoArgSignalFactory();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldCreateANewSignalByName(): Void {
        var signal: Signal0 = _signalFactory.getSignal("mySignal");
        var signal2: Signal0 = _signalFactory.getSignal("mySignal2");
        Assert.isNotNull(signal);
        Assert.areNotEqual(signal, signal2);
    }

    @Test
    public function shouldReturnTheSameSignalByName(): Void {
        var signal: Signal0 = _signalFactory.getSignal("mySignal");
        var signal2: Signal0 = _signalFactory.getSignal("mySignal");
        Assert.isNotNull(signal);
        Assert.areEqual(signal, signal2);
    }
}