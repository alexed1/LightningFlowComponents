global class CreateGoogleSheet {
    
    @InvocableMethod(label='Create Google Sheet' description='Creates new Google Sheet file under the path specified')
    global static List<Response> CreateGoogleSheet(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IGoogleDrive googleDrive = new GoogleDrive(new GoogleAPI());
        for (Request request : requests) {
            Response response = CreateGoogleSheet.CreateGoogleSheetImpl(googleDrive, request);
            responses.add(response); 
        }
        return responses; 
    }

    public static Response CreateGoogleSheetImpl(IGoogleDrive googleDrive, Request request) {
        Response response = new Response();
        try {
            File file = googleDrive.createSpreadsheet(request.FilePath);
            response.WebviewURL = file.webViewLink;
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

        @InvocableVariable(label='Webview URL' description='URL to view the newly created file in the browser')
        global String WebviewURL;
    }
}