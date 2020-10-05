public with sharing class ModifyProfiles {
    @InvocableMethod
    public static List<ResultSet> execute (List<RequestSet> requestList) {
        System.debug('entering ModifyProfiles');
        List<ResultSet> responseWrapper = new List<ResultSet>();
        List<flowDMC_Profile> modifiedProfiles = new List<flowDMC_Profile>();

        for (RequestSet curRequest : requestList) {

            //if targetRTName is null we assume this is a full set execution
            if(curRequest.targetRTShortName != null) {
                modifiedProfiles = ChangeRecordTypeVisibilityForSingleRecordType(curRequest);       

            } else {
                modifiedProfiles = ChangeRecordTypeVisbilityForAllRecordTypes(curRequest);
            }
                   
            //Create a Result object to hold the return values
            ResultSet response = new ResultSet();
            response.modifiedProfiles = modifiedProfiles;
            responseWrapper.add(response);
        }     
     
        return responseWrapper;
    
    }
 

    //for each record type name in the All set
        // create a new RTV record
        // set visibility based on whether it's in all or selected
        // set default based whether its name matches the default
       // if this is for a profile, copy it to the modification set
       // if this is for a permset, copy it to the modification set if it's in selected

    public static List<flowDMC_Profile> ChangeRecordTypeVisbilityForAllRecordTypes(RequestSet curRequest) {
            List<flowDMC_ProfileRecordTypeVisibility> modifiedRTVs = new List<flowDMC_ProfileRecordTypeVisibility>();
            List<flowDMC_Profile> targetProfiles = curRequest.targetProfiles; 

            for(String curRTVname : curRequest.allRecordTypesShortNames) {
                flowDMC_ProfileRecordTypeVisibility curRecordTypeVisibility = new flowDMC_ProfileRecordTypeVisibility();
                curRecordTypeVisibility.recordType = curRequest.objectName + '.' + curRTVname;
                if (curRequest.selectedRecordTypeShortNames.contains(curRTVname)) {
                    curRecordTypeVisibility.visible = true;
                } else {
                    curRecordTypeVisibility.visible = false;
                }
                if(curRTVname == curRequest.defaultRTNameAssignment) {
                    curRecordTypeVisibility.default_x = true;
                } else {
                    curRecordTypeVisibility.default_x = false;
                }
                //profile implementation: return them all
                modifiedRTVs.add(curRecordTypeVisibility);
            }

            //the same set of RecordTypeVisibility gets applied to all of the targetProfiles
            for(flowDMC_Profile curProfile : targetProfiles) {
                curProfile.recordTypeVisibilities = modifiedRTVs;
            }

            System.debug('recordTypeVisibility datastructure is:' + modifiedRTVs);
            return targetProfiles;


    }


    //since this is a profile and not a permset we know that the metadata has an entry for all RTV both visible true and visible false
    //for each targetProfile, read its RTV set
    // for each RTV
        // if the name matches the  full name? )
                //if assigned is false, set visibility to false and default_x to false (because unassigned can't be defaults)
                //if assigned is true set visibility to true. update default as well
            //else don't change visibility but update default

            //update default: takes the default name and the curRTV
                //if there's a match then 
                     // if curRTV is visible, set default to true
                     // else thrown an error: attempting to set default on an unassigned RT
                //if there's no match, then set default to false
     
               
    public static List<flowDMC_Profile> ChangeRecordTypeVisibilityForSingleRecordType(RequestSet curRequest) {
        List<flowDMC_Profile> targetProfiles = curRequest.targetProfiles; 
        List<flowDMC_Profile> modifiedTargetProfiles = new List<flowDMC_Profile>();
    
        String fullRTName =  curRequest.objectName + '.' + curRequest.targetRTShortName;
        String fullDefaultRTName = curRequest.objectName + '.' + curRequest.defaultRTNameAssignment;

        for (flowDMC_Profile curTarget : targetProfiles) {
          
            List<flowDMC_ProfileRecordTypeVisibility> curTargetRTVs = curTarget.recordTypeVisibilities;
            List<flowDMC_ProfileRecordTypeVisibility> modifiedTargetRTVs = new List<flowDMC_ProfileRecordTypeVisibility>();
            for(flowDMC_ProfileRecordTypeVisibility curRTV : curTargetRTVs ) {
                if(curRTV.recordType == fullRTName) {         
                    if (curRequest.assigned == true) {
                        curRTV.visible = true; 
                    } else {
                        curRTV.visible = false;
                    }
                    curRTV = UpdateDefaultRT(curRTV, fullDefaultRTName); 
                    modifiedTargetRTVs.add(curRTV);
                } else {
                    //it doesn't match the requested change. may still need to change its default status though
                     
                        curRTV = UpdateDefaultRT(curRTV, fullDefaultRTName);
                        modifiedTargetRTVs.add(curRTV);
                    
                }
            }
            
            System.debug('modifiedTargetRTVs is: ' + modifiedTargetRTVs);
            curTarget.recordTypeVisibilities = modifiedTargetRTVs;
            modifiedTargetProfiles.add(curTarget); 
            if(!ChangesAreValid(curTarget)) 
                throw new InvocableActionException('Applying your changes to the profile ' + curTarget.fullName + ' would cause there to be no default record type. Either remove ALL the record types at once or make sure you change the default to a record type that will be or remain assigned to this Profile');         
        }
       
       return modifiedTargetProfiles;   
    }

    public static flowDMC_ProfileRecordTypeVisibility UpdateDefaultRT(flowDMC_ProfileRecordTypeVisibility curRTV, String defaultName) {
        if (curRTV.recordType == defaultName) {
            curRTV.default_x = true;
        } else {
            curRTV.default_x = false;
        }
        curRTV.personAccountDefault = false; // unsupported for now
        return curRTV;
    }

    public static Boolean ChangesAreValid (flowDMC_Profile modifiedTargetProfile) {

        //valid states:
        // there are no visible RT's
        // there is one RT that is visible and is default
        Boolean noVisibleRTs = true;
        Boolean defaultAssignedToVisibleRT = false;

        for (flowDMC_ProfileRecordTypeVisibility curRTV : modifiedTargetProfile.recordTypeVisibilities) {
            if (curRTV.visible == true) {
                noVisibleRTs = false;
                if(curRTV.default_x == true) {
                    defaultAssignedToVisibleRT = true;
                }
            }
        }

        if (noVisibleRTs || defaultAssignedToVisibleRT == true) {
            return true;
        } else return false;

    }
        

    public class RequestSet {

        @InvocableVariable
        public List<String> selectedRecordTypeShortNames;

        @InvocableVariable
        public List<String> allRecordTypesShortNames; 

        @InvocableVariable
        public String defaultRTNameAssignment;

        @InvocableVariable
        public String objectName;

        @InvocableVariable
        public String targetRTShortName; //the name of the Record Type to be altered. ShortName means 'MyRT3' instead of 'Account.MyRT3'

        @InvocableVariable
        public Boolean assigned; //whether the target RT should be on or off for the target perm sets/profiles
       
        @InvocableVariable
        public List<flowDMC_Profile> targetProfiles;
        
    }
    
    public class ResultSet {

        @InvocableVariable
        public List<flowDMC_Profile> modifiedProfiles; 


    }

    public class InvocableActionException extends Exception {}

}
