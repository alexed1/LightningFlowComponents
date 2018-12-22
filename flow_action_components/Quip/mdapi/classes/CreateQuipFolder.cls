global class CreateQuipFolder {
    
    @InvocableMethod(label='Create Quip Folder' description='Creates new Quip folder under the path specified')
    global static List<Response> CreateQuipFolder(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IQuip quip = new Quip(new QuipAPI());
        for (Request request : requests) {
            Response response = CreateQuipFolder.CreateQuipFolderImpl(quip, request);
            responses.add(response); 
        }
        return responses;
    }

    public static Response CreateQuipFolderImpl(IQuip quip, Request request) {
        Response response = new Response();
        try {
            quip.getFolderByPath(request.FolderPath, true);
        } 
        catch (QuipException ex) {
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
    }
}