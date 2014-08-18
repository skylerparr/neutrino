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
import util.GlobalTimer;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import util.StringUtil;
import flash.display.BlendMode;
import flash.display.Bitmap;
import flash.display.DisplayObjectContainer;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import haxe.io.Bytes;
import flash.filters.BlurFilter;
import flash.display.Graphics;
import flash.display.BitmapData;
import flash.display.Shape;
import format.SVG;
import openfl.Assets;

class SVGRasterizerTool {

    public static inline var LOCAL_MANIFEST_FILE: String = "localManifest.json";

    private static var regx: EReg = ~/(\/)|(\s)|(\.)/g;

    private static var imageMap: Map<String, ImageCount> = new Map();
    private static var currentManifest: Dynamic;
    private static var authorityManifest: Dynamic;

    private static var delay: Int;

    public function new() {
    }

    public static inline function convertSVGToBitmapData(name: String, width: Float, height: Float, svgData: String, dontUseCache: Bool = false): BitmapData {
        var bitmapData: BitmapData = null;
        if(name == null) {
            name = Math.random() + "";
        }
        var key: String = name + ":" + width + ":" + height;
        if(imageMap.exists(key) && !dontUseCache) {
            var imageCount: ImageCount = imageMap.get(key);
            imageCount.count++;
            bitmapData = imageCount.bitmapData;
        } else {
            #if cpp
            var path = FileUtil.getStoragePath();
            var assetName: String = regx.replace(name, "_");
            path += StringTools.replace(name, "/", "_") + "_" + width + "x" + height + ".bmp";

            bitmapData = getDiskCachedImage(name, assetName, path, Std.int(width), Std.int(height));
            if(bitmapData == null) {
            #end
                bitmapData = getRenderedBitmapData(svgData, width, height);
            #if cpp
                saveCache(name, assetName, path, svgData, bitmapData);
            }
            #end
            imageMap.set(key, {count: 1, bitmapData: bitmapData});
        }

        return bitmapData;
    }

    private static inline function getRenderedBitmapData(svgData: String, width: Float, height: Float): BitmapData {
        var svg: SVG = new SVG(svgData);
        var iconWidth: Int = cast width;
        var iconHeight: Int = cast height;

        var shape: Shape = new Shape();
        var graphics: Graphics = shape.graphics;
        graphics.clear();
        graphics.beginFill(0,0);
        graphics.drawRect(0,0,iconWidth, iconHeight);
        graphics.endFill();
        svg.render(graphics, 0, 0, iconWidth, iconHeight);

        #if cpp
        shape.filters = [new BlurFilter(1.75, 1.75, 3)];
        #end
        var bitmapData: BitmapData = new BitmapData(iconWidth, iconHeight, true, 0);
        bitmapData.draw(shape);

        return bitmapData;
    }

    public static inline function convertSVGToBitmapDataAsync(name: String, width: Float, height: Float, svgData: String, onComplete: BitmapData->Void): Void {
        var bitmapData: BitmapData = null;
        if(name == null) {
            name = Math.random() + "";
        }
        var key: String = name + ":" + width + ":" + height;
        if(imageMap.exists(key)) {
            var imageCount: ImageCount = imageMap.get(key);
            imageCount.count++;
            bitmapData = imageCount.bitmapData;
            onComplete(bitmapData);
        } else {
            #if cpp
            var path: String = FileUtil.getStoragePath();
            var assetName: String = regx.replace(name, "_");
            assetName = StringTools.replace(name, "/", "_") + "_" + width + "x" + height + ".bmp";

            bitmapData = getDiskCachedImage(name, assetName, path, Std.int(width), Std.int(height));
            if(bitmapData == null) {
            #end
                GlobalTimer.setTimeout(function(): Void {
                    var svg: SVG = new SVG(svgData);
                    var iconWidth: Int = cast width;
                    var iconHeight: Int = cast height;

                    var shape: Shape = new Shape();
                    var graphics: Graphics = shape.graphics;
                    graphics.clear();
                    graphics.beginFill(0,0);
                    graphics.drawRect(0,0,iconWidth, iconHeight);
                    graphics.endFill();
                    svg.render(graphics, 0, 0, iconWidth, iconHeight);

                    #if cpp
                    shape.filters = [new BlurFilter(1.75, 1.75, 3)];
                    #end
                    GlobalTimer.setTimeout(function(): Void {
                        var bitmapData: BitmapData = new BitmapData(iconWidth, iconHeight, true, 0);
                        bitmapData.draw(shape);
                        #if cpp
                        saveCache(name, assetName, path + assetName, svgData, bitmapData);
                        #end
                        onComplete(bitmapData);
                        imageMap.set(key, {count: 1, bitmapData: bitmapData});
                    }, 0);
                }, 0);
            #if cpp
            } else {
                onComplete(bitmapData);
            }
            #end
        }
    }

