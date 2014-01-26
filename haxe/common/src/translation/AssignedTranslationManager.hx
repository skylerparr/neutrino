package translation;
import util.MapSubscriber;
import flash.events.EventDispatcher;
class AssignedTranslationManager extends MapSubscriber implements TranslationManager {

    @:isVar
    public var currentLocale(default, set): String;

    private var _data: Dynamic;

    public function new() {
        super();
    }

    public function setLocaleData(data: Dynamic): Void {
        _data = data;
    }

    public inline function getTextByKey( key: String ): String {
        var origKey: String = key;
        key = key.toLowerCase();
        if(Reflect.hasField(_data, key)) {
            return Reflect.field(_data, key);
        }
        return origKey;
    }

    private function set_currentLocale(value: String): String {
        this.currentLocale = value;
        notify(LocaleSubscriptions.LOCALE_CHANGED);
        return this.currentLocale;
    }

}
