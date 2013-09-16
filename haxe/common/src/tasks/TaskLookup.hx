package tasks;
interface TaskLookup {
    function getTaskByName(name: String): Task;
}
