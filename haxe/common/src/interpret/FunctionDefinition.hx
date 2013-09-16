package interpret;
class FunctionDefinition {

    public var functionName: String;
    public var params: Array<VariableDeclaration>;
    public var returnVal: String;
    public var functionDefinition: String;

    public function new() {
        params = new Array<VariableDeclaration>();
    }
}
