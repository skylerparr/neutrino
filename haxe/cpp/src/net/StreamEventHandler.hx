package net;
import io.InputOutputStream;
import io.OutputStream;
import io.InputStream;
interface StreamEventHandler {
    function onConnect(stream: InputOutputStream): Void;
    function onData(stream: InputOutputStream): Void;
    function onError(stream: InputOutputStream): Void;
    function onDisconnect(stream: InputOutputStream): Void;
}
