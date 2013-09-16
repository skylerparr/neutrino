package interpret;
import interpret.operators.Variable;
class RuntimeObject implements ClassDefinition {
    private var instanceId: Int;

    public var packageName(getPackage, null): String;
    public var className(getClass, null): String;
    public var parentClass(getParentClass, null): ClassDefinition;
    public var interfaces(getInterfaces, null): Array<InterfaceDefinition>;
    public var privateVars(getPrivateVars, null): Array<VariableDeclaration>;
    public var publicVars(getPublicVars, null): Array<VariableDeclaration>;
    public var privateFunctions(getPrivateFunctions, null): Array<FunctionDefinition>;
    public var publicFunctions(getPublicFunctions, null): Array<FunctionDefinition>;

    public function new() {
    }

    public function getPackage(): String {
        return "";
    }

    public function getClass(): String {
        return "";
    }
}
