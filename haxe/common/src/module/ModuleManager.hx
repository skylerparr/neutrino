package module;
interface ModuleManager {
    function switchModule(module: Module, switchComplete: Void->Void): Void;
}
