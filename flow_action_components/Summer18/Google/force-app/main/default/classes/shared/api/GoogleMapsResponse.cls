public virtual class GoogleMapsResponse {

    public String status;

    public String error_message;

    public Boolean isOk() {
        return String.isBlank(status) || status == 'OK';
    }

    public void throwOnError() {
        if (!isOk()) {
            throw new GoogleException(error_message);
        }
    }
}
