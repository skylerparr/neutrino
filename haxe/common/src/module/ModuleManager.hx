package module;
interface ModuleManager {
    function switchModule(module: Class<Module>, switchComplete: Void->Void): Void;
}
