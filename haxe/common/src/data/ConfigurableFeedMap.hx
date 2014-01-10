package data;
class ConfigurableFeedMap implements FeedMap {
    public var feeds(get, null): Array<FeedItem>;

    private var _map: Map<String,FeedItem>;

    public function new() {
        _map = new Map<String, FeedItem>();
    }

    public function get_feeds(): Array<FeedItem> {
        var retVal: Array<FeedItem> = [];
        for(item in _map) {
            retVal.push(item);
        }
        return retVal;
    }

    public function getFeedByName(name:String):FeedItem {
        return _map.get(name);
    }

    public function addFeed(name: String, value: String): Void {
        var item: SimpleFeedItem = new SimpleFeedItem(value);
        _map.set(name, item);
    }

    public function removeFeed(name: String): Void {
        _map.remove(name);
    }
}
