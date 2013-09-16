package com.thoughtorigin.util;

import haxe.Timer;

class GlobalTimer {
	public static var timers: Map<Int, Timer> = new Map<Int, Timer>();

	public static function setInterval(func: Void->Void, milli: Int): Int {
		var timer: Timer = new Timer(milli);
		var id: Int = Std.int(Math.random() * 0xffffff);
		timers.set(id, timer);
		timer.run = function(): Void {
			func();
		}
		return id;
	}

	public static function clearInterval(id: Int): Void {
		var timer: Timer = timers.get(id);
		if(timer != null) {
			timer.stop();
			timers.remove(id);
		}
	}

    public static function setTimeout(func: Void->Void, milli: Int): Int {
        var id: Int = 0;
        id = setInterval(function(): Void {
            clearInterval(id);
            func();
        }, milli);
        return id;
    }
}
