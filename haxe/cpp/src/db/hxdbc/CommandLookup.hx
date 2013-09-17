package db.hxdbc;
import db.hxdbc.SQLCommand;
interface CommandLookup {
    function findCommand(name: String): SQLCommand;
}
