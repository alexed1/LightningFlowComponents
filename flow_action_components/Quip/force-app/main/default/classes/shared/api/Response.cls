public virtual class Response {

    public String error;
    public Integer error_code;
    public String error_description;

    public Boolean isSuccess() {
        return error_code == null;
    }

    public void throwOnError() {
        if (!isSuccess()) {
            throw new QuipException(String.isBlank(error_description) ? error : error_description);
        }
    }
}
