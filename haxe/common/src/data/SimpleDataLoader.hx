package data;
interface SimpleDataLoader {
    function read(feedName: String, queryData: Dynamic, onSuccess: Array<Dynamic>->Void): Void;
    function save(feedName: String, saveObject:Dynamic, onSuccess: Dynamic->Void): Void;
    function destroy(feedName: String, destroyObject:Dynamic, onSuccess: Dynamic->Void): Void;
}
