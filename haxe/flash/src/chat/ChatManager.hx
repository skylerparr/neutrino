package chat;
import core.BaseObject;
import core.ObjectCreator;
class ChatManager implements BaseObject {

    @inject
    public var objectCreator: ObjectCreator;

    private var _chatConnector: ChatConnector;
    private var _connected: Bool;

    private var _chatRooms: List<String>;

    private var _chatHandlers: List<Dynamic->Void>;
    private var _roomListHandler: Array<Dynamic>->Void;
    private var _privateRoomCreatedHandler: String->Dynamic->Void;

    public function new() {
    }

    public function init():Void {
        _chatConnector = objectCreator.createInstance(ChatConnector);
        _chatRooms = new List<String>();
        _chatHandlers = new List<Dynamic->Void>();
    }

    public function dispose():Void {
    }

    public function connect(onComplete: Void->Void, chatHandler: Dynamic->Void,
                            roomListHandler: Array<Dynamic>->Void,
                            privateRoomCreatedHandler: String->Dynamic->Void): Void {
        _chatHandlers.push(chatHandler);
        if(_connected) {
            onComplete();
            return;
        }
        trace("attempting to connect to chat");
        _chatConnector.connect(function(): Void {
            trace("chat connected");
            _chatConnector.subscribe(ChatActionNames.RECEIVE_CHAT, onReceiveChat);
            _chatConnector.subscribe(ChatActionNames.ROOM_LIST, onRoomList);
            _chatConnector.subscribe(ChatActionNames.PRIVATE_CHAT_STARTED, onPrivateChatStarted);
            _chatConnector.send(ChatActionNames.CONNECT_TO_CHAT, "");
            _connected = true;
            for(room in _chatRooms) {
                joinChatRoom(room);
            }
            _roomListHandler = roomListHandler;
            _privateRoomCreatedHandler = privateRoomCreatedHandler;
            onComplete();
        });
    }

    private function onReceiveChat(transferVO:ChatTransferVO):Void {
        for(chatHandler in _chatHandlers) {
            chatHandler(transferVO.data);
        }
    }

    public function unSubscribe(chatHandler: Dynamic->Void): Void {
        _chatHandlers.remove(chatHandler);
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

    private function onRoomList(t:ChatTransferVO):Void {
        _roomListHandler(t.data.rooms);
    }

    public function fetchRooms(): Void {
        _chatConnector.send(ChatActionNames.GET_CHAT_ROOMS, "");
    }

    public function startPrivateChat(chatUserId:String, data: Dynamic = null):Void {
        _chatConnector.send(ChatActionNames.START_PRIVATE_CHAT, {chatUserId: chatUserId, data: data});
    }

    private function onPrivateChatStarted(t:ChatTransferVO):Void {
        _privateRoomCreatedHandler(t.data.roomName, t.data.data);
    }
}
