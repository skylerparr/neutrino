package interpret;
interface ClassDefinition {
    var packageName(getPackage, null): String;
    var className(getClass, null): String;
    var parentClass(getParentClass, null): ClassDefinition;
    var interfaces(getInterfaces, null): Array<InterfaceDefinition>;
    var privateVars(getPrivateVars, null): Array<VariableDeclaration>;
    var publicVars(getPublicVars, null): Array<VariableDeclaration>;
    var privateFunctions(getPrivateFunctions, null): Array<FunctionDefinition>;
    var publicFunctions(getPublicFunctions, null): Array<FunctionDefinition>;
}
