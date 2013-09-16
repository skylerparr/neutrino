package com.thoughtorigin.tasks;
interface TaskLookup {
    function getTaskByName(name: String): Task;
}
