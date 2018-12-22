global class CreateQuipSheet {
    
    @InvocableMethod(label='Create Quip Sheet' description='Creates new Quip sheet at user\'s private folder or at specified subfolder')
    global static List<Response> CreateQuipSheet(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IQuip quip = new Quip(new QuipAPI());
        for (Request request : requests) {
            Response response = CreateQuipSheet.CreateQuipSheetImpl(quip, request);
            responses.add(response);
        }
        return responses;
    }

    private static final Integer A_CHAR_CODE = 'a'.charAt(0);

    public static Response CreateQuipSheetImpl(IQuip quip, Request request) {
        Response response = new Response();
        try {
            Folder folder = quip.getFolderByPath(request.Path, true);
            //Generate a content of a new spreadsheet
            String html = '<table title="Sheet1"><thead>';
            for (Integer col = 0; col < 16; col++) {
                html += '<th>' + String.fromCharArray(new List<Integer> { col + A_CHAR_CODE }).toUpperCase() + '</th>';
            }
            html += '</thead><tbody>';
            for (Integer row = 0; row < 31; row++) {
                html += '<tr>';
                for (Integer col = 0; col < 16; col++) {
                    html += '<td></td>';
                }
                html += '</tr>';
            }
            html += '</tbody></table>';
            Thread newSpreadsheet = quip.createThread(request.FileName, html, 'spreadsheet', folder.id);
            response.FileId = newSpreadsheet.id;
            response.FileURL = newSpreadsheet.link;
        } 
        catch (QuipException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }
        return response;
    }

    global class Request {

        @InvocableVariable(required=True label='File Name' description='Name of the new file')
        global String FileName;

        @InvocableVariable(label='Path' description='The sub-folder of user\'s private folder to put new file to')
        global String Path;
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
        
        @InvocableVariable(label='Id of the new file')
        global String FileId;
        
        @InvocableVariable(label='URL of the new file')
        global String FileURL;
    }
}