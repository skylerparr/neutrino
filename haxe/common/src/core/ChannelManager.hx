package core;
import data.DataConnection;
import io.InputOutputStream;
interface ChannelManager extends Channels {
    function addChannel(clientId:String, stream:DataConnection):Void;
    function removeChannel(clientId:String):Void;
    function exists(clientId: String): Bool;
}
