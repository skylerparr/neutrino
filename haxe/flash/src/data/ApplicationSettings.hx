package data;

interface ApplicationSettings {
    function getBasePath():String;
    function getBaseAssetsPath():String;
    function getFeeds():Map<String, Dynamic>;
    function getSetting(name:String):Dynamic;
}
