global class RenameQuipFolder {
    
    @InvocableMethod(label='Rename Quip Folder' description='Renames Quips folder located under the path specified')
    global static List<Response> RenameQuipFolder(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IQuip quip = new Quip(new QuipAPI());
        for (Request request : requests) {
            Response response = RenameQuipFolder.RenameQuipFolderImpl(quip, request);
            responses.add(response); 
        }
        return responses;
    }

    public static Response RenameQuipFolderImpl(IQuip quip, Request request) {
        Response response = new Response();
        try {
            Folder folder = quip.getFolderByPath(request.FolderPath, false);
            if (folder == null) {
                folder = quip.findFolder(request.FolderPath);
            }
            if (folder == null) {
                response.IsSuccess = false;
                response.ErrorMessage = 'Specified folder doesn\'t exist';
            }
            quip.renameFolder(folder, request.NewFolderName);
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

        @InvocableVariable(required=True label='New Name')
        global String NewFolderName;
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