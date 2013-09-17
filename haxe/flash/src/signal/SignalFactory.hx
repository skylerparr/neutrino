package signal;
import msignal.Signal;
interface SignalFactory {
    function getSignal(name: String): Signal0;
}
