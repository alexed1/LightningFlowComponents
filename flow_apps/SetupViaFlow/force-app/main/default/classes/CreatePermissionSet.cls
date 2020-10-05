public with sharing class CreatePermissionSet {

    @InvocableMethod
    public static List<Result> execute (List<Request> requestList) {
        System.debug('entering CreatePermissionSet');
        List<Result> responseWrapper = new List<Result>();
        for (Request curRequest : requestList) {
            fbc_MetadataService.MetadataPort service = fbc_MetadataService.createService();

            //process single permSet input
            flowDMC_PermissionSet permSetToCreate = curRequest.singlePermSet;
            fbc_MetadataService.PermissionSet metadata_permSetToCreate = ConvertApexTypeToMetadataService_PermissionSet(permSetToCreate);


            List<fbc_MetadataService.PermissionSet> permSetsToCreate = new List<fbc_MetadataService.PermissionSet>();
            permSetsToCreate.add(metadata_permSetToCreate);

            //List<MetadataService.Metadata> deploymentMetadata = new List<MetadataService.Metadata>();
            //deploymentMetadata.add(deploymentMetadata);

            fbc_MetadataService.handleSaveResults(service.createMetadata(permSetsToCreate)[0]);

                    
                   
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
    for (fbc_MetadataService.PermissionSetRecordTypeVisibility curRecordTypeVisibility : originalPermSet.recordTypeVisibilities) {
        flowDMC_PermSetRecordTypeVisibility finalRecordTypeVisibility  = new flowDMC_PermSetRecordTypeVisibility();
        finalRecordTypeVisibility.recordType = curRecordTypeVisibility.recordType;
        finalRecordTypeVisibility.visible = curRecordTypeVisibility.visible;
        finalPermSet.recordTypeVisibilities.add(finalRecordTypeVisibility);
    } */
  
    public static fbc_MetadataService.PermissionSet ConvertApexTypeToMetadataService_PermissionSet(flowDMC_permissionSet originalPermSet) {
        fbc_MetadataService.PermissionSet finalPermSet = new  fbc_MetadataService.PermissionSet();
        finalPermSet.recordTypeVisibilities = new List<fbc_MetadataService.PermissionSetRecordTypeVisibility>();
        finalPermSet.fullName = originalPermSet.fullName;
        finalPermSet.label = originalPermSet.label;
        for (flowDMC_PermSetRecordTypeVisibility curRecordTypeVisibility : originalPermSet.recordTypeVisibilities) {
            fbc_MetadataService.PermissionSetRecordTypeVisibility finalRecordTypeVisibility = new fbc_MetadataService.PermissionSetRecordTypeVisibility();
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
