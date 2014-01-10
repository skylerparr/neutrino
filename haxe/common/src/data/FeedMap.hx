package data;
interface FeedMap {
    /**
     * all feeds available
     */
    var feeds(get, null): Array<FeedItem>;

    /**
     * retrieves a feed by name, null if the feed is not found.
     */
    function getFeedByName(name: String): FeedItem;
}
