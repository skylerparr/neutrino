package com.thoughtorigin.vo;
interface BindableValueObject {
    /**
     * invokes the update function whenever the property is updated
     */
    function bindProperty(propertyName: String, updateFunction: Void->Void): Void;
    /**
     * removes binding on the particular property
     */
    function unbindProperty(propertyName: String, updateFunction: Void->Void): Void;

    /**
     * Unbind all property bindings from this object
     */
    function unbindAll(): Void;
}
