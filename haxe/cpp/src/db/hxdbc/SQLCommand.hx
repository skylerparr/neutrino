package com.thoughtorigin.cpp.db.hxdbc;
import sys.db.ResultSet;
interface SQLCommand {
    function execute(cmd: String): ResultSet;
}
