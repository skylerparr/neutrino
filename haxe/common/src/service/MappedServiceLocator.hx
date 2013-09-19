package service;
import core.ObjectCreator;
class MappedServiceLocator implements ServiceLocator {
    @inject
    public var objectCreator: ObjectCreator;

    public var allServiceDefs(get, null): Array<ServiceDef>;

    private var _mappedServices: Map<String, ServiceDef>;
    private var _singletonServices: Map<String, Service>;

    public function new() {

    }

    private function get_allServiceDefs(): Array<ServiceDef> {
        var retVal: Array<ServiceDef> = [];
        if(_mappedServices == null) {
            return retVal;
        }
        for(serDef in _mappedServices) {
            retVal.push(serDef);
        }
        return retVal;
    }

    public function addService(name: String, impl: Class<Service>, singleton: Bool = false): Void {
        if(_mappedServices == null) {
            _mappedServices = new Map<String, ServiceDef>();
        }
        _mappedServices.set(name, {name: name, cls: impl, singleton: singleton});
    }

    public function getServiceByName(name:String):Service {
        var serviceDef: ServiceDef = _mappedServices.get(name);
        var retVal: Service = null;
        if(serviceDef.singleton) {
            if(_singletonServices == null) {
                _singletonServices = new Map<String,Service>();
            }
            retVal = _singletonServices.get(name);
            if(retVal == null) {
                retVal = objectCreator.createInstance(serviceDef.cls);
                _singletonServices.set(name, retVal);
            }
        } else {
            retVal = objectCreator.createInstance(serviceDef.cls);
        }
        return retVal;
    }
}

typedef ServiceDef = {
    name: String,
    cls: Class<Service>,
    singleton: Bool
}
