global class CloneGoogleFile {
    
    @InvocableMethod(label='Clone Google File' description='Clones Google file with specific name or Id and returns an Id of the clone and URL to view it')
    global static List<Response> CloneGoogleFile(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IGoogleDrive drive = new GoogleDrive(new GoogleAPI());
        for (Request request : requests) {
            Response response = CloneGoogleFile.CloneGoogleFileImpl(drive, request);
            responses.add(response);
        }
        return responses;
    }

    public static Response CloneGoogleFileImpl(IGoogleDrive drive, Request request) {
        Response result = new Response();
        if (String.isBlank(request.FileIdOrName)) {
            result.IsSuccess = false;
            result.ErrorMessage = '"File Id" or "File Name" can\'t be empty';
            return result;
        }
        if (String.isBlank(request.NameOfCopy)) {
            result.IsSuccess = false;
            result.ErrorMessage = '"Copy Name" can\'t be empty';
            return result;
        }
        try {
            ClonedFile file = drive.CloneFile(request.FileIdOrName, request.NameOfCopy);
            result.FileId = file.id;
            result.FileUrl = file.url;
        } 
        catch (GoogleException ex) {
            result.IsSuccess = false;
            result.ErrorMessage = ex.getMessage();
        }
        return result;
    }    

    global class Request {

        @InvocableVariable(required=True label='File Id/File Name' description='Id or name of the Google file to clone')
        global String FileIdOrName;

        @InvocableVariable(required=True label='Copy Name' description='The name to assign to the newly created copy')
        global String NameOfCopy;
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
        
        @InvocableVariable(label='Id of the Copy')
        global String FileId;
        
        @InvocableVariable(label='URL of the Copy')
        global String FileURL;
    }
}
