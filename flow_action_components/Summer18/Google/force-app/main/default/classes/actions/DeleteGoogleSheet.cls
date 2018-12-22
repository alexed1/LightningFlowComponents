global class DeleteGoogleSheet {
    
    @InvocableMethod(label='Delete Google Sheet' description='Deletes existing Google Sheet file located under the path specified')
    global static List<Response> DeleteGoogleSheet(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IGoogleDrive googleDrive = new GoogleDrive(new GoogleAPI());
        for (Request request : requests) {
            Response response = DeleteGoogleSheet.DeleteGoogleSheetImpl(googleDrive, request);
            responses.add(response); 
        }
        return responses; 
    }

    public static Response DeleteGoogleSheetImpl(IGoogleDrive googleDrive, Request request) {
        Response response = new Response();
        try {
            File file = googleDrive.getFile(request.FilePath, FileMimeTypes.GOOGLE_SHEET);
            if (file == null) {
                response.IsSuccess = false;
                response.ErrorMessage = 'Google Sheet with the name "' + request.FilePath + '" doesn\'t exist';
            } else {
                googleDrive.deleteFile(file);
            }
            
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