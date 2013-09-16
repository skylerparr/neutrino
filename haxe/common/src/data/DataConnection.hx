package com.thoughtorigin.data;
interface DataConnection {
    function subscribe(action: String, handler: TransferVO -> Void): Void;
    function unSubscribe(action: String, handler: TransferVO -> Void): Void;
    function send(transferVO: TransferVO): Void;
}
