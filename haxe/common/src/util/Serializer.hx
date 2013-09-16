package util;
import haxe.Json;
import vo.ValueObject;
import Type;
class Serializer {
    public function new() {
    }

    public static inline function serialize(value:Dynamic):Dynamic {
        var retVal:Dynamic = {};
        assignSerial(retVal, value);
        assignType(retVal, value);
        return retVal;
    }

    private static inline function assignSerial(retVal:Dynamic, value:Dynamic):Void {
        var fields:Array<String> = getFields(value);
        for (field in fields) {
            var fieldValue:Dynamic = null;
            try {
                fieldValue = Reflect.getProperty(value, field);
            } catch (e:Dynamic) {
                continue;
            }
            if (isNative(fieldValue)) {
                Reflect.setField(retVal, field, fieldValue);
            } else {
                if (Type.typeof(fieldValue) == ValueType.TFunction) {
                    continue;
                }
                if (Type.typeof(fieldValue) == ValueType.TNull) {
                    continue;
                }
                if(Std.is(fieldValue, Array)) {
                    var array: Array<Dynamic> = new Array();
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
                    Reflect.setField(retVal, field, array);
                    continue;
                }
                if(!Std.is(fieldValue, ValueObject)) {
                    continue;
                }
                recurseSerial(retVal, fieldValue, field);
            }
        }
    }

    private static inline function getFields(value:Dynamic):Array<String> {
        return Type.getInstanceFields(Type.getClass(value));
    }

    private static inline function isNative(fieldValue:Dynamic):Bool {
        var type:ValueType = Type.typeof(fieldValue);
        return (type == ValueType.TUnknown ||
        type == ValueType.TInt ||
        type == ValueType.TFloat ||
        type == ValueType.TBool || Std.is(fieldValue, String));
    }

    private static inline function assignType(toAssign: Dynamic, value: Dynamic): Void {
        Reflect.setField(toAssign, "__type", Type.getClassName(Type.getClass(value)));
    }

    private static inline function recurseSerial(retVal:Dynamic, value:Dynamic, assignField:String):Void {
        var toAssign:Dynamic = {};
        assignSerial(toAssign, value);
        assignType(toAssign, value);
        Reflect.setField(retVal, assignField, toAssign);
    }

    public static inline function deserialize(serial:Dynamic):Dynamic {
        var retVal:Dynamic = createInstance(serial);
        assignDeserial(retVal, serial);
        return retVal;
    }

    private static inline function assignDeserial(retVal: Dynamic, value: Dynamic): Void {
        var fields:Array<String> = Reflect.fields(value);
        for (field in fields) {
            if (field == "__type") {
                continue;
            }
            var fieldValue:Dynamic = Reflect.getProperty(value, field);
            if (isNative(fieldValue)) {
                try {
                    Reflect.setProperty(retVal, field, fieldValue);
                } catch (e:Dynamic) {
//swallow
                }
            } else {
                if(Std.is(fieldValue, Array)) {
                    var array: Array<Dynamic> = new Array();
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
                    Reflect.setField(retVal, field, array);
                    continue;
                }
                resurseDeserial(retVal, fieldValue, field);
            }
        }
    }

    private static inline function createInstance(value: Dynamic): Dynamic {
        var toAssign: Dynamic;
        if (value.__type != null) {
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
            Reflect.setProperty(retVal, assignField, toAssign);
        } catch (e:Dynamic) {
//swallow
        }
    }
}
