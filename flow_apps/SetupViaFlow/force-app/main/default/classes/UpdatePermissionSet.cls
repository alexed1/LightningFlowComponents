public with sharing class UpdatePermissionSet{
  
    @InvocableMethod
    public static List<Result> execute (List<Request> requestList) {
        System.debug('entering UpdatePermissionSet');
        List<Result> responseWrapper = new List<Result>();
        for (Request curRequest : requestList) {
            usf3.MetadataService.MetadataPort service = usf3.MetadataService.createService();
            List<usf3.MetadataService.PermissionSet> permSetsToUpdate = new List<usf3.MetadataService.PermissionSet>();
            //process single permSet input
            if (curRequest.singlePermSet != null) {
                flowDMC_PermissionSet permSetToUpdate = curRequest.singlePermSet;
                usf3.MetadataService.PermissionSet metadata_permSetToUpdate = ConvertApexTypeToMetadataService_PermissionSet(permSetToUpdate);
                System.debug ('single perm set to update is: ' + metadata_permSetToUpdate);
                permSetsToUpdate.add(metadata_permSetToUpdate);
            }
               
            
            
            if(curREquest.permSetCollection != null){
                for(flowDMC_PermissionSet curPermissionSet : curRequest.permSetCollection){
                    permSetsToUpdate.add(ConvertApexTypeToMetadataService_PermissionSet(curPermissionSet));
                }
            }
           


            usf3.MetadataService.handleSaveResults(service.updateMetadata(permSetsToUpdate)[0]);

                    
                   
            //Create a Result object to hold the return values
            Result response = new Result();
            response.errors = 'no errors';
            responseWrapper.add(response);
        }     
     
        return responseWrapper;
    
    }

  
    public static usf3.MetadataService.PermissionSet ConvertApexTypeToMetadataService_PermissionSet(flowDMC_permissionSet originalPermSet) {
        usf3.MetadataService.PermissionSet finalPermSet = new  usf3.MetadataService.PermissionSet();
        finalPermSet.recordTypeVisibilities = new List<usf3.MetadataService.PermissionSetRecordTypeVisibility>();
        finalPermSet.fullName = originalPermSet.fullName;
        finalPermSet.label = originalPermSet.label;
        for (flowDMC_PermSetRecordTypeVisibility curRecordTypeVisibility : originalPermSet.recordTypeVisibilities) {
            usf3.MetadataService.PermissionSetRecordTypeVisibility finalRecordTypeVisibility = new usf3.MetadataService.PermissionSetRecordTypeVisibility();
            finalRecordTypeVisibility.recordType = curRecordTypeVisibility.recordType;
            finalRecordTypeVisibility.visible = curRecordTypeVisibility.visible;
            finalPermSet.recordTypeVisibilities.add(finalRecordTypeVisibility);
        }


        return finalPermSet;


    }
    

    public class Request {

        @InvocableVariable
        public flowDMC_PermissionSet singlePermSet;

        @InvocableVariable
        public List<flowDMC_PermissionSet> permSetCollection;

        
    }
    
    public class Result {

        @InvocableVariable
        public String errors; //NYI instead exceptions are thrown


    }

    public class InvocableActionException extends Exception {}

}
