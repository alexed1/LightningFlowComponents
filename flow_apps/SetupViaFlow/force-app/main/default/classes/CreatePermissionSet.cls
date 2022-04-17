public with sharing class CreatePermissionSet {

    @InvocableMethod
    public static List<Result> execute (List<Request> requestList) {
        System.debug('entering CreatePermissionSet');
        List<Result> responseWrapper = new List<Result>();
        for (Request curRequest : requestList) {
            usf3.MetadataService.MetadataPort service = usf3.MetadataService.createService();

            //process single permSet input
            flowDMC_PermissionSet permSetToCreate = curRequest.singlePermSet;
            usf3.MetadataService.PermissionSet metadata_permSetToCreate = ConvertApexTypeToMetadataService_PermissionSet(permSetToCreate);


            List<usf3.MetadataService.PermissionSet> permSetsToCreate = new List<usf3.MetadataService.PermissionSet>();
            permSetsToCreate.add(metadata_permSetToCreate);

            //List<MetadataService.Metadata> deploymentMetadata = new List<MetadataService.Metadata>();
            //deploymentMetadata.add(deploymentMetadata);

            usf3.MetadataService.handleSaveResults(service.createMetadata(permSetsToCreate)[0]);

                    
                   
            //Create a Result object to hold the return values
            Result response = new Result();
            response.errors = 'no errors';
            responseWrapper.add(response);
        }     
     
        return responseWrapper;
    
    }

 /*    flowDMC_PermissionSet finalPermSet = new flowDMC_PermissionSet();
    finalPermSet.recordTypeVisibilities = new List<flowDMC_PermSetRecordTypeVisibility>();
    finalPermSet.fullName = originalPermSet.fullName;
    finalPermSet.label = originalPermSet.label;
    for (usf3.MetadataService.PermissionSetRecordTypeVisibility curRecordTypeVisibility : originalPermSet.recordTypeVisibilities) {
        flowDMC_PermSetRecordTypeVisibility finalRecordTypeVisibility  = new flowDMC_PermSetRecordTypeVisibility();
        finalRecordTypeVisibility.recordType = curRecordTypeVisibility.recordType;
        finalRecordTypeVisibility.visible = curRecordTypeVisibility.visible;
        finalPermSet.recordTypeVisibilities.add(finalRecordTypeVisibility);
    } */
  
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
