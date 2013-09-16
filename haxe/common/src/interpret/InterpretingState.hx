package com.thoughtorigin.interpret;
enum InterpretingState {
    NONE;
    DEFINING_PACKAGE;
    PACKAGE_DEFINED;
    DEFINING_IMPORT;
    CLASS_DECLARED;
    DEFINING_CLASS;
}
