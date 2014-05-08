package util;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class MapSubscriberTest {

    private var _mapSubscriber: MapSubscriber;
    private var _sampleCalled: Bool = false;
    private var _sample2Called: Bool = false;

    public function new() {

    }

    @Before
    public function setup():Void {
        _mapSubscriber = new MapSubscriber();
        _sampleCalled = false;
        _sample2Called = false;
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldHoldSubscriptionByName(): Void {
        _mapSubscriber.subscribe("sample", sample);
        _mapSubscriber.notify("sample");
        Assert.isTrue(_sampleCalled);
    }

    @Test
    public function shouldRemoveSubscription(): Void {
        _mapSubscriber.subscribe("sample", sample);
        _mapSubscriber.subscribe("sample", sample2);
        _mapSubscriber.unSubscribe("sample", sample);
        _mapSubscriber.notify("sample");
        Assert.isFalse(_sampleCalled);
        Assert.isTrue(_sample2Called);
    }

    private function sample():Void {
        _sampleCalled = true;
    }

    private function sample2():Void {
        _sample2Called = true;
    }
}