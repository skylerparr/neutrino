package chat;

import data.Connector;
import assets.AssetLocator;
import loader.AssetLoader;
import chat.ChatClientId;
import data.ByteArrayIOStream;
import chat.ChatActionNames;
import util.Parser;
import data.SocketEvent;
import data.SocketConnection;
import actions.ClientTypes;
import util.AnonFunc;
import util.GlobalTimer;
import data.TransferVO;
import haxe.Json;

class ChatConnector implements Connector {

    private inline static var RETRY_TIMEOUT: Int = 2000;

    private var _subscriptionsMap: Map<String, Array<ChatTransferVO -> Void>>;
    private var _socketConnection: SocketConnection;
    private var _connectCallback: String -> Void;
    private var _numberOfBytesSent: Int;
    private var _messagesToSend: List<Message>;
    private var _currentMessage: Message;
    private var _parser: Parser;

    public var _clientType(default, default): String;
    public var connected(get, null): Bool;

    @inject
    public var assetLocator: AssetLocator;

    @inject
    public var clientId: ChatClientId;

    public function new(): Void {
        _subscriptionsMap = new Map<String, Array<ChatTransferVO -> Void>>();
        _messagesToSend = new List<Message>();
        _socketConnection = new SocketConnection();
        _parser = new Parser(new ByteArrayIOStream());

        _socketConnection.addEventListener(SocketEvent.CONNECTED, onSocketConnected);
        _socketConnection.addEventListener(SocketEvent.CLOSED, onSocketClosed);
    }

    private function onSocketClosed(e: SocketEvent): Void {
        trace("disconnected");
    }

    private function get_connected(): Bool {
        return connected;
    }

    public function init():Void {
    }

    public function dispose():Void {
        _socketConnection.disconnect();
        _subscriptionsMap = null;
        _socketConnection = null;
        _connectCallback = null;
        _messagesToSend = null;
        _parser = null;
        assetLocator = null;
        clientId = null;
    }

    private function onDataReceived(event: SocketEvent): Void {
        var objs: Array<Dynamic> = _parser.parseJSON(event.data);
        for(data in objs) {
            if(data.id == null) {
                continue;
            }
            var action: String = data.action;

            var subscriptions: Array<ChatTransferVO -> Void> = _subscriptionsMap.get(action);
            if(subscriptions == null) {
                return;
            }

            var retVal: ChatTransferVO = new ChatTransferVO();
            retVal.id = data.id;
            retVal.action = action;
            retVal.clientType = data.clientType;

            if(data.data == null) {
                data.data = {};
            }
            retVal.data = data.data;

            for(i in 0...subscriptions.length) {
                var func: ChatTransferVO -> Void = subscriptions[i];
                func(retVal);
            }
        }
    }

    private function onSocketConnected(event: SocketEvent): Void {
        connected = true;
        _socketConnection.removeEventListener(SocketEvent.CONNECTED, onSocketConnected);
        _socketConnection.addEventListener(SocketEvent.DATA_RECEIVED, onDataReceived);

        subscribe(ChatActionNames.CONNECT_TO_CHAT, onConnectedToChat);
        send(ChatActionNames.CONNECT_TO_CHAT, null);
    }

    private function onConnectedToChat(t:ChatTransferVO):Void {
        unSubscribe(ChatActionNames.CONNECT_TO_CHAT, onConnectedToChat);
        _connectCallback(t.id);
    }

    public function connect(connectCallback: String -> Void): Void {
        _connectCallback = connectCallback;
        getConnectionSettings();
    }

    public function getConnectionSettings(): Void {
        assetLocator.getDataAssetByName("assets/settings/chatConnectionSettings.json", onConnectionSettingsLoaded);
    }

    public function onConnectionSettingsLoaded(data: String): Void {
        trace(data);
        var connData: Dynamic = Json.parse(data);
        _socketConnection.host = connData.host;
        _socketConnection.port = connData.port;
    }

    public function send(action: String, data: Dynamic): Void {
        var dataTransfer: ChatTransferVO = new ChatTransferVO();
        dataTransfer.id = clientId.id;
        dataTransfer.clientType = ClientTypes.GAME;
        dataTransfer.action = action;
        dataTransfer.data = data;
        _socketConnection.sendData(dataTransfer.toString());
    }

    private function sendNext(message: Message): Void {
        var intervalId: Int = GlobalTimer.setInterval(AnonFunc.call(retrySend, [message.transfer]), RETRY_TIMEOUT);
        message.timeoutId = intervalId;
        _socketConnection.sendData(message.transfer.toString());
    }

    private function retrySend(transfer: TransferVO): Void {
        _socketConnection.sendData(transfer.toString());
    }

    private inline function dataReceivedResponse(messageId: String): Void {
        var dataVO: ChatTransferVO = new ChatTransferVO(clientId.id, ChatActionNames.RECEIVE_CHAT, ClientTypes.GAME, {message: {rm: messageId}});
        _socketConnection.sendData(dataVO.toString());
    }

    public function subscribe(action: String, handler: ChatTransferVO -> Void): Void {
        var subscriptions: Array<ChatTransferVO -> Void> = _subscriptionsMap.get(action);
        if(subscriptions == null) {
            subscriptions = new Array<ChatTransferVO -> Void>();
        }
        subscriptions.push(handler);
        _subscriptionsMap.set(action, subscriptions);
    }

    public function unSubscribe(action: String, handler: ChatTransferVO -> Void): Void {
        var subscriptions: Array<ChatTransferVO -> Void> = _subscriptionsMap.get(action);
        if(subscriptions != null) {
            for( i in 0...subscriptions.length) {
                var func: ChatTransferVO -> Void = subscriptions[i];
                if(func == handler) {
                    subscriptions.splice(i, 1);
                    return;
                }
            }
        }
    }
}

typedef Message = {
    messageId: String,
    timeoutId: Int,
    transfer: TransferVO,
}
