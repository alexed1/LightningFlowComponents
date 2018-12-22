global class CreateGoogleDriveFolder {
    
    @InvocableMethod(label='Create Google Drive Folder' description='Creates new folder on Google Drive under the path specified')
    global static List<Response> CreateGoogleDriveFolder(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IGoogleDrive googleDrive = new GoogleDrive(new GoogleAPI());
        for (Request request : requests) {
            Response response = CreateGoogleDriveFolder.CreateGoogleDriveFolderImpl(googleDrive, request);
            responses.add(response); 
        }
        return responses; 
    }

    public static Response CreateGoogleDriveFolderImpl(IGoogleDrive googleDrive, Request request) {
        Response response = new Response();
        try {
            File folder = googleDrive.getFolder(request.FolderPath, true);
            response.WebviewURL = folder.webViewLink;
        } 
        catch (GoogleException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }
        return response; 
    }

    global class Request {

        @InvocableVariable(required=True label='Folder Name' description='A name of the folder or a path to the folder')
        global String FolderPath; 
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

        @InvocableVariable(label='Webview URL' description='URL to view the newly created folder in the browser')
        global String WebviewURL;
    }
}