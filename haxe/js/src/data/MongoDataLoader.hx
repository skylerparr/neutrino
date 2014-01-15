package data;
import js.node.MongoDb;
import js.node.MongoDb;
class MongoDataLoader implements DataLoader {

    public var mongo: Dynamic;

    public function new() {
    }

    public function read(feedName:String, onSuccess:Array<Dynamic> -> Void, onFail:String -> Void, queryData:Dynamic = null):Void {
        mongo.collection(feedName, function(err, collection): Void {
            findInCollection(err, collection, onSuccess, onFail, queryData);
        });
    }

    private function findInCollection(err: Dynamic, collection: Dynamic, onSuccess: Dynamic->Void, onFail: String->Void, queryData: Dynamic): Void {
        collection.find(queryData, function(err: Dynamic, cursor): Void {
            cursor.toArray(function(err: Dynamic, data: Array<Dynamic>): Void {
                if(data != null) {
                    for(item in data) {
                        if(Reflect.hasField(item, "_id") && !Std.is(Reflect.field(item, "_id"), String)) {
                            item._id = item._id;
                        }
                    }
                }
                onSuccess(data);
            });
        });
    }

    public function save(feedName:String, onSuccess:Dynamic -> Void, onFail:String -> Void, saveObject:Dynamic):Void {
        mongo.collection(feedName, function(err, collection): Void {
            if(saveObject != null) {
                if(Reflect.hasField(saveObject, "_id")) {
                    try {
                        saveObject._id = MongoIdHelper.mongoIdStr(mongo, saveObject._id);
                    } catch(e: Dynamic) {

                    }
                }
            }

            collection.save(saveObject, function(err, data): Void {
                if(data != null) {
                    if(Reflect.hasField(data, "_id") && !Std.is(Reflect.field(data, "_id"), String)) {
                        data._id = data._id;
                    }
                }
                onSuccess(saveObject);
            });
        });
    }

    public function destroy(feedName:String, onSuccess:Dynamic -> Void, onFail:String -> Void, destroyObject:Dynamic):Void {
        mongo.collection(feedName, function(err, collection): Void {
            collection.remove(destroyObject, function(err, data): Void {
                onSuccess(destroyObject);
            });
        });
    }
}
