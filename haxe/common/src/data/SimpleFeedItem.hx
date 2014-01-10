package data;
class SimpleFeedItem implements FeedItem {
    public var value(get, null): String;

    public function new(value: String) {
        this.value = value;
    }

    public function get_value(): String {
        return value;
    }
}