    #if cpp
    private static inline function saveCache(name: String, assetName: String, path: String, svgData: String, bitmapData: BitmapData): Void {
        var ba: ByteArray = bitmapData.getPixels(new Rectangle(0,0,bitmapData.width, bitmapData.height));
        ba.position = 0;
        var bytes: Bytes = Bytes.alloc(ba.length);
        for(i in 0...ba.length) {
            bytes.set(i, ba.readByte());
        }
        FileUtil.saveBytes(path, bytes);
        var imageManifest: Dynamic = Reflect.field(getCurrentManifest(), name);
        if(imageManifest == null) {
            imageManifest = {};
            Reflect.setField(getCurrentManifest(), name, imageManifest);
        }
        var imagePaths: Array<String> = imageManifest.images;
        if(imagePaths == null) {
            imagePaths = [];
        }
        if(!pathExists(imagePaths, path)) {
            imagePaths.push(path);
        }
        var authCacheId: String = Reflect.field(getAuthorityManifest(), name);
        if(StringUtil.isBlank(authCacheId)) {
            authCacheId = Md5.encode(svgData);
        }
        imageManifest.images = imagePaths;
        imageManifest.cacheId = authCacheId;

        var manifestPath: String = FileUtil.getStoragePath() + LOCAL_MANIFEST_FILE;
        FileUtil.saveString(manifestPath, (Json.stringify(getCurrentManifest())));
    }

    private static inline function pathExists(imagePaths: Array<String>, path: String): Bool {
        var found: Bool = false;
        for(imagePath in imagePaths) {
            if(imagePath == path) {
                found = true;
                break;
            }
        }
        return found;
    }

    private static function getDiskCachedImage(name: String, assetName: String, path: String, width: Int, height: Int): BitmapData {
        if(FileSystem.exists(path + assetName)) {
            var authCacheId: String = Reflect.field(getAuthorityManifest(), name);
            var imageManifest: Dynamic = Reflect.field(getCurrentManifest(), name);
            if(imageManifest == null) {
                Reflect.setField(getCurrentManifest(), name, {});
                return null;
            }
            if(StringUtil.isBlank(authCacheId)) {
                authCacheId = imageManifest.cacheId;
            }
            if(authCacheId != imageManifest.cacheId) {
                trace("the cache is different for " + assetName + ", deleting old files.");
                trace(authCacheId, imageManifest.cacheId);
                var images: Array<String> = imageManifest.images;
                for(imageName in images) {
                    if(FileSystem.exists(imageName)) {
                        FileSystem.deleteFile(imageName);
                    }
                }
                return null;
            }
            var stat: FileStat = FileSystem.stat(path + assetName);
            var bytes: Bytes = FileUtil.readFileBytes(path + assetName);
            var ba: ByteArray = ByteArray.fromBytes(bytes);
            ba.position = 0;
            var bitmapData: BitmapData = new BitmapData(width, height, true, 0);
            try {
                bitmapData.setPixels(new Rectangle(0,0,width, height), ba);
                return bitmapData;
            } catch(e: Dynamic) {
                trace(e);
                return null;
            }
        }
        return null;
    }

    private static inline function getAuthorityManifest(): Dynamic {
        if(authorityManifest == null) {
            authorityManifest = ImageManifest.getManifestAuthority();
        }
        return authorityManifest;
    }

    private static inline function getCurrentManifest(): Dynamic {
        if(currentManifest == null) {
            currentManifest = {};
            var path = FileUtil.getStoragePath() + LOCAL_MANIFEST_FILE;
            if(FileSystem.exists(path)) {
                var content: String = FileUtil.readFile(path);
                currentManifest = Json.parse(content);
            }
        }
        return currentManifest;
    }

    public static inline function deleteUnusedCache(): Void {
        var itemsToDelete: Array<Dynamic> = [];
        var currentManifest: Dynamic = getCurrentManifest();
        var authorityManifest: Dynamic = getAuthorityManifest();
        var items: Array<String> = Reflect.fields(currentManifest);
        for(item in items) {
            item = regx.replace(item, "_");
            var authItem: Dynamic = Reflect.field(authorityManifest, item);
            if(authItem == null) {
                trace(item);
                itemsToDelete.push(Reflect.field(currentManifest, item));
            }
        }
        trace("number of images to delete : " + itemsToDelete.length);
        for(itemToDelete in itemsToDelete) {
            if(itemToDelete != null) {
                var images: Array<String> = itemToDelete.images;
                if(images != null) {
                    for(imageName in images) {
                        if(FileSystem.exists(imageName)) {
                            trace("deleting image : " + imageName);
                            try {
                                FileSystem.deleteFile(imageName);
                            } catch(e: Dynamic) {
                                trace(e);
                            }
                        }
                    }
                }
            }
        }
    }
    #end

    public static inline function disposeBitmapByName(name: String, width: Float, height: Float): Void {

    }

    public static inline function rasterizeDisplay(name: String, displayObjectContainer: DisplayObjectContainer): Void {
        var bitmapData: BitmapData;
        if(imageMap.exists(name)) {
            var imageCount: ImageCount = imageMap.get(name);
            imageCount.count++;
            bitmapData = imageCount.bitmapData;
        } else {
            bitmapData = new BitmapData(Std.int(displayObjectContainer.width), Std.int(displayObjectContainer.height), true, 0);
            bitmapData.draw(displayObjectContainer, null, null, null, null, true);
        }

        while(displayObjectContainer.numChildren > 0) {
            displayObjectContainer.removeChildAt(0);
        }
        var bitmap: Bitmap = new Bitmap(bitmapData);
        displayObjectContainer.addChild(bitmap);
        imageMap.set(name, {count: 1, bitmapData: bitmapData});
    }

}

typedef ImageCount = {
    count: Int,
    bitmapData: BitmapData
}

typedef ImageDef = {
    cacheId: String,
    imagePath: String,
}
