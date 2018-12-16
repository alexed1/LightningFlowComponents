global class RenameGoogleSheet {
    
    @InvocableMethod(label='Rename Google Sheet' description='Renames existing Google Sheet located under the path specified')
    global static List<Response> RenameGoogleSheet(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IGoogleDrive googleDrive = new GoogleDrive(new GoogleAPI());
        for (Request request : requests) {
            Response response = RenameGoogleSheet.RenameGoogleSheetImpl(googleDrive, request);
            responses.add(response); 
        }
        return responses; 
    }

    public static Response RenameGoogleSheetImpl(IGoogleDrive googleDrive, Request request) {
        Response response = new Response();
        try {
            File file = googleDrive.getFile(request.FilePath, FileMimeTypes.GOOGLE_SHEET);
            if (file == null) {
                response.IsSuccess = false;
                response.ErrorMessage = 'Google sheet with the name "' + request.FilePath + '" doesn\'t exist';
            } else {
                googleDrive.renameFile(file, request.NewName);
                response.WebviewURL = file.webViewLink;
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

        @InvocableVariable(required=True label='New Name' description='A new name that will be given to the file')
        global String NewName;
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

        @InvocableVariable(label='Webview URL' description='URL to view the renamed file in the browser')
        global String WebviewURL;
    }
}