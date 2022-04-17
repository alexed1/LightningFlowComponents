public with sharing class GetProfiles {
 
    @InvocableMethod
    public static List<ResultSet> execute (List<Request> requestList) {
        System.debug('entering GetProfiles');
        List<ResultSet> responseWrapper = new List<ResultSet>();
        for (Request curRequest : requestList) {
            usf3.MetadataService.MetadataPort service = usf3.MetadataService.createService();
            List<String> profileNames = new List<String>();
            profileNames.add(curRequest.singleProfileName);
            profileNames.addAll(curRequest.profileNameCollection);

            List<usf3.MetadataService.Profile> retrievedProfiles =
                (List<usf3.MetadataService.Profile>) service.readMetadata('Profile',
                    profileNames).getRecords();
                    
            System.debug('retrieved profiles: ' + retrievedProfiles);
            
            //Create a ResultSet object to hold the return values
            ResultSet response = new ResultSet();
            response.singleProfile = CopyMetadataToDMC(retrievedProfiles[0]);
            for(usf3.MetadataService.Profile curProfile : retrievedProfiles) {
                response.collectionProfiles.add(CopyMetadataToDMC(curProfile));
            }
            responseWrapper.add(response);
        }     
     
        return responseWrapper;
    
    }


    public static flowDMC_Profile CopyMetadataToDMC (usf3.MetadataService.Profile originalProfile) {
        originalProfile = FillInNulls(originalProfile);
        flowDMC_Profile finalProfile = new flowDMC_Profile();
        finalProfile.recordTypeVisibilities = new List<flowDMC_ProfileRecordTypeVisibility>();
        finalProfile.fullName = originalProfile.fullName;
        finalProfile.type = originalProfile.type;
        finalProfile.userLicense = originalProfile.userLicense;
        for (usf3.MetadataService.ProfileRecordTypeVisibility curRecordTypeVisibility : originalProfile.recordTypeVisibilities) {
            flowDMC_ProfileRecordTypeVisibility finalRecordTypeVisibility  = new flowDMC_ProfileRecordTypeVisibility();
            finalRecordTypeVisibility.recordType = curRecordTypeVisibility.recordType;
            finalRecordTypeVisibility.visible = curRecordTypeVisibility.visible;
            finalRecordTypeVisibility.default_x = curRecordTypeVisibility.default_x;
            finalRecordTypeVisibility.personAccountDefault = curRecordTypeVisibility.personAccountDefault;
            finalProfile.recordTypeVisibilities.add(finalRecordTypeVisibility);
        }
        return finalProfile;

    }

    //the data structures created by the MetadataService do not initialize Lists and if you leave them null, the code may through a null reference
    private static usf3.MetadataService.Profile FillInNulls(usf3.MetadataService.Profile originalProfile) {
        if (originalProfile.recordTypeVisibilities == null)
            originalProfile.recordTypeVisibilities = new List<usf3.MetadataService.ProfileRecordTypeVisibility>();
        return originalProfile;
    }

    public class Request {

      @InvocableVariable
      public String singleProfileName;

      @InvocableVariable
      public List<String> profileNameCollection;

        
    }
    
    public class ResultSet {
        public ResultSet() {
            collectionProfiles = new List<flowDMC_Profile>();
        }

        @InvocableVariable
        public flowDMC_Profile singleProfile;

        @InvocableVariable
        public List<flowDMC_Profile> collectionProfiles;
    }

    public class InvocableActionException extends Exception {}
}

