package com.thoughtorigin.vo;
class BoundValueObject implements BindableValueObject {

    private var _propertyBindings: Map<String, Array<Void->Void>>;

    public function new() {
    }

    public function bindProperty(propertyName:String, updateFunction:Void -> Void):Void {
        if(_propertyBindings == null) {
            _propertyBindings = new Map<String, Array<Void->Void>>();
        }
        var coll: Array<Void->Void> = _propertyBindings.get(propertyName);
        if(coll == null) {
            coll = [];
            _propertyBindings.set(propertyName, coll);
        }
        coll.push(updateFunction);
    }

    public function unbindProperty(propertyName:String, updateFunction:Void -> Void):Void {
        if(_propertyBindings == null) {
            return;
        }
        var coll: Array<Void->Void> = _propertyBindings.get(propertyName);
        if(coll != null) {
            coll.remove(updateFunction);
        }
        if(coll.length == 0) {
            _propertyBindings.remove(propertyName);
        }
    }

    public function unbindAll():Void {
        _propertyBindings = null;
    }

    public function setProperty(propertyName: String, value: Dynamic): Void {
//        Reflect.setProperty(this, "_" + propertyName, value);
        if(_propertyBindings == null) {
            return;
        }
        var coll: Array<Void->Void> = _propertyBindings.get(propertyName);
        if(coll != null) {
            for(func in coll) {
                func();
            }
        }
    }
}
