public with sharing class UpdateProfile {
    @InvocableMethod
    public static List<Result> execute (List<Request> requestList) {
        System.debug('entering UpdateProfile');
        List<Result> responseWrapper = new List<Result>();
        for (Request curRequest : requestList) {
            fbc_MetadataService.MetadataPort service = fbc_MetadataService.createService();

            List<fbc_MetadataService.Profile> profilesToUpdate = new List<fbc_MetadataService.Profile>();

            //process single profile input
            if(curRequest.singleProfile != null) {
                flowDMC_Profile profileToUpdate = curRequest.singleProfile;
                fbc_MetadataService.Profile metadata_profileToUpdate = ConvertApexTypeToMetadataService_Profile(profileToUpdate);
                System.debug ('single perm set to update is: ' + metadata_profileToUpdate);
                profilesToUpdate.add(metadata_profileToUpdate);
            }
           
            
            if(curRequest.profileCollection.size() > 0) {
                for(flowDMC_Profile curProfile : curRequest.profileCollection){
                    profilesToUpdate.add(ConvertApexTypeToMetadataService_Profile(curProfile));
                }
            }

            
           

            
           


            fbc_MetadataService.handleSaveResults(service.updateMetadata(profilesToUpdate)[0]);

                    
                   
            //Create a Result object to hold the return values
            Result response = new Result();
            response.errors = 'no errors';
            responseWrapper.add(response);
        }     
     
        return responseWrapper;
    
    }

  
    public static fbc_MetadataService.Profile ConvertApexTypeToMetadataService_Profile(flowDMC_Profile originalProfile) {
        fbc_MetadataService.Profile finalProfile = new  fbc_MetadataService.Profile();
        finalProfile.recordTypeVisibilities = new List<fbc_MetadataService.ProfileRecordTypeVisibility>();
        System.debug('inside Convert in Update Profile: finalprofile is: ' + finalProfile);
        System.debug('inside Convert in Update Profile: originalProfile is: ' + originalProfile);
        finalProfile.fullName = originalProfile.fullName;
        for (flowDMC_ProfileRecordTypeVisibility curRecordTypeVisibility : originalProfile.recordTypeVisibilities) {
            fbc_MetadataService.ProfileRecordTypeVisibility finalMetadataRecordTypeVisibility = new fbc_MetadataService.ProfileRecordTypeVisibility();
            finalMetadataRecordTypeVisibility.recordType = curRecordTypeVisibility.recordType;
            finalMetadataRecordTypeVisibility.visible = curRecordTypeVisibility.visible;
            finalMetadataRecordTypeVisibility.default_x = curRecordTypeVisibility.default_x;
            finalMetadataRecordTypeVisibility.personAccountDefault = curRecordTypeVisibility.personAccountDefault;
            
            finalProfile.recordTypeVisibilities.add(finalMetadataRecordTypeVisibility);
        }


        return finalProfile;


    }
    

    public class Request {

        @InvocableVariable
        public flowDMC_Profile singleProfile;

        @InvocableVariable
        public List<flowDMC_Profile> profileCollection;

        
    }
    
    public class Result {

        @InvocableVariable
        public String errors; //NYI instead exceptions are thrown


    }

    public class InvocableActionException extends Exception {}

}