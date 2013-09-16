package tasks;
import core.ObjectFactory;
class MappedTaskLookup implements TaskLookup {

    public var _tasks: Map<String, Class<Task>>;

    public function new() {
        _tasks = new Map<String, Class<Task>>();
    }

    public function getTaskByName(name:String):Task {
        var task: Class<Task> = _tasks.get(name);
        if(task == null) {
            return null;
        }
        return ObjectFactory.createObject(task);
    }

}
