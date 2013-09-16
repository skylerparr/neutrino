package com.thoughtorigin.mecha.data.linq;
interface Operator extends AdditionalCriteria {
    function join(model: String): Joiner;
    function where(field: String, value: Dynamic, ?comparator: Comparator = Comparator.EQUAL): AdditionalWhereCriteria;
    function count(): Result;
    function first(): Result;
    function limit(count: Int): Result;
}
