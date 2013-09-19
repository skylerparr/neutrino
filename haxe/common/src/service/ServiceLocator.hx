package service;
interface ServiceLocator {
    function getServiceByName(name: String): Service;
}
