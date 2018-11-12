global virtual class ActionResponse {

    global ActionResponse() {
        IsSuccess = true;
        ErrorMessage = '';
    }

    @InvocableVariable(label='Is Success' description='"True" if action was successful, otherwise "False"')
    global Boolean IsSuccess;

    @InvocableVariable(label='Error Message' description='Contains the description of error if action was not successfull"')
    global String ErrorMessage;
}
