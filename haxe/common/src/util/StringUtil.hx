package util;
class StringUtil {
    public function new() {
    }

    public static inline function isBlank(value: String): Bool {
        return (value == null || value == "");
    }
}
