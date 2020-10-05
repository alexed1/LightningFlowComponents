//the original code path for modifying permission sets assumed that the same set of RecordTypeVisibilities could be applied to all of the selected permsets
//this path allows for a modification to be made to each perm set where the permsets are unaffected except for that modification
//at some point the original code path should be refactored into this one

public with sharing class ModifyPermissionSets {
    @InvocableMethod
    public static List<ResultSet> execute (List<RequestSet> requestList) {
        System.debug('entering ModifyPermissionSets');
        List<ResultSet> responseWrapper = new List<ResultSet>();
        List<flowDMC_PermissionSet> modifiedPermissionSets = new List<flowDMC_PermissionSet>();

        for (RequestSet curRequest : requestList) {

            //if targetRTName is null we assume this is a full set execution
            if(curRequest.targetRTShortName != null) {
                modifiedPermissionSets = ChangeRecordTypeVisibilityForOneRecordType(curRequest);       

            } else {
                modifiedPermissionSets = ChangeRecordTypeVisbilityForAllRecordTypes(curRequest);
            }
                   
            //Create a Result object to hold the return values
            ResultSet response = new ResultSet();
            response.modifiedPermSets = modifiedPermissionSets;
            responseWrapper.add(response);
        }     
     
        return responseWrapper;
    
    }
 


//for each record type name in the All set
        // create a new RTV record
        // set visibility based on whether it's in all or selected
        
       
       // if this is for a permset, copy it to the modification set if it's in selected

    public static List<flowDMC_PermissionSet> ChangeRecordTypeVisbilityForAllRecordTypes(RequestSet curRequest) {
        List<flowDMC_PermSetRecordTypeVisibility> modifiedRTVs = new List<flowDMC_PermSetRecordTypeVisibility>();
        List<flowDMC_PermissionSet> targetPermissionSets = curRequest.targetPermSets; 

        for(String curRTVname : curRequest.allRecordTypesShortNames) {
            flowDMC_PermSetRecordTypeVisibility curRecordTypeVisibility = new flowDMC_PermSetRecordTypeVisibility();
            curRecordTypeVisibility.recordType = curRequest.objectName + '.' + curRTVname;
            if (curRequest.selectedRecordTypeShortNames.contains(curRTVname)) {
                curRecordTypeVisibility.visible = true;
                //PermissionSet implementation: return just the Visible=true
                modifiedRTVs.add(curRecordTypeVisibility);
            } else {
                curRecordTypeVisibility.visible = false;
            }
            
            
        }

        //the same set of RecordTypeVisibility gets applied to all of the targetPermissionSets
        for(flowDMC_PermissionSet curPermissionSet : targetPermissionSets) {
            curPermissionSet.recordTypeVisibilities = modifiedRTVs;
        }

        System.debug('recordTypeVisibility datastructure is:' + modifiedRTVs);
        return targetPermissionSets;


    }


//since this is a permset and not a profile we know that all RTV in the RTV set have visibile=true
    //for each targetPermSet, read its RTV set
    // for each RTV
        // if the name matches the targetRTShortName (or full name? )
                //if assigned is false, turn it off and don't add it to the modified list, else add it to the modified list
    // if there was no match, create a new one and add it to the modified list
               
    public static List<flowDMC_PermissionSet> ChangeRecordTypeVisibilityForOneRecordType(RequestSet curRequest) {
        List<flowDMC_PermissionSet> targetPermSets = curRequest.targetPermSets; 
        List<flowDMC_PermissionSet> modifiedTargetPermSets = new List<flowDMC_PermissionSet>();
    
        String fullRTName =  curRequest.objectName + '.' + curRequest.targetRTShortName;
        Boolean matchFound;

        for (flowDMC_PermissionSet curTarget : targetPermSets) {
            matchFound=false;
            List<flowDMC_PermSetRecordTypeVisibility> curTargetRTVs = curTarget.recordTypeVisibilities;
            List<flowDMC_PermSetRecordTypeVisibility> modifiedTargetRTVs = new List<flowDMC_PermSetRecordTypeVisibility>();
            for(flowDMC_PermSetRecordTypeVisibility curRTV : curTargetRTVs ) {
                if(curRTV.recordType == fullRTName){
                    matchFound = true;
                    if (curRequest.assigned == true) {
                        modifiedTargetRTVs.add(curRTV);
                    }
                } else {
                    //it doesn't match the requested change, but it's visible, so make sure to copy it over to the modified set
                    if(curRTV.visible) {
                        modifiedTargetRTVs.add(curRTV);
                    }
                }
            }
            if (!matchFound) {
                if (curRequest.assigned) {
                    flowDMC_PermSetRecordTypeVisibility newRTV = new flowDMC_PermSetRecordTypeVisibility();
                    newRTV.visible = true;
                    newRTV.recordType = fullRTName;
                    modifiedTargetRTVs.add(newRTV);
                }
            }
            System.debug('modifiedTargetRTVs is: ' + modifiedTargetRTVs);
            curTarget.recordTypeVisibilities = modifiedTargetRTVs;
            modifiedTargetPermSets.add(curTarget);            
        }
        //iterate through until you get to a RecordTypeVsibility with the same RT Name as the passedin RT Name 
                //did you find one? 
            //if yes
                 // if assigned is true, break. it's already activated
                 // else delete the RecordTypeVisibility from the RecordTypeVisibililty set
            //if no
                // if Activate is Yes, create a new one and add it to the set
                // if Activate is No, break. it's already off
       //return the set
       
       
       return modifiedTargetPermSets;   
    }

        

    public class RequestSet {

        @InvocableVariable
        public List<String> selectedRecordTypeShortNames;

        @InvocableVariable
        public List<String> allRecordTypesShortNames; 

        @InvocableVariable
        public String objectName;

        @InvocableVariable
        public String targetRTShortName; //the name of the Record Type to be altered. ShortName means 'MyRT3' instead of 'Account.MyRT3'

        @InvocableVariable
        public Boolean assigned; //whether the target RT should be on or off for the target perm sets/profiles
       
        @InvocableVariable
        public List<flowDMC_PermissionSet> targetPermSets;
        
    }
    
    public class ResultSet {

        @InvocableVariable
        public List<flowDMC_PermissionSet> modifiedPermSets; 


    }

    public class InvocableActionException extends Exception {}

}
