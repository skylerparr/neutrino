package interpret;

import interpret.Import;
class Interpreter {

    private static inline var STATE_STRING:String = "string";
    private static inline var STATE_CODE:String = "code";
    private static inline var STATE_GATHER_ARGS:String = "gather";
    private static inline var STATE_DEFINING_IMPORT:String = "definingImport";
    private static inline var STATE_DEFINING_NEW_OBJECT:String = "definingNewObject";
    private static inline var STATE_GATHER_INDEX:String = "gatherIndex";

    private static inline var SUB_STATE_ESCAPING:String = "escaping";
    private static inline var SUB_STATE_DEFINING_VAR:String = "definingVar";
    private static inline var SUB_STATE_CONSTRUCTOR_ARGS:String = "constructorArgs";
    private static inline var SUB_STATE_DEFINING_TYPE:String = "definingType";

    private var _baseImplementor:Dynamic;
    private var _currentImplementor:Dynamic;
    private var _assignment:ObjectField;

    public static var _imports: Hash<Import>;

    public var baseImplementor(null, setBaseImplementor):Dynamic;

    public function new() {
        if(_imports == null) {
            _imports = new Hash<Import>();
            defineImport("Array");
            defineImport("ArrayAccess");
            defineImport("Bool");
            defineImport("Class");
            defineImport("Date");
            defineImport("DateTools");
            defineImport("Dynamic");
            defineImport("EReg");
            defineImport("Enum");
            defineImport("EnumValue");
            defineImport("Float");
            defineImport("Hash");
            defineImport("Int");
            defineImport("IntIterator");
            defineImport("Lambda");
            defineImport("List");
            defineImport("Map");
            defineImport("Math");
            defineImport("Null");
            defineImport("Reflect");
            defineImport("Single");
            defineImport("Std");
            defineImport("String");
            defineImport("StringBuf");
            defineImport("StringTools");
            defineImport("Sys");
            defineImport("Type");
            defineImport("UInt");
            defineImport("ValueType");
            defineImport("Void");
            defineImport("Xml");
            defineImport("XmlType");
        }
    }

    public function setBaseImplementor(value:Dynamic):Dynamic {
        _baseImplementor = value;
        return _baseImplementor;
    }

