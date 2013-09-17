package data;

import flash.events.Event;

class SocketEvent extends Event {
	inline public static var CONNECTED: String = "connected";
	inline public static var DATA_RECEIVED: String = "dataReceived";
	inline public static var CLOSED: String = "closed";

	private var _data: Dynamic;

	public var data(get, never): Dynamic;

	public function new(type: String, data: Dynamic): Void {
		_data = data;
		super(type, bubbles, cancelable);
	}

	public function get_data(): Dynamic {
		return _data;
	}
}
