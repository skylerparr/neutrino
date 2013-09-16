package tasks;
import data.TransferVO;
interface Task {
    var name(get, null): String;
    function execute(taskData: TransferVO): Void;
}
