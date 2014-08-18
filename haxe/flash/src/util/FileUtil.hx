package util;
#if cpp
import haxe.crypto.Md5;
import haxe.Json;
import sys.FileStat;
import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File;
import sys.FileStat;
#end
import flash.net.SharedObject;

@:build( ShortCuts.mirrors() )
class FileUtil {
    public function new() {
    }

    public static inline function saveString(path: String, data: String): Void {
        #if flash
        var so: SharedObject = SharedObject.getLocal(path);
        so.setProperty(path, data);
        so.flush();
        #else
        try {
            File.saveContent(path, data);
            addSkipBackupAttributeToItem("file://" + path);
        } catch(e: Dynamic) {
            trace(e);
        }
        #end
    }

    public static inline function readFile(path: String): String {
        #if flash
        var so: SharedObject = SharedObject.getLocal(path);
        if(Reflect.field(so.data, path) == null) {
            return null;
        } else {
            return Reflect.field(so.data, path);
        }
        #else
        var retVal: String = null;
        if(FileSystem.exists(path)) {
            try {
                retVal = File.getContent(path);
            } catch(e: Dynamic) {
                trace(e);
                retVal = null;
            }
        }
        return retVal;
        #end
    }

    #if cpp
    public static inline function saveBytes(path: String, bytes: Bytes): Void {
        try {
            File.saveBytes(path, bytes);
            addSkipBackupAttributeToItem("file://" + path);
        } catch(e: Dynamic) {
            trace(e);
        }
    }

    public static inline function readFileBytes(path: String): Bytes {
        try {
            return File.getBytes(path);
        } catch(e: Dynamic) {
            trace(e);
            return null;
        }
    }

    #end

    public static inline function getStoragePath(): String {
        #if ios
        var retVal: String = flash.filesystem.File.applicationStorageDirectory.nativePath + "/Library/Caches/";
        if(!sys.FileSystem.exists(retVal)) {
            sys.FileSystem.createDirectory(retVal);
        }
        return retVal;
        #elseif flash
        return "";
        #else
        return flash.filesystem.File.applicationStorageDirectory.nativePath + "/";
        #end
    }

    public static inline function removeFile(path: String): Void {
        #if flash
        var so: SharedObject = SharedObject.getLocal(path);
        if(Reflect.field(so.data, path) != null) {
            return Reflect.setField(so.data, path, null);
        }
        #else
        var retVal: String = null;
        if(FileSystem.exists(path)) {
            try {
                FileSystem.deleteFile(path);
            } catch(e: Dynamic) {
                trace(e);
            }
        }
        #end
    }

    #if ios
    @CPP("iosskipbackups", "iosskipbackups_addSkipBackupAttributeToItem")
    #end
    public static function addSkipBackupAttributeToItem(path:String):Void {

    }
}
