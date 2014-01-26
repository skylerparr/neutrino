package translation;

import util.Subscriber;
import flash.events.IEventDispatcher;
interface TranslationManager extends Subscriber {
    /**
     * get/set the current locale for querying reasons.
     */
    var currentLocale(default, set): String;

    /**
     * Attempts to resolve the key to a translation string.
     * If no key is found then the original string is returned
     *
     * @param key to look up the translation
     * @return the value of the key
     */
    function getTextByKey( key: String ): String;

}
