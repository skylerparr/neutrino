package db.ballast.commands;
import db.ballast.store.DataType;
import db.ballast.store.FieldDef;
import db.ballast.store.TableDef;
import db.ballast.store.DataManager;
import util.Parser;
import util.Parser;
import db.ballast.BallastResultSet;
import sys.db.ResultSet;
import cpp.db.hxdbc.SQLCommand;
class CreateCommand implements SQLCommand {

    private var tableDef: TableDef;

    public function new() {
    }

    public function execute(cmd:String):ResultSet {
        var sub: String = cmd.substr("CREATE TABLE ".length );
        var tableName: String = "";
        var pos: Int = 0;
        for(i in 0...sub.length) {
            var char: String = sub.charAt(i);
            pos++;
            if(char == " ") {
                break;
            }
            tableName += char;
        }
        sub = sub.substr(pos + 1, sub.length - pos - 2);
        tableDef = new TableDef();
        tableDef.tableName = tableName;
        var stringDefs: Array<String> = Parser.parse(sub, ",");
        var fieldDefs: Map<String, FieldDef> = new Map<String, FieldDef>();
        for(strDef in stringDefs) {
            var fieldDef = createFieldDef(strDef);
            if(fieldDef == null) {
                continue;
            }
            fieldDefs.set(fieldDef.name, fieldDef);
        }
        tableDef.fields = fieldDefs;
        DataManager.createTable(tableName, tableDef);
        return null;
    }

    private function createFieldDef(string: String): FieldDef {
        var split: Array<String> = string.split(" ");
        if(split[0] + " " + split[1] == "PRIMARY KEY") {
            var primaryKey: String = split[2];
            tableDef.primaryKey = primaryKey.substr(1, primaryKey.length - 2);
            return null;
        }
        var fieldName: String = split[0];
        var dataType: DataType = null;
        var dataTypeString: String = split[1].split("(")[0];
        switch(dataTypeString) {
            case "INTEGER":
                dataType = DataType.Number;
            case "VARCHAR":
                dataType = DataType.Text;
            case "MEDIUMTEXT":
                dataType = DataType.Text;
            case "DATE":
                dataType = DataType.Date;
            default:
                dataType = DataType.Blob;
        }
        var autoIncrement: Bool = false;
        var nullable: Bool = false;
        var currentIndex: Int = 3;
        if(split.length > 2) {
            if(split[currentIndex] == "AUTO_INCREMENT") {
                autoIncrement = true;
                currentIndex++;
            }
            if(split[currentIndex] + " " + split[currentIndex + 1] == "NOT NULL") {
                nullable = true;
                currentIndex += 2;
            }
        }
        return {name: fieldName, defaultValue: null, nullable: nullable, dataType: dataType, autoIncrement: autoIncrement};
    }

}