    public function eval(implementor:Dynamic, evalString:String):Dynamic {
        _currentImplementor = implementor;
        if (_baseImplementor == null) {
            _baseImplementor = implementor;
        }
        evalString = StringTools.trim(evalString);
        var currentState:String = "";
        var currentExec:String = "";
        var currentSubState:String = "";
        var char:String = evalString.charAt(0);
        if (char == "'") {
            currentState = STATE_STRING;
            evalString = evalString.substring(1);
        } else {
            currentState = STATE_CODE;
        }

        var stack:Array<ExecutionItem> = new Array<ExecutionItem>();
        var stackVal:ExecutionItem;
        var func:Dynamic = null;
        var shouldOperate:Bool = false;
        var currentType: String = "";
        var allArgsString:String = "";
        var newObject: String = "";
        var parenCount:Int = 0;
        var retVal:Dynamic = null;
        for (i in 0...evalString.length) {
            char = evalString.charAt(i);
            if (currentState == STATE_CODE) {
                if (char == "(") {
                    func = getFunction(currentExec);
                    parenCount++;
                    currentState = STATE_GATHER_ARGS;
                    currentExec = "";
                } else if (char == ".") {
                    if (!isBlank(currentExec)) {
                        _currentImplementor = executeScope(currentExec);
                    }
                    currentExec = "";
                } else if (char == ";") {
                    if(currentSubState == SUB_STATE_DEFINING_VAR) {
                        Reflect.setProperty(implementor, currentExec, null);
                        currentSubState == "";
                    } else {
                        var value: Dynamic = null;
                        if(Math.isNaN(retVal)) {
                            value = retVal;
                        }
                        if(isBlank(value)) {
                            if(isBlank(currentExec)) {
                                break;
                            }
                            if(Reflect.hasField(_currentImplementor, currentExec)) {
                                value = Reflect.getProperty(_currentImplementor, currentExec);
                            } else {
                                value = Std.parseFloat(currentExec);
                            }
                        }
                        stackVal = new ExecutionItem( value, "" );
                        stack.push(stackVal);
                    }
                    currentExec = "";
                    retVal = new Interpreter().eval(_baseImplementor, evalString.substr(i + 1));
                    break;
                } else if (char == " ") {
                    if(currentExec == Keywords.VAR) {
                        currentSubState = SUB_STATE_DEFINING_VAR;
                        currentExec = "";
                        continue;
                    } else if(currentExec == Keywords.IMPORT) {
                        currentState = STATE_DEFINING_IMPORT;
                        currentExec = "";
                        continue;
                    } else if(currentExec == Keywords.NEW) {
                        currentState = STATE_DEFINING_NEW_OBJECT;
                        currentExec = "";
                    }
                } else if (char == ":") {
                    currentSubState = SUB_STATE_DEFINING_TYPE;
                    currentExec += char;
                } else if (char == "+" || char == "-" || char == "*" || char == "/" || char == "%" || char == "=") {
                    if (!(isBlank(currentExec) && !shouldOperate) && !(isBlank(currentExec) && shouldOperate) ) {
                        if (char == "=") {
                            if(currentSubState == SUB_STATE_DEFINING_TYPE) {
                                var frags: Array<String> = currentExec.split(":");
                                currentType = StringTools.trim(frags[1]);
                                currentType = currentType.split("<")[0];
                                currentSubState = SUB_STATE_DEFINING_VAR;
                                currentExec = frags[0];
                            }
                            _assignment = new ObjectField(_currentImplementor, currentExec);
                            stackVal = new ExecutionItem( retVal, char );
                            stack.push(stackVal);
                            evalString = evalString.substr(i + 1);
                            var val:Dynamic = new Interpreter().eval(_baseImplementor, evalString);
                            if(!isBlank(currentType)) {
                                var clazz: Class<Dynamic> = Type.resolveClass(_imports.get(currentType).fullPath);
                                if(!Std.is(val, clazz)) {
                                    throw "Attempt to assign to wrong variable type.";
                                }
                            }
                            stackVal = new ExecutionItem(val, "");
                            stack.push(stackVal);
                            break;
                        } else {
                            retVal = executeScope(currentExec);
                        }
                    }
                    if (retVal != null) {
                        stackVal = new ExecutionItem( retVal, char );
                        stack.push(stackVal);
                    }
                    currentExec = "";
                    _currentImplementor = _baseImplementor;
                    shouldOperate = false;
                    continue;
                } else if (char == "'") {
                    currentState = STATE_STRING;
                } else if (char == "[") {
                    currentState = STATE_GATHER_INDEX;
                    if (!isBlank(currentExec)) {
                        _currentImplementor = executeScope(currentExec);
                    }
                    currentExec = "";
                } else {
                    currentExec += char;
                }
            } else if (currentState == STATE_GATHER_ARGS) {
                if (char == ")" && parenCount == 1) {
                    if(currentSubState == SUB_STATE_CONSTRUCTOR_ARGS) {
                        retVal = createNewObject(newObject, allArgsString);
                        newObject = "";
                    } else {
                        retVal = executeFunction(func, allArgsString);
                        _currentImplementor = retVal;
                    }
                    currentSubState = "";
                    currentState = STATE_CODE;
                    currentExec = "";
                    allArgsString = "";
                    parenCount--;
                    shouldOperate = true;
                    continue;
                } else if (char == "(") {
                    parenCount++;
                } else if (char == ")") {
                    parenCount--;
                }
                allArgsString += char;
            } else if (currentState == STATE_STRING) {
                if (char == "'" && currentSubState != SUB_STATE_ESCAPING) {
                    retVal = currentExec;
                    currentState = STATE_CODE;
                    currentExec = "";
                    if (stack.length > 0) {
                        stackVal = new ExecutionItem( retVal, "+" );
                        stack.push(stackVal);
                        retVal = null;
                    }
                } else if (char == "\\") {
                    currentSubState = SUB_STATE_ESCAPING;
                } else {
                    currentExec += char;
                    if (currentSubState == SUB_STATE_ESCAPING) {
                        currentSubState = "";
                    }
                }
            } else if(currentState == STATE_DEFINING_IMPORT) {
                if(char == ";") {
                    defineImport(currentExec);
                    currentExec = "";
                    retVal = new Interpreter().eval(_baseImplementor, evalString.substr(i + 1));
                    break;
                }
                currentExec += char;
            } else if(currentState == STATE_DEFINING_NEW_OBJECT) {
                if (char == "(") {
                    newObject = currentExec;
                    parenCount++;
                    currentState = STATE_GATHER_ARGS;
                    currentSubState = SUB_STATE_CONSTRUCTOR_ARGS;
                    currentExec = "";
                    continue;
                }
                currentExec += char;
            } else if(currentState == STATE_GATHER_INDEX) {
                if(char == "]") {
                    var funcParser: Interpreter = new Interpreter();
                    funcParser.baseImplementor = _baseImplementor;
                    retVal = funcParser.eval(_baseImplementor, currentExec);
                    retVal = _currentImplementor[retVal];
                    currentState = STATE_CODE;
                    currentExec = "";
                    if (stack.length > 0) {
                        stackVal = new ExecutionItem( retVal, "" );
                        stack.push(stackVal);
                        retVal = null;
                    }
                } else {
                    currentExec += char;
                }
            }
        }

        if (parenCount > 0) {
            throw "unable to eval string : " + evalString;
        }
        if (!isBlank(currentExec)) {
            if (currentExec.toLowerCase() == "true") {
                retVal = true;
            } else if (currentExec.toLowerCase() == "false") {
                retVal = false;
            } else if (Math.isNaN(Std.parseFloat(currentExec))) {
                retVal = executeScope(currentExec);
            } else {
                retVal = Std.parseFloat(currentExec);
            }
            if (stack.length > 0) {
                stackVal = new ExecutionItem( retVal, "+" );
                stack.push(stackVal);
                retVal = null;
            }
        }

        if (stack.length > 0) {
            if (retVal) {
                stackVal = new ExecutionItem( retVal, "" );
                stack.push(stackVal);
                retVal = null;
            }
            var exec:ExecutionItem = stack.shift();
            retVal = exec.value;
            var operator:String = exec.operator;
            exec = stack.shift();
            while (exec != null) {
                if (operator == "+") {
                    retVal = retVal + exec.value;
                } else if (operator == "-") {
                    retVal = retVal - exec.value;
                } else if (operator == "*") {
                    retVal = retVal * exec.value;
                } else if (operator == "/") {
                    retVal = retVal / exec.value;
                } else if (operator == "%") {
                    retVal = retVal % exec.value;
                } else if (operator == "=") {
                    assign(_assignment.implementor, _assignment.field, exec.value);
                    return Reflect.getProperty(_assignment.implementor, _assignment.field);
                }
                operator = exec.operator;
                exec = stack.shift();
            }
        }

        return retVal;
    }

