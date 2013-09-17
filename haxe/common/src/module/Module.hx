package module;
interface Module {
    function boot(onComplete: Void->Void): Void;
    function shutdown(onComplete: Void->Void): Void;
}
