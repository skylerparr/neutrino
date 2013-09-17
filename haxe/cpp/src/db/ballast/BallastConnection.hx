package db.ballast;
import sys.db.ResultSet;
import sys.db.Connection;
class BallastConnection implements Connection{

    private var _ballastCommandLookup: BallastCommandLookup;

    public function new() {
        _ballastCommandLookup = new BallastCommandLookup();
    }

    public function request(s:String):ResultSet {
        trace("making request : " + s);
        var command = _ballastCommandLookup.findCommand(s);
        return command.execute(s);
    }

    public function close():Void {
        trace("close");
    }

    public function escape(s:String):String {
        trace("escape");
        return "";
    }

    public function quote(s:String):String {
        trace("quote");
        return "";
    }

    public function addValue(s:StringBuf, v:Dynamic):Void {
        trace("addValue : " + s + " : " + v);
    }

    public function lastInsertId():Int {
        trace("last insert id");
        return 0;
    }

    public function dbName():String {
        trace("dbName");
        return "mydb";
    }

    public function startTransaction():Void {
        trace("start transaction");
    }

    public function commit():Void {
        trace("commit");
    }

    public function rollback():Void {
        trace("rollback");
    }

}
