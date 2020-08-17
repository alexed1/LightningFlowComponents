/**
 * Eric Smith - August 2020
 * 
 *      Extract a single metadata file from the Zip file returned by the Retrieve
 *      method of the fbc_TransferMetada LWC
 * 
 *      Input:  Zip File String
 * 
 *      Output: Extracted File String
 *              Escaped File String (Angle brackets replaced by &lt and &gt)
 * 
 */

public with sharing class fbc_ExtractMetadataStringFromZipfile {

    @invocableMethod
    public static List<Result> extract(List<Request> requests) {
        List<Result> responseWrapper = new List<Result>();

        for (Request curRequest : requests) {
            Result curResult = new Result();
            String unescapedString = unpackZipfile(curRequest.flowMetadataZipFile);
            curResult.extractedFlowMetadata = unescapedString;
            curResult.escapedFlowMetadata = escape(unescapedString);
            responseWrapper.add(curResult);
        }

        return responseWrapper;

    }

    public static String unpackZipfile(String metadataZipfile) {
            
        Blob zipBlob = EncodingUtil.base64Decode(metadataZipfile);
        fbc_Zippex curZippex = new fbc_Zippex(zipBlob);
        Set<String> fileNames = curZippex.getFileNames();
        System.debug('filenames are: ' + fileNames);
     
        List<String> filenamesList = new List<String>(fileNames);

        //currently only set up to handle a single file
        Blob fileData = curZippex.getFile(filenamesList[0]);
        System.debug ('filename: ' + filenamesList[0]);

        return fileData.toString();

    }

    public static String escape(String unescapedString) {

        String processedString = unescapedString;
        System.debug ('initial: ' + processedString);
        processedString = processedString.replace('<', '&lt;');
        System.debug ('replace lt: ' + processedString);
        processedString = processedString.replace('>', '&gt;');
        System.debug ('replace gt: ' + processedString);

        return processedString;

    }    

    public class Request {
       
        @InvocableVariable 
        public String flowMetadataZipFile;
      
    }

    public class Result {

        @InvocableVariable
        public String errors;

        @InvocableVariable
        public String extractedFlowMetadata;

        @InvocableVariable
        public String escapedFlowMetadata;

    }

    public class InvocableActionException extends Exception{}

}
