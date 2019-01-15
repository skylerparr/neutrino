package assets;
import util.StringUtil;
import flash.utils.ByteArray;
import flash.display.BitmapData;
import loader.AssetLoader;
import openfl.Assets;
class EmbeddedAndLoadingAssetLoader extends BasicAssetLoader {

    public var embeddedClassPackage: String;

    public function new() {
        super();
    }

    override public function loadImage(imageName:String, onComplete:BitmapData -> Void, onFail:String -> Void = null):Void {
        var cls: Class<Dynamic> = Type.resolveClass(embeddedClassPackage + "." + imageName);
        if(cls != null) {
            var bitmapData: BitmapData = Type.createInstance(cls, [0,0]);
            onComplete(bitmapData);
            return;
        } else {
            var bitmapData: BitmapData = Assets.getBitmapData(imageName);
            if(bitmapData != null) {
                onComplete(bitmapData);
                return;
            }
        }
        super.loadImage(imageName, onComplete, onFail);
    }

    override public function loadText(name:String, onComplete:String -> Void, onFail:String -> Void = null):Void {
        var cls: Class<Dynamic> = Type.resolveClass(embeddedClassPackage + "." + name);
        if(cls != null) {
            var bytes: ByteArray = Type.createInstance(cls, []);
            onComplete(bytes.readUTFBytes(bytes.length));
            return;
        } else {
            try {
                var textData: String = Assets.getText('assets/${name}');
                if(!StringUtil.isBlank(textData)) {
                    onComplete(textData);
                    return;
                }
            } catch(e: Dynamic) {
            }
        }
        super.loadText(name, onComplete, onFail);
    }
}
