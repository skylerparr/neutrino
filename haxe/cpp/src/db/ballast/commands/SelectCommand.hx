package cpp.db.ballast.commands;
import cpp.db.ballast.BallastResultSet;
import cpp.db.ballast.store.TableDef;
import cpp.db.ballast.store.DataManager;
import sys.db.ResultSet;
import cpp.db.hxdbc.SQLCommand;
class SelectCommand implements SQLCommand {
    public function new() {
    }

    public function execute(cmd:String):ResultSet {
        var split: Array<String> = cmd.split(" ");
        var tableName: String = getTableName(split);
        var tableDef: TableDef = DataManager.fetchTable(tableName);
        trace(split);
        trace(tableName);
        if(tableDef == null) {
            throw "table does not exist";
        }
        return new BallastResultSet(tableDef);
    }

    private function getTableName(frags: Array<String>): String {
        for(i in 0...frags.length) {
            var frag: String = frags[i];
            if(frag == "FROM") {
                var name: String = frags[i + 1];
                if(name.substr(1, 1) == "`") {
                    name = name.substr(1, name.length - 2);
                }
                return name;
            }
        }
        return "";
    }

}
