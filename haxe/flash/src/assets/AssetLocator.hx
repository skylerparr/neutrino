package assets;
interface AssetLocator {
    /**
     * gets an asset by name, onComplete is called when the bitmap data is ready
     */
    function getAssetByName(name: String, onComplete: BitmapData->Void): Void;

    /**
     * loads the asset and returns bitmap, the bitmap data will be assigned when the asset is ready.
     * onComplete will be called when the asset is assigned.
     */
    function getLazyAsset(name: String, onComplete: BitmapData->Void = null): Bitmap;

    /**
     * disposes of the asset by name.
     */
    function disposeAsset(name: String): Void;
}
