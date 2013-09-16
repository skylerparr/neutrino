package mecha.data.linq;
interface Joiner {
    function innerJoin(model: String, fieldA: String, fieldB: String): AdditionalCriteria;
}
