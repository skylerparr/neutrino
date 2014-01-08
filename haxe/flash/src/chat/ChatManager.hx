package chat;
import core.BaseObject;
import core.ObjectCreator;
class ChatManager implements BaseObject {

    @inject
    public var objectCreator: ObjectCreator;

    private var _chatConnector: ChatConnector;
    private var _connected: Bool;

    private var _chatRooms: List<String>;

    public function new() {
    }

    public function init():Void {
        _chatConnector = objectCreator.createInstance(ChatConnector);
        _chatRooms = new List<String>();
    }

    public function dispose():Void {
    }

    public function connect(onComplete: Void->Void, chatHandler: Dynamic->Void): Void {
        trace("attempting to connect to chat");
        _chatConnector.connect(function(): Void {
            trace("chat connected");
            _chatConnector.subscribe(ChatActionNames.RECEIVE_CHAT, function(transferVO: ChatTransferVO): Void {
                chatHandler(transferVO.data);
            });
            _chatConnector.send(ChatActionNames.CONNECT_TO_CHAT, "");
            _connected = true;
            for(room in _chatRooms) {
                joinChatRoom(room);
            }
        });
    }

    public function joinChatRoom(roomName: String): Void {
        if(_connected) {
            trace("joined room");
            _chatConnector.send(ChatActionNames.JOIN_CHAT_ROOM, {roomName: roomName});
        } else {
            _chatRooms.push(roomName);
        }
    }

    public function leaveChatRoom(roomName: String): Void {
        _chatConnector.send(ChatActionNames.LEAVE_CHAT_ROOM, {roomName: roomName});
    }

    public function sendChat(message: Dynamic, roomName: String): Void {
        _chatConnector.send(ChatActionNames.RECEIVE_CHAT, {roomName: roomName, message: message});
    }
}
