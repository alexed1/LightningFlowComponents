/**
 * @Description        : Compares two record collections and returns records that are the shared and records that are unique to each collection. 
 * 						Specify the Ids you want to compare for each sObject and the action will take care of the rest.
 * @Author             : Adam White
 * @Last Modified By   : adamwhiteuva@gmail.com
 * @Last Modified On   : 1/26/2021 
 * @Modification Log   : 
 * Ver      Date            Author      		      		  Modification
 * 1.0      1/26/2021      adamwhiteuva@gmail.com      Initial release
**/
global without sharing class FindCommonAndUniqueRecords {
    @InvocableMethod(label='Get Common and Unique Records'description='Extract and return two collections comparing a source and target collection'category='Util')
    global static List <Result> compareRecords(List<Request> requestList) {
        
        List<Result> outputResults =  new List<Result>();
        
        //make sure we check that both collections are not empty/null
        for (Request request: requestList) {
            
            if (request.sourceRecordCollection != null &&
                request.targetRecordCollection != null) {
                    
                    List<SObject> sourceRecordCollection = request.sourceRecordCollection;
                    List<SObject> targetRecordCollection = request.targetRecordCollection;
                    
                    Result result = new Result();
                    result.sourceCommonRecordCollection = new List<sObject>();
                    result.targetCommonRecordCollection = new List<sObject>();
                    result.sourceUniqueRecordCollection = new List<sObject>();
                    result.targetUniqueRecordCollection = new List<sObject>();
                    
                    // if either collection is empty then we simply output directly to the unique collection outputs
                    if (targetRecordCollection.isEmpty() || sourceRecordCollection.isEmpty() ) {
                        if (targetRecordCollection.isEmpty()) {
                                result.sourceUniqueRecordCollection.addAll(sourceRecordCollection); 
                        }

                        if (sourceRecordCollection.isEmpty()) {
                                result.targetUniqueRecordCollection.addAll(targetRecordCollection);
                        }
                        
                    }
                        
                    if (!targetRecordCollection.isEmpty() && !sourceRecordCollection.isEmpty()) {
                        
                        //puts the source collection into a map so we can compare with the target collection map
                        Map<String, sObject> sourceMap = new Map<String, sObject>();
                        
                        // get the fields on the object... this will likely fail if the collection doesnt have Ids yet
                        Map<String, SObjectField> sourceFieldMap = sourceRecordCollection[0].getSObjectType().getDescribe().fields.getMap();
                        
                        // The key to the map is the api name of the field
                        Schema.SobjectField sourceCurField = sourceFieldMap.get(request.sourceUniqueID);
                        
                        // Loop over the source collectin
                        for (sObject sourceRecord : sourceRecordCollection) {
                            
                            //grab the value of the Unique ID field
                            String sourceCurrentFieldValue = (String)sourceRecord.get(sourceCurField);
                            
                            //as long as the unique value isnt blank, put it in the sourceMap map to be used later
                            if (sourceCurrentFieldValue != null && sourceCurrentFieldValue != '') {
                                sourceMap.put(sourceCurrentFieldValue, sourceRecord);
                            }
                            
                        }
                                             
                        //puts the target collection into a map so we can compare with the source collection
                        Map<String, sObject> targetMap = new Map<String, sObject>();
                        
                        // Construct a field map of the first record in the target record collection
                        Map<String, SObjectField> targetFieldMap = targetRecordCollection[0].getSObjectType().getDescribe().fields.getMap();
                        
                        // The key to the map is the api name of the field
                        Schema.SobjectField targetCurField = targetFieldMap.get(request.targetUniqueID);
                        
                        for (sObject targetRecord : targetRecordCollection) {
                            system.debug('target loop start' );
                            String targetCurFieldValue = (String)targetRecord.get(targetCurField);
                            system.debug('targetCurField Value OK - line 68' );
                             //as long as the unique value isnt blank, put it in the targetMap map to be used later
                            if (targetCurFieldValue != null && targetCurFieldValue != '') {
                                targetMap.put(targetCurFieldValue, targetRecord);
                            }
                            
                        }
                        
                        // we loop over the 'Source' collection to see if the record is in the 'Target' collection'.
                        for (sObject sourceRecord : sourceRecordCollection ) {
                            //if it is, we add it to the common record collection and remove it from the target map. We do this
                            String sourceFieldValue = sourceRecord.get(request.sourceUniqueID).toString();
    
                            if (targetMap.containsKey(sourceFieldValue)) {
                                result.sourceCommonRecordCollection.add(sourceRecord);
                            }
                            
                            else {
                                result.sourceUniqueRecordCollection.add(sourceRecord);
                                 }                            
                        }
                        
                        // we loop over the 'Target' collection to see if the record is in the 'Source' collection'.
                        for (sObject targetRecord : targetRecordCollection ) {
                            //if it is, we add it to the common record collection and remove it from the target map. We do this
                            String targetFieldValue = targetRecord.get(request.targetUniqueID).toString();
    
                            if (sourceMap.containsKey(targetFieldValue)) {
                                result.targetCommonRecordCollection.add(targetRecord);
                            }
                            
                            else {
                                result.targetUniqueRecordCollection.add(targetRecord);
                                 }
                                
                            }
                            
                        }
                    
                    //add this result to the bulkified results (invocable specific)
                        outputResults.add(result);

                    }
                
                }
        return outputResults;
        }
               
    		global class Request {
            @InvocableVariable(description='The first record collection you want to compare to' required=true)
            global List<SObject> sourceRecordCollection;
            
            @InvocableVariable(description='The Source Record Unique ID (Field API Name) you want to compare against the Target Unique ID' required=true)
            global String sourceUniqueID;    
            
            @InvocableVariable(description='The second record collection you want to compare against' required=true)
            global List<sObject> targetRecordCollection;

            @InvocableVariable(description='The Target Record Unique ID (Field API Name) you want to compare against the Source Unique ID' required=true)
            global String targetUniqueID;            
    
   		 }
    
        global class Result {
            @InvocableVariable(description='The unique records in the source collection when compared against the target collection')
            global List<sObject> sourceUniqueRecordCollection;
    
            @InvocableVariable(description='The shared records between the two collections')
            global List<sObject> sourceCommonRecordCollection;
            
            @InvocableVariable(description='The unique records in the target collection when compared against the source collection')
            global List<sObject> targetUniqueRecordCollection;      

            @InvocableVariable(description='The shared records between the two collections')
            global List<sObject> targetCommonRecordCollection;            

    	}
    
}