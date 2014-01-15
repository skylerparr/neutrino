package data;
import org.mongodb.Collection;
import org.mongodb.Cursor;
import org.mongodb.Database;
import data.DataLoader;
class MongodbDataLoader implements DataLoader {

    public var database: Database;

    public function new() {
    }

    public function read(feedName:String, onSuccess:Array<Dynamic> -> Void, onFail:String -> Void, queryData:Dynamic = null):Void {
        var collection: Collection = database.getCollection(feedName);
        if(collection == null) {
            onFail("collection " + feedName + " not found.");
        } else {
            var all: Cursor = collection.find(queryData);
            var retVal: Array<Dynamic> = [];
            for(item in all) {
                retVal.push(item);
            }
            onSuccess(retVal);
        }
    }

    public function save(feedName:String, onSuccess:Dynamic -> Void, onFail:String -> Void, saveObject:Dynamic):Void {
        var collection: Collection = database.getCollection(feedName);
        if(collection == null) {
            onFail("collection " + feedName + " not found.");
        } else {
            var save: Bool = false;
            var item: Dynamic = collection.findOne({_id: saveObject._id});
            if(item == null) {
                item = {};
                save = true;
            }
            if(save) {
                collection.insert(saveObject);
            } else {
                collection.update({_id: saveObject._id}, saveObject);
            }
            item = collection.findOne({_id: saveObject._id});
            onSuccess(item);
        }

    }

    public function destroy(feedName:String, onSuccess:Dynamic -> Void, onFail:String -> Void, destroyObject:Dynamic):Void {
        var collection: Collection = database.getCollection(feedName);
        if(collection == null) {
            onFail("collection " + feedName + " not found.");
        } else {
            var item: Dynamic = collection.findOne({_id: destroyObject._id});
            if(item == null) {
                onFail("item " + item._id + " not found in database");
            } else {
                var script: String = "db.users.remove({_id:" + StringTools.replace(item._id, "ObjectID", "ObjectId") + "})";
                database.runScript("db." + collection.name + ".remove(" + script + ")");
                onSuccess(destroyObject);
            }
        }
    }
}
