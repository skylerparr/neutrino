package data;

interface ApplicationSettings {
    function getBasePath():String;
    function getBaseAssetsPath():String;
    function getFeeds():Map<String, String>;
    function getSetting(name:String):Dynamic;
}
