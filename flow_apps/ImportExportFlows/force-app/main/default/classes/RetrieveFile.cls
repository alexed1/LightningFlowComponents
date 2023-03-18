/**
 * Eric Smith - August 2020
 * 
 *      Flow Action to retrieve the contents of a ContentVersion Record (File) based on a ContentDocumentId
 * 
 *      Input:      documentId      ContentDocumentId of the file to retrieve
 * 
 *      Output:     fileName        Name of the retrieved file
 *                  fileContent     String containing the file's content
 * 
 *      Thanks to Narender Singh's ConvertCSVToRecords (https://unofficialsf.com/narender-singh-brings-csv-imports-to-flow/)
 * 
 */

 public with sharing class RetrieveFile {

    @invocableMethod (label='Retrieve a File (ContentVersion Record)' description='Extracts the contents from a Salesforce File given the ContentDocumentId')
    public static List<Result> retrieveCVR(List<Request> requests) {
        List<Result> responseWrapper = new List<Result>();

        for (Request curRequest : requests) {
            Result curResult = new Result();

            String docId = curRequest.documentId;

            String fileName = getFileName(docId);
            Blob docBlobContent = getContent(docId);
            String docStringContent = blobToString(docBlobContent, 'ISO-8859-1');

            // Escape {} characters so the String can be processed in a Flow
            docStringContent = docStringContent.replace('{', '&lbrace;');
            docStringContent = docStringContent.replace('}', '&rbrace;');

            curResult.fileName = fileName;
            curResult.fileContent = docStringContent;

            responseWrapper.add(curResult);
        }

        return responseWrapper;

    }

    public static String getFileName(String documentId) {
        ContentVersion cvr = 
            [SELECT 
                Title, FileExtension
                FROM ContentVersion
                WHERE ContentDocumentId = :documentId
                    AND IsLatest = true 
            ];
        return cvr.Title + '.' + cvr.FileExtension;
    }

    public static Blob getContent(String documentId) {
        ContentVersion cvr = 
            [SELECT 
                VersionData
                FROM ContentVersion
                WHERE ContentDocumentId = :documentId
                    AND IsLatest = true 
            ];
        return cvr.VersionData;
    }

    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    } 

    public class Request {

        @InvocableVariable (label='ContentDocumentId of the file to be retrieved' required=true)
        public String documentId;

    }

    public class Result {
       
        @InvocableVariable (label='Name of the retireved file')
        public String fileName;

        @InvocableVariable (label='String containing the file content')
        public String fileContent;
      
    }

    public class InvocableActionException extends Exception{}
}