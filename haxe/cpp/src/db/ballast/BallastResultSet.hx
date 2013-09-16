package cpp.db.ballast;
import cpp.db.ballast.store.TableDef;
import sys.db.ResultSet;
class BallastResultSet implements ResultSet{
    public var length(get,null) : Int;
    public var nfields(get,null) : Int;

    private var _tableDef: TableDef;
    private var _data: List<Dynamic>;

    public function new(tableDef: TableDef) {
        _tableDef = tableDef;
        _data = tableDef.data;
    }

    public function get_length(): Int {
        trace("get_length");
        return 0;
    }

    public function get_nfields(): Int {
        trace("get nfields");
        var numFields: Int = 0;
        for(f in _tableDef.fields.keys()) {
            numFields++;
        }
        return numFields;
    }

    public function hasNext():Bool {
        trace("hasNext");
        return false;
    }

    public function next():Dynamic {
        trace("next");
        return null;
    }

    public function results():List<Dynamic> {
        trace("results");
        return _data;
    }

    public function getResult(n:Int):String {
        trace("getResult");
        return "";
    }

    public function getIntResult(n:Int):Int {
        trace("getIntResult");
        return 0;
    }

    public function getFloatResult(n:Int):Float {
        trace("getFloatResult");
        return 0;
    }

    public function getFieldsNames():Null<Array<String>> {
        trace("getFieldsNames");
        return null;
    }
}
