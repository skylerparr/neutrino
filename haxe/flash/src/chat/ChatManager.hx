package chat;
import core.BaseObject;
import core.ObjectCreator;
class ChatManager implements BaseObject {

    @inject
    public var objectCreator: ObjectCreator;

    private var _chatConnector: ChatConnector;

    public function new() {
    }

    public function init():Void {
        _chatConnector = objectCreator.createInstance(ChatConnector);
    }

    public function dispose():Void {
    }

    public function connect(onComplete: Void->Void, chatHandler: Dynamic->Void): Void {
        _chatConnector.connect(function(): Void {
            _chatConnector.subscribe(ChatActionNames.RECEIVE_CHAT, function(transferVO: ChatTransferVO): Void {
                chatHandler(transferVO.data);
            });
            _chatConnector.send(ChatActionNames.CONNECT_TO_CHAT, "");
        });
    }

    public function joinChatRoom(roomName: String): Void {
        _chatConnector.send(ChatActionNames.JOIN_CHAT_ROOM, {roomName: roomName});
    }

    public function leaveChatRoom(roomName: String): Void {
        _chatConnector.send(ChatActionNames.LEAVE_CHAT_ROOM, {roomName: roomName});
    }

    public function sendChat(message: Dynamic, roomName: String): Void {
        _chatConnector.send(ChatActionNames.RECEIVE_CHAT, {roomName: roomName, message: message});
    }
}
