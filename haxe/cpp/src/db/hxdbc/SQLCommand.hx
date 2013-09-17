package db.hxdbc;
import sys.db.ResultSet;
interface SQLCommand {
    function execute(cmd: String): ResultSet;
}
