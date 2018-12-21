package data;
interface SimpleDataLoader<T> {
    function read(feedName: String, queryData: Dynamic, onSuccess: Array<T>->Void): Void;
    function save(feedName: String, saveObject:Dynamic, onSuccess: T->Void): Void;
    function destroy(feedName: String, destroyObject:T, onSuccess: T->Void): Void;
}
