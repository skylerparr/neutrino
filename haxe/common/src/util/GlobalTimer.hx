package util;

import haxe.Timer;

class GlobalTimer {
  public static var timers: Map<UInt, Timer> = new Map<UInt, Timer>();

  public static function setInterval(func: Void -> Void, milli: UInt): UInt {
    var timer: Timer = new Timer(milli);
    var id: UInt = Std.int(Math.random() * 0xffffff);
    timers.set(id, timer);
    timer.run = func;
    return id;
  }

  public static function clearInterval(id: UInt): Void {
    var timer: Timer = timers.get(id);
    if(timer != null) {
      timer.stop();
      timers.remove(id);
    }
  }

  public static function setTimeout(func: Void -> Void, milli: UInt): UInt {
    var id: UInt = 0;
    id = setInterval(function(): Void {
      clearInterval(id);
      func();
    }, milli);
    return id;
  }
}
