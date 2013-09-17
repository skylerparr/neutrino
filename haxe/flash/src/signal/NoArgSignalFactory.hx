package signal;
import msignal.Signal.Signal0;
class NoArgSignalFactory implements SignalFactory {

    public var signalMap: Map<String, Signal0>;

    public function new() {
        signalMap = new Map<String, Signal0>();
    }

    public function getSignal(name:String):Signal0 {
        var retVal: Signal0 = signalMap.get(name);
        if(retVal == null) {
            retVal = new Signal0();
            signalMap.set(name, retVal);
        }
        return retVal;
    }
}
