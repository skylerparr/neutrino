package assets.loader;
import flash.system.ApplicationDomain;
class AbstractLoader {
    public function new() {
    }

    public function initiateLoad(success: AbstractLoader->Void, failFunction: AbstractLoader->Void): Void {
        start(success, failFunction);
    }

    public function start(success: AbstractLoader->Void, failFunction: AbstractLoader->Void): Void {
        throw("start must be overridden");
    }

    public function pause(): Void {

    }

    public function resume(): Void {

    }

    public function stop(): Void {

    }

    public function getProgress(): Float {
        return 0;
    }

    public function getContent(): Dynamic {
        return null;
    }

    public function initiateUnload(): Void {
        unload();
    }

    public function getUrl(): String {
        throw("getUrl must be overridden");
    }

    public function unload(): Void {
        throw("unload must be overridden");
    }

    public function getApplicationDomain(): ApplicationDomain {
        throw("getApplicationDomain must be overridden");
    }
}
