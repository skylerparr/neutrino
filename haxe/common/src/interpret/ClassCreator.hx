package com.thoughtorigin.interpret;
class ClassCreator {

    public var currentInterpretingState(getCurrentInterpretingState, null): InterpretingState;
    public var currentInterpretingSubState: InterpretingSubState;
    public var currentPackageScope: String;
    public var currentImports: Array<String>;
    public var currentPublicVariables: Array<VariableDeclaration>;
    public var currentPrivateVariables: Array<VariableDeclaration>;
    public var currentPublicFunctionDefinitions: Array<FunctionDefinition>;
    public var currentPrivateFunctionDefinitions: Array<FunctionDefinition>;
    public var currentClassDef: String;

    private var _classDefinitions: List<ClassDefinition>;
    public var classDefinitions(getClassDefinitions, null): List<ClassDefinition>;

    public var defaultObject: Dynamic;

    private function getClassDefinitions(): List<ClassDefinition> {
        return _classDefinitions;
    }

    public function new() {
        _classDefinitions = new List<ClassDefinition>();
        currentImports = new Array<String>();
        currentPublicVariables = new Array<VariableDeclaration>();
        currentPrivateVariables = new Array<VariableDeclaration>();
        currentPublicFunctionDefinitions = new Array<FunctionDefinition>();
        currentPrivateFunctionDefinitions = new Array<FunctionDefinition>();
        currentInterpretingState = InterpretingState.NONE;
        currentInterpretingSubState = InterpretingSubState.NONE;
    }

    public function eval(string: String): Void {
        var stringLen: Int = string.length;
        var currentVal: String = "";
        var i: Int = 0;
        while(i < stringLen) {
            var char: String = string.charAt(i);
            i++;
            currentVal += char;
            if(char == " ") {
                if(StringTools.trim(currentVal) == Keywords.PACKAGE) {
                    currentInterpretingState = InterpretingState.DEFINING_PACKAGE;
                    currentVal = "";
                    continue;
                } else if(StringTools.trim(currentVal) == Keywords.IMPORT) {
                    currentInterpretingState = InterpretingState.DEFINING_IMPORT;
                    currentVal = "";
                    continue;
                } else if(StringTools.trim(currentVal) == Keywords.CLASS) {
                    currentInterpretingState = InterpretingState.CLASS_DECLARED;
                    currentVal = "";
                    continue;
                } else if(currentInterpretingState == InterpretingState.CLASS_DECLARED) {
                    currentInterpretingState = InterpretingState.DEFINING_CLASS;
                    var clazz: String = StringTools.trim(currentVal.substr(0, currentVal.length - 1));
                    currentClassDef = clazz;
                    currentVal = "";
                    continue;
                } else if( StringTools.trim(currentVal) == Keywords.PUBLIC ) {
                    currentInterpretingSubState = InterpretingSubState.DEFINING_PUBLIC;
                    currentVal = "";
                    continue;
                } else if( StringTools.trim(currentVal) == Keywords.PRIVATE ) {
                    currentInterpretingSubState = InterpretingSubState.DEFINING_PRIVATE;
                    currentVal = "";
                    continue;
                } else if(StringTools.trim(currentVal) == Keywords.VAR && currentInterpretingSubState == InterpretingSubState.DEFINING_PUBLIC ) {
                    i = defineVar(i, string.substring(i), currentPublicVariables);
                    currentVal = "";
                    currentInterpretingSubState == InterpretingSubState.WAITING_NEXT_DEFINITION;
                    continue;
                } else if(StringTools.trim(currentVal) == Keywords.VAR && currentInterpretingSubState == InterpretingSubState.DEFINING_PRIVATE ) {
                    i = defineVar(i, string.substring(i), currentPrivateVariables);
                    currentVal = "";
                    currentInterpretingSubState == InterpretingSubState.WAITING_NEXT_DEFINITION;
                    continue;
                } else if(StringTools.trim(currentVal) == Keywords.FUNCTION && currentInterpretingSubState == InterpretingSubState.DEFINING_PUBLIC ) {
                    i = defineFunction(i, string.substring(i), currentPublicFunctionDefinitions);
                    currentVal = "";
                    currentInterpretingSubState == InterpretingSubState.WAITING_NEXT_DEFINITION;
                    continue;
                } else if(StringTools.trim(currentVal) == Keywords.FUNCTION && currentInterpretingSubState == InterpretingSubState.DEFINING_PRIVATE ) {
                    i = defineFunction(i, string.substring(i), currentPrivateFunctionDefinitions);
                    currentVal = "";
                    currentInterpretingSubState == InterpretingSubState.WAITING_NEXT_DEFINITION;
                    continue;
                }
            } else if (char == ";") {
                if(currentInterpretingState == InterpretingState.DEFINING_PACKAGE) {
                    currentInterpretingState = InterpretingState.PACKAGE_DEFINED;
                    currentPackageScope = StringTools.trim(currentVal.substr(0, currentVal.length - 1));
                    currentVal = "";
                    continue;
                } else if(currentInterpretingState == InterpretingState.DEFINING_IMPORT) {
                    currentInterpretingState = InterpretingState.NONE;
                    var mport: String = StringTools.trim(currentVal.substr(0, currentVal.length - 1));
                    currentImports.push(mport);
                    currentVal = "";
                    continue;
                }
            } else if (char == "{" && currentInterpretingState == InterpretingState.DEFINING_CLASS) {
                currentInterpretingSubState = InterpretingSubState.WAITING_NEXT_DEFINITION;
                currentVal = "";
            } else if (char == "}" && currentInterpretingState == InterpretingState.DEFINING_CLASS && currentInterpretingSubState == InterpretingSubState.WAITING_NEXT_DEFINITION) {
                currentInterpretingState = InterpretingState.NONE;
                currentInterpretingSubState = InterpretingSubState.NONE;
                currentPackageScope = "";
                currentClassDef = "";
                currentVal = "";
            }
        }
    }

