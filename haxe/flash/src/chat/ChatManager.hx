package chat;
import core.BaseObject;
import core.ObjectCreator;
class ChatManager implements BaseObject {

    @inject
    public var objectCreator: ObjectCreator;

    private var _chatConnector: ChatConnector;
    private var _connected: Bool;

    private var _chatRooms: List<ChatRoomDef>;

    private var _chatHandlers: List<Dynamic->Void>;
    private var _roomListHandler: Array<Dynamic>->Void;
    private var _privateRoomCreatedHandler: String->Dynamic->Void;
    private var _chatRoomRemovedHandler: String->Void;
    private var _chatId: String;

    public function new() {
    }

    public function init():Void {
        _chatConnector = objectCreator.createInstance(ChatConnector);
        _chatRooms = new List<ChatRoomDef>();
        _chatHandlers = new List<Dynamic->Void>();
    }

    public function dispose():Void {
        _chatConnector.dispose();
        _connected = false;
    }

    public function connect(onComplete: String->Void, chatHandler: Dynamic->Void,
                            roomListHandler: Array<Dynamic>->Void,
                            privateRoomCreatedHandler: String->Dynamic->Void,
                            chatRoomRemovedHandler: String->Void): Void {
        _chatHandlers.push(chatHandler);
        if(_connected) {
            onComplete(_chatId);
            return;
        }
        trace("attempting to connect to chat");
        _chatConnector = objectCreator.createInstance(ChatConnector);
        _chatConnector.connect(function(chatId: String): Void {
            trace("chat connected");
            _chatConnector.subscribe(ChatActionNames.RECEIVE_CHAT, onReceiveChat);
            _chatConnector.subscribe(ChatActionNames.ROOM_LIST, onRoomList);
            _chatConnector.subscribe(ChatActionNames.PRIVATE_CHAT_STARTED, onPrivateChatStarted);
            _chatConnector.subscribe(ChatActionNames.CHAT_CLOSED, onChatRoomRemoved);
            _chatConnector.send(ChatActionNames.CONNECT_TO_CHAT, "");
            _connected = true;
            for(room in _chatRooms) {
                joinChatRoom(room.roomName, room.objectId);
            }
            _roomListHandler = roomListHandler;
            _privateRoomCreatedHandler = privateRoomCreatedHandler;
            _chatRoomRemovedHandler = chatRoomRemovedHandler;
            _chatId = chatId;
            onComplete(_chatId);
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

    public function joinChatRoom(roomName: String, objectId: String): Void {
        if(_connected) {
            trace("joined room");
            _chatConnector.send(ChatActionNames.JOIN_CHAT_ROOM, {roomName: roomName, objectId: objectId});
        } else {
            _chatRooms.push({roomName: roomName, objectId: objectId});
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

    private function onChatRoomRemoved(t:ChatTransferVO):Void {
        if(_chatRoomRemovedHandler != null) {
            _chatRoomRemovedHandler(t.data.roomName);
        }
    }
}

typedef ChatRoomDef = {
    roomName: String,
    objectId: String
}