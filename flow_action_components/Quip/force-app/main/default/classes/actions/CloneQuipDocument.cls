global class CloneQuipDocument {
    
    @InvocableMethod(label='Clone Quip Document' description='Clones Quip document with specific name and returns Id and URL of the copy')
    global static List<Response> CloneQuipDocument(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IQuip quip = new Quip(new QuipAPI());
        for (Request request : requests) {
            Response response = CloneQuipDocument.CloneQuipDocumentImpl(quip, request);
            responses.add(response);
        }
        //Introduce artificial delay to workaround Quip API issues
        Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
        Integer delayInMilliseconds = 1 * 1000; //Several seconds delay
        while (System.now().getTime() - startingTime < delayInMilliseconds)  {
            // Do nothing until desired delay has passed
        }
        return responses;
    }

    public static Response CloneQuipDocumentImpl(IQuip quip, Request request) {
        Response response = new Response();
        try {
            Thread copy = quip.cloneThread(request.FileName, request.NameOfCopy);
            response.FileId = copy.id;
            response.FileURL = copy.link;
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