    public inline function defineVar(currentIndex: Int, data: String, collection: Array<VariableDeclaration>, ?delimiter: String = ";"): Int {
        var variable: VariableDeclaration = new VariableDeclaration();
        var stringLen: Int = data.length;
        var currentVal: String = "";
        var i: Int = 0;
        while(i < stringLen) {
            var char: String = data.charAt(i);
            i++;
            currentVal += char;
            if(char == ":") {
                var varName: String = StringTools.trim(currentVal.substr(0, currentVal.length - 1));
                variable.varName = varName;
                currentVal = "";
                continue;
            } else if(char == delimiter) {
                var type: String = StringTools.trim(currentVal.substr(0, currentVal.length - 1));
                variable.type = type;
                currentVal = "";
                break;
            }
        }
        if(currentVal.length > 0) {
            var type: String = StringTools.trim(currentVal.substr(0, currentVal.length - 1));
            variable.type = type;
            currentVal = "";
        }
        collection.push(variable);
        return i + currentIndex;
    }

    public inline function defineFunction(currentIndex: Int, data: String, collection: Array<FunctionDefinition>): Int {
        var funcDef: FunctionDefinition = new FunctionDefinition();
        var stringLen: Int = data.length;
        var currentVal: String = "";
        var i: Int = 0;
        var braceCount: Int = 0;
        var countingBraces: Bool = false;
        var gatheringParams: Bool = false;
        var gettingReturnType: Bool = false;
        while(i < stringLen) {
            var char: String = data.charAt(i);
            i++;
            currentVal += char;
            if(char == ":" && countingBraces == false && gatheringParams == false) {
                currentVal = "";
                gettingReturnType = true;
                continue;
            } else if(char == "(" && countingBraces == false) {
                gatheringParams = true;
                var funcName: String = StringTools.trim(currentVal.substr(0, currentVal.length - 1));
                funcDef.functionName = funcName;
                currentVal = "";
                continue;
            } else if(char == ")" && countingBraces == false && gatheringParams == true ) {
                var index: Int = 0;
                while(index < currentVal.length) {
                    index = defineVar(index, currentVal.substr(index, currentVal.length - 1), funcDef.params, ",");
                }
                currentVal == "";
                gatheringParams = false;
                continue;
            } else if(char == "{" && gettingReturnType && countingBraces == false) {
                funcDef.returnVal = StringTools.trim(currentVal.substr(0, currentVal.length - 1));
                currentVal = "";
                gettingReturnType = false;
                countingBraces = true;
                braceCount++;
                continue;
            } else if(char == "{" && countingBraces == true) {
                braceCount++;
            } else if(char == "}" && countingBraces == true) {
                braceCount--;
            }
            if(braceCount == 0 && countingBraces == true) {
                funcDef.functionDefinition = currentVal.substr(0, currentVal.length - 1);
                break;
            }
        }
        collection.push(funcDef);
        return i + currentIndex;
    }

    public function getCurrentInterpretingState(): InterpretingState {
        return currentInterpretingState;
    }
}
