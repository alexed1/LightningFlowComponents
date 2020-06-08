public with sharing class ExtractMetadataFromZipfile {

    @invocableMethod
    public static List<Result> extract(List<Request> requests) {
        List<Result> responseWrapper = new List<Result>();

        for (Request curRequest : requests) {
            Result curResult = new Result();
            curResult.convertedFlowMetadata = unpackZipfile(curRequest.flowMetadataZipFile);
            responseWrapper.add(curResult);
        }

        return responseWrapper;

    }

    public static String unpackZipfile(String metadataZipfile) {

             
        Blob zipBlob = EncodingUtil.base64Decode(metadataZipfile);
        Zippex curZippex = new Zippex(zipBlob);
        Set<String> fileNames = curZippex.getFileNames();
        System.debug('filenames are: ' + fileNames);
     
        List<String> filenamesList = new List<String>(fileNames);

           //currently only set up to handle a single file
        Blob fileData = curZippex.getFile(filenamesList[0]);
        System.debug ('filename: ' + filenamesList[0]);
        return  fileData.toString();
    }

    public class Request {
       

        @InvocableVariable 
        public String flowMetadataZipFile;
      

    }

    public class Result {

        @InvocableVariable
        public String errors;

       
        @InvocableVariable
        public String convertedFlowMetadata;

    }

    public class InvocableActionException extends Exception{}
}
