package com.thoughtorigin.welding;
interface MetaInformation {
    var metaName(getMetaName, null): String;
    var metaArgs(getMetaArgs, null): Hash<String>;
    var object(getObject, null): Dynamic;
    var functionName(getFunctionName, null): String;
    var functionArgs(getFunctionArgs, null): List<Class>;
}