    private inline function assign(currentImplementor:Dynamic, property:String, value:Dynamic):Void {
        Reflect.setProperty(currentImplementor, property, value);
    }

    private inline function executeScope(value:Dynamic):Dynamic {
        var retVal: Dynamic = null;
        if (_currentImplementor && Reflect.hasField(_currentImplementor, value)) {
            retVal = Reflect.getProperty(_currentImplementor, value);
        } else if(_imports != null && _imports.get(value) != null) {
            retVal = resolveClass(value);
        } else {
            retVal = Std.parseFloat(value);
        }
        return retVal;
    }

    private inline function executeFunction(func:Dynamic, allArgsString:String):Dynamic {
        var args:Array<Dynamic> = gatherArgs(allArgsString);
        return Reflect.callMethod(_currentImplementor, func, args);
    }

    private function gatherArgs(allArgsString: String): Array<Dynamic> {
        var args:Array<Dynamic> = [];
        var funcParser:Interpreter = new Interpreter();
        var argVal:Dynamic = null;
        var parenCount:Int = 0;
        var inQuote:Bool = false;
        var escaping:Bool = false;
        var currentString:String = "";
        for (i in 0...allArgsString.length) {
            var char:String = allArgsString.charAt(i);
            if (char == "," && parenCount == 0 && !inQuote) {
                funcParser.baseImplementor = _baseImplementor;
                argVal = funcParser.eval(_baseImplementor, currentString);
                args.push(argVal);
                currentString = "";
                continue;
            } else if (char == "(") {
                parenCount++;
            } else if (char == ")") {
                parenCount--;
            } else if (char == "\\") {
                escaping = true;
            } else if (char == "'") {
                if (!escaping) {
                    inQuote = !inQuote;
                } else {
                    escaping = false;
                }
            }
            currentString += char;
        }
        if (inQuote) {
            throw "unable to eval arguments : " + allArgsString;
        }
        if (!isBlank(currentString)) {
            funcParser = new Interpreter();
            funcParser.baseImplementor = _baseImplementor;
            argVal = funcParser.eval(_baseImplementor, currentString);
            args.push(argVal);
        }
        return args;
    }

    private inline function getFunction(currentExec:String):Dynamic {
        var retVal: Dynamic = null;
        if (_currentImplementor) {
            retVal = Reflect.getProperty(_currentImplementor, currentExec);
        }
        return retVal;
    }

    private inline function isBlank(value: String): Bool {
        return (value == null || value == "");
    }

    private inline function createNewObject(className: String, constructorArgs: String): Dynamic {
        var args:Array<Dynamic> = gatherArgs(constructorArgs);
        var clazz: Class<Dynamic> = resolveClass(className);
        return Type.createInstance(clazz, args);
    }

    private inline function resolveClass(className: String): Class<Dynamic> {
        className = className.split("<")[0];
        var importt: Import = _imports.get(className);
        if(importt == null) {
            throw "Unable to resolve class: " + className;
        }
        return Type.resolveClass(importt.fullPath);
    }

    public inline function defineImport(string: String): Void {
        var importt: Import = new Import();
        importt.fullPath = string;
        var frags: Array<String> = string.split(".");
        importt.className = frags.pop();
        importt.path = frags.join(".");

        _imports.set(importt.className, importt);
    }

    public function getImports(): Hash<Import> {
        return _imports;
    }

}
class ExecutionItem {
    public var value:Dynamic;
    public var operator:String;

    public function new(value:Dynamic, operator:String) {
        this.value = value;
        this.operator = operator;
    }
}

class ObjectField {
    public var implementor:Dynamic;
    public var field:String;

    public function new(implementor:Dynamic, field:String) {
        this.implementor = implementor;
        this.field = field;
    }
}
