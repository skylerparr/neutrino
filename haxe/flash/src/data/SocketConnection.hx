package data;

import flash.events.IOErrorEvent;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.XMLSocket;
//import flash.system.Security;

class SocketConnection extends EventDispatcher {
	private var _xmlConnect: XMLSocket;
	private var _host: String;
	private var _port: Int;

	public var host(never, set): String;
	public var port(never, set): Int;
	public var connected(get, never): Bool;

	public function new(): Void {
		_port = -1;
		_host = "";
		super();
	}

	public function sendData(data: Dynamic): Void {
		_xmlConnect.send(data);
	}

	private function createSocket(): Void {
		if(_host == "" || _port < 1024) {
			return;
		}
        trace(_host, _port);

//		Security.loadPolicyFile("xmlsocket://" + _host + ":" + _port);
		_xmlConnect = new XMLSocket();
		_xmlConnect.addEventListener(DataEvent.DATA, onDataReceived);
		_xmlConnect.addEventListener(Event.CONNECT, onConnect);
		_xmlConnect.addEventListener(Event.CLOSE, onDisconnect);
		_xmlConnect.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		_xmlConnect.connect(_host, _port);
	}

	private function onConnect(e: Event): Void {
		_xmlConnect.removeEventListener(Event.CONNECT, onConnect);
		dispatchEvent(new SocketEvent(SocketEvent.CONNECTED, null));
	}

	private function onDataReceived(e: DataEvent): Void {
		dispatchEvent(new SocketEvent(SocketEvent.DATA_RECEIVED, e.data));
	}

    private function onDisconnect(e: Event): Void {
        dispatchEvent(new SocketEvent(SocketEvent.CLOSED, null));
    }

    private function onIOError(e: IOErrorEvent): Void {
        //swallow for now
    }

	private function get_connected(): Bool {
		if(_xmlConnect == null) {
			return false;
		}
		return _xmlConnect.connected;
	}

	private function set_host(value: String): String {
		_host = value;
		createSocket();
		return _host;
	}

	private function set_port(value: Int): Int {
		_port = value;
		createSocket();
		return _port;
	}
}
