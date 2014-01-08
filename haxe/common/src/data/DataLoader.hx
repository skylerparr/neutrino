package data;
interface DataLoader {
    function read(feedName: String, onSuccess: Array<Dynamic>->Void, onFail: String->Void, queryData: Dynamic = null): Void;
    function save(feedName: String, onSuccess: Dynamic->Void, onFail: String->Void, saveObject:Dynamic): Void;
    function destroy(feedName: String, onSuccess: Dynamic->Void, onFail: String->Void, destroyObject:Dynamic): Void;
}
