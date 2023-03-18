/**
 * Eric Smith - August 2020
 * 
 *      Flow Action to create a ContentVersion Record (File) based on input attributes
 * 
 *      Input:      fileName        Name of file to create (Include extension or default to .txt)
 *                  fileContent     String containing the file's content
 * 
 *      Output:     documentId      ContentDocumentId of the newly created file
 * 
 */

 public with sharing class CreateFile {

    @invocableMethod (label='Create a File (ContentVersion Record)' description='Generates and uploads a Salesforce File given a file name and the file contents')
    public static List<Result> createCVR(List<Request> requests) {
        List<Result> responseWrapper = new List<Result>();

        for (Request curRequest : requests) {
            Result curResult = new Result();

            String fileName = curRequest.fileName;
            Integer lastDot = fileName.lastIndexOf('.');
            if (lastDot == -1) {
                lastDot = fileName.length();
                filename += '.txt';
            }
            String fileTitle = fileName.substring(0,lastDot);

            curResult.documentId = generateDocument(fileTitle, fileName, curRequest.fileContent);

            responseWrapper.add(curResult);
        }

        return responseWrapper;

    }

    public static String generateDocument(String documentTitle, String documentPath, String documentContent) {
        ContentVersion cv = new ContentVersion();

        // Special Processing to unescape {} characters passed by the Import/Export Flows flow
        documentContent = documentContent.replace('&lbrace;', '{');
        documentContent = documentContent.replace('&rbrace;', '}');
                
        cv.VersionData = Blob.valueOf(documentContent);
        cv.Title = documentTitle;
        cv.PathOnClient = documentPath;
        cv.IsMajorVersion = false;
        insert cv;

        // Is new document
        List<ContentDocument> cd = [Select Id from ContentDocument WHERE LatestPublishedVersionId =: cv.Id LIMIT 1];
        if (cd.size() == 0) {
            throw new InvocableActionException('Document generation failed!');
        } else {
            return cd[0].Id;
        }

    }

    public class Request {
       
        @InvocableVariable (label='Name of file to create' required=true description='Include the file extension (default .txt)')
        public String fileName;

        @InvocableVariable (label='String containing the file content' required=true)
        public String fileContent;
      
    }

    public class Result {

        @InvocableVariable (label='ContentDocumentId of the newly created file')
        public String documentId;

    }

    public class InvocableActionException extends Exception{}
}