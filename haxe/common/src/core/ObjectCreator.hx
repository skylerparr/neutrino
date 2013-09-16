package com.thoughtorigin.core;
interface ObjectCreator {
    function createInstance(clazz: Class<Dynamic>, ?constructorArgs: Array<Dynamic>): Dynamic;
}
