package auth;
interface ApplicationAuthentication {
    /**
     * attempts to get the authentication token for this device.
     * if the retrieval is a success the success callback is called with the authentication token
     * if the it was a failure, the message id on why the authentication failed
     * Reasons on why the retrieval was a failure could be
     *  - user does not exists and you need to create a new token
     *  - connection timed out
     *  - unknown server error
     */
    function getAuthenticationToken(success: String->Void, fail: Int->Void): Void;

    /**
     * Creates a new authentication token for the device, this should only be invoked if the
     * getAuthenticationToken fails with message that the user does not exist.  Therefore
     * a new user will need to be created.
     * if the it was a failure, the message id on why the authentication failed
     * Reasons on why the retrieval was a failure could be
     *  - connection timed out
     *  - unknown server error
     */
    function createAuthenticationToken(success: String->Void, fail: Int->Void): Void;
}
