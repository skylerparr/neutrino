package interpret;
enum InterpretingSubState {
    NONE;
    WAITING_NEXT_DEFINITION;
    DEFINING_PUBLIC;
    DEFINING_PRIVATE;
    DEFINING_VAR;
}
