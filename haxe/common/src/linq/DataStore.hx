package mecha.data.linq;
import mecha.model.PersistedValueObject;
interface DataStore {
    function from(model: String): QueryType;
}
