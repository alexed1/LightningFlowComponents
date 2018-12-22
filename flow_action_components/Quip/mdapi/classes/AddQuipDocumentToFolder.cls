global class AddQuipDocumentToFolder {
    
    @InvocableMethod(label='Add Quip Document to Folder' description='Adds Quip document to the folder with specific name')
    global static List<Response> AddQuipDocumentToFolder(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IQuip quip = new Quip(new QuipAPI());
        for (Request request : requests) {
            Response response = AddQuipDocumentToFolder.AddQuipDocumentToFolderImpl(quip, request);
            responses.add(response); 
        }
        return responses;
    }

    public static Response AddQuipDocumentToFolderImpl(IQuip quip, Request request) {
        Response response = new Response();
        try {
            quip.addDocumentToFolder(request.FileName, request.FolderPath);
        } 
        catch (QuipException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }
        return response;
    }

    global class Request {

        @InvocableVariable(required=True label='File Name' description='Case-sensitive')
        global String FileName;

        @InvocableVariable(required=True label='Folder Path' description='A name of the folder or a path to the folder')
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
    }
}