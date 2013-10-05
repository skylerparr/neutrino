package data;
import vo.ValueObject;
interface SubscribeDataLoader {
    function subscribe(name: String, callback: ValueObject->Void, params: Dynamic = null): Void;
    function unSubscribe(name: String, callback: ValueObject->Void): Void;
}
