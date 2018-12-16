global class RenameGoogleDriveFolder {
    
    @InvocableMethod(label='Rename Google Drive Folder' description='Renames existing Google Drive folder located under the path specified')
    global static List<Response> RenameGoogleDriveFolder(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IGoogleDrive googleDrive = new GoogleDrive(new GoogleAPI());
        for (Request request : requests) {
            Response response = RenameGoogleDriveFolder.RenameGoogleDriveFolderImpl(googleDrive, request);
            responses.add(response); 
        }
        return responses; 
    }

    public static Response RenameGoogleDriveFolderImpl(IGoogleDrive googleDrive, Request request) {
        Response response = new Response();
        try {
            File folder = googleDrive.getFolder(request.FolderPath, false);
            if (folder == null) {
                response.IsSuccess = false;
                response.ErrorMessage = 'Google Drive folder with the name "' + request.FolderPath + '" doesn\'t exist';
            } else {
                googleDrive.renameFile(folder, request.NewName);
                response.WebviewURL = folder.webViewLink;
            }
            
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

        @InvocableVariable(required=True label='New Name' description='A new name that will be given to the folder')
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

        @InvocableVariable(label='Webview URL' description='URL to view the renamed folder in the browser')
        global String WebviewURL;
    }
}