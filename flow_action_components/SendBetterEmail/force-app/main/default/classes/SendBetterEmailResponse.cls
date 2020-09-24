public inherited sharing class SendBetterEmailResponse {
    @invocableVariable
    public Boolean isSuccess;

    @invocableVariable
    public String templateUsed;

    @invocableVariable
    public List<String> taskIds;

    @invocableVariable
    public String errors;

    @invocableVariable
    public List<String> taskErrors;

    public Integer index; // variable that assigns internal Id

    public SendBetterEmailResponse() {
        taskIds = new List<String>();
        taskErrors = new List<String>();
    }
}
