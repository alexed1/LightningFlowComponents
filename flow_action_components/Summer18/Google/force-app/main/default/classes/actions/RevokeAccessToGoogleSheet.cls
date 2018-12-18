global class RevokeAccessToGoogleSheet {
    
    @InvocableMethod(label='Revoke Access to Google Sheet' description='Revokes specific users access to a specific sheet')
    global static List<Response> RevokeAccessToGoogleSheet(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IGoogleDrive googleDrive = new GoogleDrive(new GoogleAPI());
        for (Request request : requests) {
            Response response = RevokeAccessToGoogleSheet.RevokeAccessToGoogleSheetImpl(googleDrive, request);
            responses.add(response);
        }
        return responses;
    }

    public static Response RevokeAccessToGoogleSheetImpl(IGoogleDrive googleDrive, Request request) {
        Response response = new Response();
        try {
            List<String> allUsers = new List<String>();
            List<String> users = new List<String> {
                request.User1,
                request.User2,
                request.User3,
                request.User4,
                request.User5
            };
            for (String userList : users) {
                if (String.isBlank(userList)) {
                    continue;
                }
                List<String> currentUsers = userList.split(',');
                for (String currentUser : currentUsers) {
                    if (String.isBlank(currentUser)) {
                        continue;
                    }
                    allUsers.add(currentUser.trim());
                }
            }
            googleDrive.revokeAccess(request.FilePath, allUsers);
        } 
        catch (GoogleException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }
        return response;
    }

    global class Request {

        @InvocableVariable(required=True label='File Name' description='A name of the file or a path to the file')
        global String FilePath;

        @InvocableVariable(required=True label='Users #1' description='A user Id or email or comma-separated list of user Ids or emails')
        global String User1;

        @InvocableVariable(label='Users #2' description='A user Id or email or comma-separated list of user Ids or emails')
        global String User2;

        @InvocableVariable(label='Users #3' description='A user Id or email or comma-separated list of user Ids or emails')
        global String User3;

        @InvocableVariable(label='Users #4' description='A user Id or email or comma-separated list of user Ids or emails')
        global String User4;

        @InvocableVariable(label='Users #5' description='A user Id or email or comma-separated list of user Ids or emails')
        global String User5;
    }

    global class Response {

        global Response() {
            IsSuccess = true;
            ErrorMessage = '';
        }

        @InvocableVariable(label='Is Success' description='"True" if action was successful, otherwise "False"')
        global Boolean IsSuccess;

        @InvocableVariable(label='Error Message' description='Contains the description of error if action was not successfull"')
        global String ErrorMessage;
    }
}