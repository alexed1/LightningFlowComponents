public with sharing class GetPermissionSet {
    
    @InvocableMethod
    public static List<Results> get (List<Request> requestList) {
        System.debug('entering GetPermissionSet');
        List<Results> responseWrapper = new List<Results>();
        for (Request curRequest : requestList) {
            fbc_MetadataService.MetadataPort service = fbc_MetadataService.createService();
            fbc_MetadataService.PermissionSet ps =
                (fbc_MetadataService.PermissionSet) service.readMetadata('PermissionSet',
				    new String[] { curRequest.permSetName }).getRecords()[0];
            
            //Create a Results object to hold the return values
            Results response = new Results();
            response.permissionSet = (PermissionSet)ps;
            responseWrapper.add(response);
        }     
     
        return responseWrapper;
    
    }

    public class Request {

      @InvocableVariable
      public String permSetName;

        
    }
    
    public class Results {

        @InvocableVariable
        public PermissionSet permissionSet;


    }

    public class InvocableActionException extends Exception {}
}

