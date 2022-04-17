public with sharing class GetPermissionSets {
    
    @InvocableMethod
    public static List<ResultSet> get (List<Request> requestList) {
        System.debug('entering GetPermissionSet');
        List<ResultSet> responseWrapper = new List<ResultSet>();
        for (Request curRequest : requestList) {
            usf3.MetadataService.MetadataPort service = usf3.MetadataService.createService();
            List<String> permSetNames = new List<String>();
            permSetNames.add(curRequest.singlePermSetName);
            permSetNames.addAll(curRequest.permSetNameStringCollection);

            List<usf3.MetadataService.PermissionSet> retrievedPermSets =
                (List<usf3.MetadataService.PermissionSet>) service.readMetadata('PermissionSet',
                    permSetNames).getRecords();
                    
            System.debug('retrieved permission sets: ' + retrievedPermSets);
            
            //Create a ResultSet object to hold the return values
            ResultSet response = new ResultSet();
            response.singlePermSet = CopyMetadataToDMC(retrievedPermSets[0]);
            for(usf3.MetadataService.PermissionSet curPermSet : retrievedPermSets) {
                response.collectionPermSets.add(CopyMetadataToDMC(curPermSet));
            }
            responseWrapper.add(response);
        }     
     
        return responseWrapper;
    
    }


    public static flowDMC_PermissionSet CopyMetadataToDMC (usf3.MetadataService.PermissionSet originalPermSet) {
        originalPermSet = FillInNulls(originalPermSet);
        flowDMC_PermissionSet finalPermSet = new flowDMC_PermissionSet();
        finalPermSet.recordTypeVisibilities = new List<flowDMC_PermSetRecordTypeVisibility>();
        finalPermSet.fullName = originalPermSet.fullName;
        finalPermSet.label = originalPermSet.label;
        for (usf3.MetadataService.PermissionSetRecordTypeVisibility curRecordTypeVisibility : originalPermSet.recordTypeVisibilities) {
            flowDMC_PermSetRecordTypeVisibility finalRecordTypeVisibility  = new flowDMC_PermSetRecordTypeVisibility();
            finalRecordTypeVisibility.recordType = curRecordTypeVisibility.recordType;
            finalRecordTypeVisibility.visible = curRecordTypeVisibility.visible;
            finalPermSet.recordTypeVisibilities.add(finalRecordTypeVisibility);
        }
        return finalPermSet;

    }

    //the data structures created by the MetadataService do not initialize Lists and if you leave them null, the code may through a null reference
    private static usf3.MetadataService.PermissionSet FillInNulls(usf3.MetadataService.PermissionSet originalPermSet) {
        if (originalPermSet.recordTypeVisibilities == null)
            originalPermSet.recordTypeVisibilities = new List<usf3.MetadataService.PermissionSetRecordTypeVisibility>();
        return originalPermSet;
    }

    public class Request {

      @InvocableVariable
      public String singlePermSetName;

      @InvocableVariable
      public List<String> permSetNameStringCollection;

        
    }
    
    public class ResultSet {
        public ResultSet() {
            collectionPermSets = new List<flowDMC_PermissionSet>();
        }

        @InvocableVariable
        public flowDMC_PermissionSet singlePermSet;

        @InvocableVariable
        public List<flowDMC_PermissionSet> collectionPermSets;
    }

    public class InvocableActionException extends Exception {}
}

