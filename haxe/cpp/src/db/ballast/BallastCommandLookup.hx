package db.ballast;
import haxe.ds.ObjectMap;
import db.hxdbc.SQLCommand;
import db.hxdbc.CommandLookup;
import db.ballast.commands.CreateCommand;
import db.ballast.commands.SelectCommand;

class BallastCommandLookup implements CommandLookup {
    public function new() {
    }

    public function findCommand(name:String):SQLCommand {
        var split: Array<String> = name.split(" ");
        var commandName: String = split[0];
        commandName = StringTools.trim(commandName);

        var clazz: Dynamic = commands.get(commandName);
        if(clazz != null) {
            return Type.createInstance(clazz, []);
        }
        throw "unable to find command";
    }

    private static var commands: Map<String, Dynamic> = {
        commands = new Map<String, Dynamic>();
        commands.set("CREATE", CreateCommand);
        commands.set("SELECT", SelectCommand);
        commands;
    };
}
