package data;
import Dynamic;
import js.Node.*;
import js.npm.sequelize.*;
import js.npm.sequelize.Sequelize;

typedef SequelizeConfig = {
    host: String,
    dialect: String,
    pool: Dynamic,
    databaseName: String,
    username: String,
    password: String
}

class SequelDataLoader implements DataLoader {

    private var sequelize: Sequelize;

    public function new(config: SequelizeConfig) {
        var options : SequelizeOptions = {
            host: config.host,
            dialect: config.dialect,

            pool: config.pool
        }

        var sequelize = new Sequelize(config.databaseName, config.username, config.password, options);
    }

    public function connect(success: SequelDataLoader->Void, fail: String->Dynamic->Void): Void {
        sequelize
        .authenticate()
        .then(function(err) {
            success(this);
        })
        .Catch(function (err) {
            fail("Unable to connect to the database", err);
        });
    }

    public function read(feedName:String, onSuccess:Array<Dynamic>->Void, onFail:String->Void, queryData:Dynamic = null):Void {

    }

    public function save(feedName:String, onSuccess:Dynamic->Void, onFail:String->Void, saveObject:Dynamic):Void {

    }

    public function destroy(feedName:String, onSuccess:Dynamic->Void, onFail:String->Void, destroyObject:Dynamic):Void {
    }

}