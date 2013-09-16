package com.thoughtorigin.mecha.data.linq;
interface AdditionalCriteria {
    function groupBy(field: String): AdditionalCriteria;
    function orderBy(field: String, ?order: OrderType = OrderType.ASC): AdditionalCriteria;
}
