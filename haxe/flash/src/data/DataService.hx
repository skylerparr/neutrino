package flash.data;

import data.TransferVO;
interface DataService {
	function subscribe(action: String, handler: TransferVO -> Void): Void;
	function unSubscribe(action: String, handler: TransferVO -> Void): Void;
	function connect(ipAddress: String): Void;
	function send(transferVO: TransferVO): Void;
}
