package cli;
import interpret.Interpreter;
import haxe.io.Output;
import haxe.io.Input;
class CLIMain {

    private var _eval: Interpreter;

    public static function main(): Void {
        new CLIMain();
    }

    public function new() {
        listenForInput();
    }

    private inline function listenForInput(): Void {
        var output: Output = Sys.stdout();
        var main: Dynamic = {trace: function(message: String): Void {output.writeString(message);}};
        _eval = new Interpreter();
        while(true) {
            output.writeString(">> ");
            var input: Input = Sys.stdin();
            var inputString: String = input.readLine();
            if(inputString == "exit") {
                break;
            }
            var retVal: Dynamic = _eval.eval(main, inputString);
            output.writeString(retVal + "\n");
        }
    }

}
