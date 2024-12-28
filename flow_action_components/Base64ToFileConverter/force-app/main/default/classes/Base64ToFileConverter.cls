/**
 * @description       : 
 * @author            : Josh Dayment
 * @group             : 
 * @last modified on  : 09-03-2024
 * @last modified by  : Josh Dayment
**/
global with sharing class Base64ToFileConverter {

    @InvocableMethod(label='Convert Base64 to File and Attach' iconName='slds:standard:attach')
    global static List<Response> convertAndAttach(List<Request> requests) {
        
        List<Response> responses = new List<Response>(); 

        for(Request req : requests) {
            // Decode the Base64 string
            Blob fileBody = EncodingUtil.base64Decode(req.base64Text.substringAfter(','));
            

            // Prepare the ContentVersion (File) record
            ContentVersion cv = new ContentVersion();
            cv.VersionData = fileBody;
            cv.Title = req.fileName; 
            cv.PathOnClient = req.fileName; 
            cv.FirstPublishLocationId = req.recordId;
            
            // Check if user can create and insert Content Version Records.
            if (Schema.sObjectType.ContentVersion.isCreateable() && Schema.sObjectType.ContentVersion.isUpdateable()) {
                insert cv;
            }

            // Create a Response object and add it to the list
            Response res = new Response();
            res.contentVersionId = cv.Id;
            responses.add(res);

            // Optionally, create a ContentDocumentLink if needed for explicit linking in some scenarios
            // ContentDocumentLink cdl = new ContentDocumentLink();
            // cdl.LinkedEntityId = req.recordId;
            // cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
            // cdl.ShareType = 'V'; // Adjust as per your sharing requirements
            // insert cdl;
        }

        return responses;
    }
  
    // Invocable Method Variables   

    global class Request {
        @InvocableVariable(label='Base64 Encoded File Content')
        global String base64Text;

        @InvocableVariable(label='Related Record ID')
        global Id recordId;

        @InvocableVariable(label='File Name' description='Enter the full file name, including extension (e.g. myFile.jpg)' placeholderText='myFile.jpg' required=true)
        global String fileName; 
    }

// Invocable Method Variables

    global class Response {
        @InvocableVariable(label='Content Version ID')
        global String contentVersionId;
    }
}