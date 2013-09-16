package cpp.db.hxdbc;
import cpp.db.hxdbc.SQLCommand;
interface CommandLookup {
    function findCommand(name: String): SQLCommand;
}
