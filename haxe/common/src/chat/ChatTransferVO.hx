package chat;
import data.TransferVO;
import haxe.Json;
class ChatTransferVO implements TransferVO {
    public var id: String;
    public var action: String;
    public var clientType: String;
    public var data: Dynamic;

    public function new(?id: String = null, ?action: String = null, ?clientType: String = null, ?data: Dynamic = null) {
        this.id = id;
        this.action = action;
        this.clientType = clientType;
        this.data = data;
    }

    public function toString():String {
        var obj: Dynamic = {id: id, action: action, clientType: clientType, data: data};
        return Json.stringify(obj);
    }
}
