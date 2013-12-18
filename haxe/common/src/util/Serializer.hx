package util;
import haxe.Json;
import vo.ValueObject;
import Type;
class Serializer {
    public function new() {
    }

    public static inline function serialize(value:Dynamic):Dynamic {
        var retVal: Dynamic = null;
        if(Std.is(value, Array)) {
            retVal = [];
        } else {
            retVal = {};
        }
        assignSerial(retVal, value);
        assignType(retVal, value);
        return retVal;
    }

    private static inline function assignSerial(retVal:Dynamic, value:Dynamic):Void {
        var fields:Array<Dynamic> = getFields(value);
        if(Std.is(value, Array)) {
            fields = [];
            for(i in 0...value.length) {
                fields.push(i);
            }
        }
        var counter: Int = 0;
        for (field in fields) {
            var fieldValue:Dynamic = null;
            try {
                fieldValue = Reflect.getProperty(value, field);
            } catch (e:Dynamic) {
            }
            if(fieldValue == null) {
                var index: Int = counter++;
                var array: Array<Dynamic> = null;
                try {
                    array = cast value;
                } catch(e: Dynamic) {

                }
                if(array != null && Std.is(array, Array)) {
                    fieldValue = array[index];
                }
            }
            if (isNative(fieldValue)) {
                try {
                    Reflect.setField(retVal, field, fieldValue);
                } catch(e: Dynamic) {
                    trace(e);
                }
            } else {
                if (Type.typeof(fieldValue) == ValueType.TFunction) {
                    continue;
                }
                if (Type.typeof(fieldValue) == ValueType.TNull) {
                    continue;
                }
                if(Std.is(fieldValue, Array)) {
                    var array: Array<Dynamic> = [];
                    var it: Array<Dynamic> = cast(fieldValue, Array<Dynamic>);
                    for(item in it) {
                        if (isNative(item)) {
                            array.push(item);
                        } else if(item == null) {
                            array.push(null);
                        } else {
                            array.push(serialize(item));
                        }
                    }
                    try {
                        Reflect.setField(retVal, field, array);
                    } catch(e: Dynamic) {
                        trace(e);
                    }
                    continue;
                }
                if(Std.is(fieldValue, Date)) {
                    Reflect.setField(retVal, field, fieldValue);
                }
                if(!Std.is(fieldValue, ValueObject) && !Std.is(value, Array)) {
                    continue;
                }
                recurseSerial(retVal, fieldValue, field);
            }
        }
    }

    private static inline function getFields(value:Dynamic):Array<String> {
        var cls: Class<Dynamic> = Type.getClass(value);
        var retVal: Array<String> = null;
        if(cls == null) {
            retVal = Reflect.fields(value);
        } else {
            retVal = Type.getInstanceFields(cls);
        }
        return retVal;
    }

    private static inline function isNative(fieldValue:Dynamic):Bool {
        var type:ValueType = Type.typeof(fieldValue);
        return (type == ValueType.TUnknown ||
        type == ValueType.TInt ||
        type == ValueType.TFloat ||
        type == ValueType.TBool || Std.is(fieldValue, String));
    }

    private static inline function assignType(toAssign: Dynamic, value: Dynamic): Void {
        try {
            Reflect.setField(toAssign, "__type", Type.getClassName(Type.getClass(value)));
        } catch(e: Dynamic) {

        }
    }

    private static inline function recurseSerial(retVal:Dynamic, value:Dynamic, assignField:String):Void {
        var toAssign: Dynamic = null;
        if(Std.is(value, Array)) {
            toAssign = [];
        } else {
            toAssign = {};
        }
        assignSerial(toAssign, value);
        try {
            if(Std.is(retVal, Array)) {
                retVal.push(toAssign);
            } else {
                Reflect.setProperty(retVal, assignField, toAssign);
            }
        } catch (e:Dynamic) {
            trace(e);
            //swallow
        }
        assignType(toAssign, value);
    }

    public static inline function deserialize(serial:Dynamic):Dynamic {
        var retVal: Dynamic = null;
        if(Std.is(serial, Array)) {
            retVal = [];
        } else {
            retVal = createInstance(serial);
        }
        assignDeserial(retVal, serial);
        return retVal;
    }

    private static inline function assignDeserial(retVal: Dynamic, value: Dynamic): Void {
        var fields:Array<Dynamic> = Reflect.fields(value);
        if(fields.length == 0 && Std.is(value, Array)) {
            fields = [];
            for(i in 0...value.length) {
                fields.push(i);
            }
        }
        var counter: Int = 0;
        for (field in fields) {
            if (field == "__type") {
                continue;
            }
            var fieldValue:Dynamic = Reflect.getProperty(value, field);
            if(fieldValue == null) {
                fieldValue = value[counter++];
            }
            if (isNative(fieldValue)) {
                Reflect.setProperty(retVal, field, fieldValue);
            } else {
                if(Std.is(fieldValue, Array)) {
                    var array: Array<Dynamic> = [];
                    var it: Array<Dynamic> = cast(fieldValue, Array<Dynamic>);
                    for(item in it) {
                        if (isNative(item)) {
                            array.push(item);
                        } else if(item == null) {
                            array.push(null);
                        } else {
                            array.push(deserialize(item));
                        }
                    }
                    try {
                        Reflect.setProperty(retVal, field, array);
                    } catch(e: Dynamic) {
//swallow
                    }
                    continue;
                } else if(Std.is(fieldValue, Date)) {
                    Reflect.setProperty(retVal, field, fieldValue);
                    continue;
                }
                resurseDeserial(retVal, fieldValue, field);
            }
        }
    }

    private static inline function createInstance(value: Dynamic): Dynamic {
        var toAssign: Dynamic;
        if (value != null && value.__type != null) {
            try {
                toAssign = Type.createInstance(Type.resolveClass(value.__type), []);
            } catch (e:Dynamic) {
                toAssign = {};
            }
        } else {
            toAssign = {};
        }
        return toAssign;
    }

    private static inline function resurseDeserial(retVal:Dynamic, value:Dynamic, assignField:String):Void {
        var toAssign:Dynamic = createInstance(value);
        var fields:Array<String> = Reflect.fields(value);
        assignDeserial(toAssign, value);
        try {
            if(Std.is(retVal, Array)) {
                retVal[Std.parseInt(assignField)] = toAssign;
            } else {
                Reflect.setProperty(retVal, assignField, toAssign);
            }
        } catch (e:Dynamic) {
            trace(e);
//swallow
        }
    }
}
