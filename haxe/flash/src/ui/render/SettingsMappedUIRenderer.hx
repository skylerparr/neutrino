package ui.render;
import ui.render.Renderable;
import ui.render.Controller;
import util.AnonFunc;
import flash.display.DisplayObject;
import core.BaseObject;
import haxe.Json;
import flash.display.DisplayObject;
import core.ObjectCreator;
import haxe.ds.ObjectMap;
class SettingsMappedUIRenderer implements UIRenderer {

    @inject
    public var objectCreator: ObjectCreator;

    private var _modalMap: Map<String, String>;
    private var _triadMap: ObjectMap<Dynamic, Triad>;

    public function new() {
    }

    public function renderView(name:String, onComplete:DisplayObject -> Void):Void {
        if(_modalMap == null) {
            _modalMap = getModalMap();
            _triadMap = new ObjectMap<Dynamic, Triad>();
        }
        var view: Dynamic = createInstanceByName(_modalMap.get(name) + "View");
        var controller: Dynamic = createInstanceByName(_modalMap.get(name) + "Controller");
        var actions: Dynamic = createInstanceByName(_modalMap.get(name) + "Actions");

        if(view != null) {
            assignIfAvailable(view, "controller", controller);
            assignIfAvailable(view, "actions", actions);
            assignIfAvailable(actions, "controller", controller);
            assignIfAvailable(actions, "view", view);
            assignIfAvailable(controller, "actions", actions);
            assignIfAvailable(controller, "view", view);
            _triadMap.set(view, {view: view, controller: controller, actions: actions});
            if(Std.is(controller, Controller)) {
                cast(controller).setup(AnonFunc.call(callRender, [view, onComplete]));
            } else if(Std.is(view, Renderable)) {
                callRender(view, onComplete);
            } else {
                done(view, onComplete);
            }
        }
    }

    private inline function callRender(view:DisplayObject, onComplete:DisplayObject -> Void):Void {
        if (Std.is(view, Renderable)) {
            cast(view, Renderable).render(AnonFunc.call(done, [view, onComplete]));
        }
    }

    private inline function done(view: DisplayObject, onComplete: DisplayObject->Void): Void {
        if(onComplete != null) {
            onComplete(view);
        }
    }

    private inline function assignIfAvailable(target: Dynamic, field: String, assignee: Dynamic): Void {
        if(target != null) {
            try {
                Reflect.setProperty(target, field, assignee);
            } catch(e: Dynamic) {
                trace("field does not exist");
            }
        }
    }

    private inline function createInstanceByName(name:String):Dynamic {
        var retVal: Dynamic = null;
        var cls:Class<Dynamic> = Type.resolveClass(name);
        if (cls != null) {
            retVal = objectCreator.createInstance(cls);
        }
        return retVal;
    }

    public inline function getModalMap(): Map<String, String> {
        var modalDataString: String = getModalData();
        var modalData: Dynamic = Json.parse(modalDataString);
        var retVal: Map<String, String> = new Map<String, String>();
        var modals: Array<Dynamic> = modalData.modals;
        for(item in modals) {
            retVal.set(item.name, item.map);
        }
        return retVal;
    }

    public function getModalData(): String {
        throw "getModalData() needs to overridden";
        return "";
    }

    public function dispose(displayObject:DisplayObject, onComplete:Void -> Void):Void {
        var triad: Triad = _triadMap.get(displayObject);
        if(triad != null) {
            if(Std.is(triad.view, BaseObject)) {
                cast(triad.view).dispose();
            }
            if(Std.is(triad.controller, BaseObject)) {
                cast(triad.controller).dispose();
            }
            if(Std.is(triad.actions, BaseObject)) {
                cast(triad.actions).dispose();
            }
        }
        if(onComplete != null) {
            onComplete();
        }
    }
}

typedef Triad = {
    view: Dynamic,
    controller: Dynamic,
    actions: Dynamic
}
