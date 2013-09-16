package interpret;
class DynamicInterpreter {
    public function new() {
    }

    public function execute(data: String): Dynamic {
        if(StringTools.startsWith("package ", data)) {
            var cc: ClassCreator = new ClassCreator();
            cc.eval(data);
        } else {
            var parser: hscript.Parser = new hscript.Parser();
            var program: hscript.Program = parser.parseString(data);
            var interp: hscript.Interp = new hscript.Interp();
            return interp.execute(program);
        }
        return null;
    }
}
