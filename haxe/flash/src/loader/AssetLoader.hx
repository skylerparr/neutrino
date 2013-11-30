package loader;
import flash.display.BitmapData;
interface AssetLoader {
    function loadImage(imageName: String, onComplete: BitmapData->Void, onFail: String->Void = null): Void;
    function loadText(name: String, onComplete: String->Void, onFail: String->Void = null): Void;
}
