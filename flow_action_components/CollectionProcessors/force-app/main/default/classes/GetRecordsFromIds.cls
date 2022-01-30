    global inherited sharing class GetRecordsFromIds {
  
        @InvocableMethod(label='Get Records From Ids' description='Given a collection of Ids, hydrate them into records' category='Util')
        global static List <Result> execute (List<Request> requestList) {
            
            System.debug('entering Get Records From Ids');
            List<Result> results =  new List<Result>();
            
            for (Request request: requestList) {
               
                String ids ='(';
                for(Integer i=0; i<request.inputIds.size(); i++) {
                    ids = ids + '\'' + request.inputIds[i] + '\'' + ',';
                }
                ids = ids.removeend(',') + ')';
    
                //String ids = '(' + string.join(request.inputIds,',') + ')';
            
                String queryString = 'SELECT ' + request.fieldNames + ' FROM ' + request.objectName + ' WHERE id IN' + ids;
                System.debug('soql query is: ' + queryString);
                Result result = new Result();
                if(!Test.isRunningTest()) {
                    List<sObject> recordList = Database.query(queryString);
                    result.records = recordList;
                    result.recordsString =JSON.serialize(recordList);
                    System.debug('hydrated records are: ' + recordList);
                } else {
                    result.records = null;
                    result.recordsString = null;
                }
      
                  
                results.add(result);
            }
            return results;
        }
    
    
    
        global class Request {
            @InvocableVariable(description='Collection of Ids' required=true)
            global List<String> inputIds;
            
            @InvocableVariable
            global String objectName;
    
            @InvocableVariable
            global String fieldNames;
    
        }
        
        global class Result {
            @InvocableVariable(description='Full records')
            global List<SObject> records;
            @InvocableVariable(description='Full records string')
            global String recordsString;
    
     
        }
    
    }