package data;
import js.node.MongoDb;
class SimpleMongoDataLoader implements SimpleDataLoader {
    public var mongo: Dynamic;

    public function new() {
    }

    public function read(feedName:String, queryData:Dynamic, onSuccess:Array<Dynamic> -> Void):Void {
        mongo.collection(feedName, function(err, collection): Void {
            findInCollection(err, collection, onSuccess, queryData);
        });
    }

    private inline function findInCollection(err: Dynamic, collection: Dynamic, onSuccess: Dynamic->Void, queryData: Dynamic): Void {
        if(queryData != null) {
            if(Reflect.hasField(queryData, "_id")) {
                try {
                    queryData._id = MongoIdHelper.mongoIdStr(mongo, queryData._id);
                } catch(e: Dynamic) {
                    trace(e);
                }
            }
        }
        collection.find(queryData, function(err: Dynamic, cursor): Void {
            cursor.toArray(function(err: Dynamic, data: Array<Dynamic>): Void {
                if(data != null) {
                    for(item in data) {
                        if(Reflect.hasField(item, "_id") && !Std.is(Reflect.field(item, "_id"), String)) {
                            item._id = item._id + "";
                        }
                    }
                }
                onSuccess(data);
            });
        });
    }

    public function save(feedName:String, saveObject:Dynamic, onSuccess:Dynamic -> Void):Void {
        mongo.collection(feedName, function(err, collection): Void {
            if(saveObject != null) {
                if(Reflect.hasField(saveObject, "_id")) {
                    try {
                        saveObject._id = MongoIdHelper.mongoIdStr(mongo, saveObject._id);
                    } catch(e: Dynamic) {
                        trace(e);
                    }
                }
            }

            collection.save(saveObject, function(err, data): Void {
                if(Reflect.hasField(saveObject, "_id") && !Std.is(Reflect.field(saveObject, "_id"), String)) {
                    saveObject._id = saveObject._id + "";
                }
                onSuccess(saveObject);
            });
        });
    }

    public function destroy(feedName:String, destroyObject:Dynamic, onSuccess:Dynamic -> Void):Void {
        mongo.collection(feedName, function(err, collection): Void {
            if(destroyObject != null) {
                if(Reflect.hasField(destroyObject, "_id")) {
                    try {
                        destroyObject._id = MongoIdHelper.mongoIdStr(mongo, destroyObject._id);
                    } catch(e: Dynamic) {

                    }
                }
            }
            collection.remove(destroyObject, function(err, data): Void {
                onSuccess(destroyObject);
            });
        });
    }

}
