package navigation;
interface ModalManager {
    function openModal(name: String, ?dialogData: Dynamic = null): Void;
    function appendModal(name: String, ?dialogData: Dynamic = null): Void;
    function closeModal(name: String): Void;
    function closeAllModals(): Void;
    function openContextualMenu(name: String, ?dialogData: Dynamic = null): Void;
    function closeContextualMenu(): Void;
}
