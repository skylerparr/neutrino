package util;
class DateFormatter {
    public static var MONTHS:Array<String> = ["January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"];

    public static function getFormattedDate(date:Date = null, condenseDate:Bool = false):String {
        if (date == null) {
            date = Date.now();
        }

        var minutes:Float = date.getMinutes();
        var hours:Float = date.getHours();
        var seconds:Float = date.getSeconds();

        var minutesString:String = date.getMinutes() + "";
        var hoursString:String = date.getHours() + "";
        var secondsString:String = date.getSeconds() + "";

        var ampm:String = " am";

        if (hours > 12) {
            hoursString = (hours - 12) + "";
            ampm = "pm";
        }

        if (minutes < 10) {
            minutesString = "0" + minutes;
        }

        if (seconds < 10) {
            secondsString = "0" + secondsString;
        }

        var currentDate:String = condenseDate ? (date.getMonth() + 1 + "/" + date.getDate() + "/" + (date.getFullYear() - 2000)) : (MONTHS[date.getMonth()] + " " + date.getDate() + ", " + date.getFullYear());
        var time:String = hoursString + ":" + minutesString + (condenseDate ? "" : ":" + secondsString) + " " + ampm;
        return currentDate + " " + time;
    }

    public static function getTime(date:Date = null, isAmpm:Bool = true):String {
        if (date == null) {
            date = Date.now();
        }

        var minutes:Float = date.getMinutes();
        var hours:Float = date.getHours();
        var seconds:Float = date.getSeconds();

        var minutesString:String = date.getMinutes() + "";
        var hoursString:String = date.getHours() + "";
        var secondsString:String = date.getSeconds() + "";

        var ampm:String = " am";

        if (hours > 12) {
            hoursString = (hours - 12) + "";
            ampm = "pm";
        }

        if (minutes < 10) {
            minutesString = "0" + minutes;
        }

        if (seconds < 10) {
            secondsString = "0" + secondsString;
        }

        var time:String = hoursString + ":" + minutesString + ":" + secondsString + (isAmpm ? " " + ampm : "");
        return time;
    }


    public static function toDateString(dateInSeconds:Int, condenseDate:Bool = false):String {
        var date:Date = Date.fromTime(dateInSeconds * 1000); //Convert to MS
        return getFormattedDate(date, condenseDate);
    }

    public static function toTimeString(dateInSeconds:Int, isAMpm:Bool = true):String {
        var date:Date = Date.fromTime(dateInSeconds * 1000); //Convert to MS
        return getTime(date, isAMpm);
    }

    public static function secondsToTimeString(seconds:Int):String {
        if (Math.isNaN(seconds)) {
            return '0';
        }
        var dayString:String = "";
        var hourString:String = "";
        var minString:String = "";
        var secString:String = "";

        var sec:Int = seconds % 60;
        var min:Int = Math.floor((seconds % 3600) / 60);
        var hour:Int = Math.floor(seconds / 3600) % 24;
        var day:Int = Math.floor(seconds / 86400);

        if (day > 0) {
            dayString = day > 9 ? day + "d " : '0' + day + 'd ';
        }
        if (hour > 0) {
            hourString = hour > 9 ? hour + "h " : '0' + hour + 'h ';
        }
        if (min > 0) {
            minString = min > 9 ? min + "m " : '0' + min + 'm ';
        }
        if (sec > 0) {
            secString = sec > 9 ? sec + "s " : '0' + sec + 's ';
        }

        return dayString + hourString + minString + secString;

    }

    public static function secondsToDelimitedTime(seconds:Int, delimiter:String = ":"):String {
        if (Math.isNaN(seconds)) {
            return '0';
        }
        var dayString:String = "";
        var hourString:String = "";
        var minString:String = "";
        var secString:String = "";

        var sec:Int = seconds % 60;
        var min:Int = Math.floor((seconds % 3600) / 60);
        var hour:Int = Math.floor(seconds / 3600) % 24;
        var day:Int = Math.floor(seconds / 86400);

        if (day > 0) {
            dayString = day > 9 ? day + delimiter : '0' + day + delimiter;
        }
        if (hour > 0) {
            hourString = hour > 9 ? hour + delimiter : '0' + hour + delimiter;
        }
        if (min > 0) {
            minString = min > 9 ? min + delimiter : '0' + min + delimiter;
        } else {
            minString = "00";
        }
        if (sec > 0) {
            secString = sec > 9 ? sec + "" : '0' + sec;
        } else {
            secString = "00";
        }

        return dayString + hourString + minString + secString;
    }

    public static function prettyStyleDate(timeStamp:Float, currentTime:Float = 0):String {
        var diff:Float = 0;
        if (currentTime != 0) {
            diff = currentTime - timeStamp;
        } else {
            var dateNow:Date = Date.now();
            var date:Date = Date.fromTime(timeStamp);
            diff = ((dateNow.getTime() - date.getTime()));
        }

        diff /= 1000;

        var day_diff:Float = Math.floor(diff / 86400);

        if (Math.isNaN(day_diff) || day_diff < 0 || day_diff > 31) {
            return "over a month ago";
        } else if (day_diff == 0) {
            if (diff < 60) {
                return "just now";
            } else if (diff < 120) {
                return "1 min ago";
            } else if (diff < 3600) {
                return Math.floor(diff / 60) + " min ago";
            } else if (diff < 7200) {
                return "1 hour ago";
            } else if (diff < 86400) {
                return Math.floor(diff / 3600) + " hours ago";
            }
        } else if (day_diff == 1) {
            return "yesterday";
        } else if (day_diff < 7) {
            return day_diff + " days ago";
        } else if (day_diff < 31) {
            return Math.ceil(day_diff / 7) + " weeks ago";
        }
        return null;
    }

    public static inline function toUtc(date: Date): Date {
        return Date.fromTime(DateTools.makeUtc(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds()));
    }
}
