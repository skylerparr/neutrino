package mecha.data.linq;
interface AdditionalWhereCriteria extends AdditionalCriteria {
    function and(field: String, value: Dynamic, ?comparator: Comparator = Comparator.EQUAL): AdditionalWhereCriteria;
    function or(field: String, value: Dynamic, ?comparator: Comparator = Comparator.EQUAL): AdditionalWhereCriteria;
}
