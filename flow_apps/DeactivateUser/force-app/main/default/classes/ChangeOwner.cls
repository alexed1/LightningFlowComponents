global with sharing class ChangeOwner {
    global ChangeOwner() {

    }


    @InvocableMethod(label='Change Owner' description='test' category='test')
    global static List<Results> execute(List<Requests> requestList) {
        String username = 'test-kczfnxqltjik@example.com';
        String pwdtoken = 'test1234HqZ2NlGUeLOiTZiuMMiQnV00';

       

        List< Results> outputs = new List<Results>{};

        for (Requests request: requestList) {


                Results curResult = new Results();
 

                for (SObject record : request.recordsToBeChanged) {
                    record.Id = 'foo';
                   
                    // record.put(OwnerId, request.newOwnerId);
                }

                
               // partnerSoapSforceCom.SaveResult[] mySaveResult = partnerSoapSforceCom.update();
                outputs.add(curResult);
                      }
        return outputs;
    }
    

    global class Requests {

        @InvocableVariable
        global List<SObject> recordsToBeChanged;

        @InvocableVariable
        global string newOwnerId;
        
  
    
    }

    global class Results {
        @InvocableVariable
        global String errors;
    
       
    }
}
