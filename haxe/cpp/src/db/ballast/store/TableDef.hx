package com.thoughtorigin.cpp.db.ballast.store;
class TableDef {
    public var tableName: String;
    public var fields: Map<String, FieldDef>;
    public var primaryKey: String;
    public var data: List<Dynamic>;
    public var relations: Array<RelationDef>;

    public function new() {
        data = new List();
    }
}
