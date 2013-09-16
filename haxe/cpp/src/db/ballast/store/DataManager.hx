package com.thoughtorigin.cpp.db.ballast.store;
class DataManager {

    private static var _tableMap: Map<String, TableDef> = new Map();

    public function new() {

    }

    public static function createTable(tableName: String, def: TableDef): Void {
        trace("creating table : " + tableName + " " + def);
        _tableMap.set(tableName, def);
    }

    public static function updateTable(tableName: String, def: TableDef): Void {

    }

    public static function dropTable(tableName: String): Void {

    }

    public static function fetchTable(tableName: String): TableDef {
        return _tableMap.get(tableName);
    }
}
