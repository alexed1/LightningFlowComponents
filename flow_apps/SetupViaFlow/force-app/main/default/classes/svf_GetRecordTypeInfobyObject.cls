
//didn't want to make GetRecordTypeInfobyObject a prerequisite, so including it here
//but don't want it to conflict on install so added the svf prefix
global with sharing class svf_GetRecordTypeInfobyObject {
    //given a target object name, return a collection of strings representing the available record types
    //great for extracting the Names and IDs of record types available for selection
    // adapted by Tamar Erlich, added a toggle to ignore the master record type.
    
    
        @InvocableMethod
        global static List <Results> get(List<Requests> requestList) {
            Results response = new Results();
            List<Results> responseWrapper = new List<Results>();
            for (Requests curRequest : requestList) {

                String objectName = curRequest.objectName;
                Boolean onlyReturnActiveRecordTypes = curRequest.onlyReturnActiveRecordTypes;
                Boolean onlyReturnRecordTypesAvailableToCurrentUser = curRequest.onlyReturnRecordTypesAvailableToCurrentUser;
                Boolean ignoreMasterRecordType = curRequest.ignoreMasterRecordType;
                List<String> recordTypeNames = new List<String>();
                List<String> recordTypeIds = new List<String>();
                String errors;
                // Send the email you have created.
                try {
                    
                    Map<String, Schema.RecordTypeInfo> recTypeInfoMap = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName();
                    List<Schema.RecordTypeInfo> recTypeInfoList = recTypeInfoMap.values();
                    System.debug('recTypeInfo is' + recTypeInfoList);
                    //extract the names and recordIds and return them as List<String> 
                    for(Schema.RecordTypeInfo curRecord : recTypeInfoList) {
                        System.debug('processing record: ' + curRecord);
                        Boolean filteredOut = false;
                        //if only active 
                        if (onlyReturnActiveRecordTypes == true && ! curRecord.isActive()) {
                                filteredOut = true;    
                        }
                        if (onlyReturnRecordTypesAvailableToCurrentUser == true && ! curRecord.isAvailable()) {
                                filteredOut = true;    
                        }
                        if (ignoreMasterRecordType == true && curRecord.isMaster()) {
                                filteredOut = true;    
                        }
                        if ( filteredOut != true) {
                            recordTypeNames.add(curRecord.getName());
                            recordTypeIds.add(curRecord.getRecordTypeId());
                        }
                       
                    }
        
                } catch (InvocableActionException e){
                    System.debug ('exception occured: ' + e.getMessage());
                    
                    errors = e.getMessage();
                } 
                response.recordTypeNames = recordTypeNames;
                response.recordTypeIds = recordTypeIds;
                response.errors = errors;
              
                responseWrapper.add(response);
            }
    
    
            return responseWrapper;
    
    
        }
        global class Requests {
    
            @InvocableVariable(label='Object Name' required=true)
            global String objectName;
    
            @InvocableVariable
            global Boolean onlyReturnActiveRecordTypes;
    
            @InvocableVariable
            global Boolean onlyReturnRecordTypesAvailableToCurrentUser;
    
            @InvocableVariable
            global Boolean ignoreMasterRecordType;
    
        }
    
        global class Results {
    
            public Results() {
                
            }
            @InvocableVariable
            global String errors;
    
            @InvocableVariable
            global List<String> recordTypeNames;
    
            @InvocableVariable
            global List<String> recordTypeIds;
        }
    
        global class InvocableActionException extends Exception {}
    
    }