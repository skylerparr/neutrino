package service;

import core.ObjectCreator;
import service.MappedServiceLocator;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class MappedServiceLocatorTest {

    private var _serviceLocator: MappedServiceLocator;
    private var _objectCreator: ObjectCreator;

    public function new() {

    }

    @Before
    public function setup():Void {
        _serviceLocator = new MappedServiceLocator();
        _objectCreator = mock(ObjectCreator);
        _serviceLocator.objectCreator = _objectCreator;
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldGetServiceByName(): Void {
        _serviceLocator.addService("myService", MyService);
        _serviceLocator.addService("myService2", MyService2);
        var testService: MyService2 = new MyService2();
        _objectCreator.createInstance(MyService2, cast any).returns(testService);

        var service: Service = _serviceLocator.getServiceByName("myService2");
        Assert.areEqual(testService, service);
    }

    @Test
    public function shouldReturnNewInstanceOfTheServiceEveryTime(): Void {
        _serviceLocator.addService("myService2", MyService2);
        var testService: MyService2 = new MyService2();
        _objectCreator.createInstance(MyService2, cast any).returns(testService);

        var service: Service = _serviceLocator.getServiceByName("myService2");
        var service: Service = _serviceLocator.getServiceByName("myService2");
        Assert.isTrue(_objectCreator.createInstance(cast any, cast any).verify(2));
    }

    @Test
    public function shouldNotReturnNewInstanceOfTheServiceIfTheServiceIsMarkedAsASingleton(): Void {
        _serviceLocator.addService("myService2", MyService2, true);
        var testService: MyService2 = new MyService2();
        _objectCreator.createInstance(MyService2, cast any).returns(testService);

        var service: Service = _serviceLocator.getServiceByName("myService2");
        var service: Service = _serviceLocator.getServiceByName("myService2");
        Assert.isTrue(_objectCreator.createInstance(cast any, cast any).verify(1));
    }
}

class MyService implements Service {
    public function new() {}

    public function init():Void {
    }

    public function dispose():Void {
    }

}

class MyService2 implements Service {
    public function new() {}

    public function init():Void {
    }

    public function dispose():Void {
    }

}