public virtual class Response {

    public String error;
    public Integer error_code;
    public String error_description;

    public void throwOnError() {
        if (error_code != 0) {
            throw new QuipException(String.isBlank(error_description) ? error : error_description);
        }
    }
}
