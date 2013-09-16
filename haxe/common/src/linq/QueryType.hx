package mecha.data.linq;
import haxe.ds.ObjectMap;
interface QueryType {
    function select(fields: Array<String>): Operator;
    function update(fields: Array<String>): Operator;
    function insert(fieldValues: ObjectMap<String, Dynamic>): Result;
    function delete(): Operator;
}
