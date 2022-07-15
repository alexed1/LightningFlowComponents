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

                partnerSoapSforceCom.Soap myPartnerSoap = new partnerSoapSforceCom.Soap(); 
                partnerSoapSforceCom.LoginResult partnerLoginResult = myPartnerSoap.login(username, pwdtoken);
                System.debug ('login result is: ' + partnerLoginResult);
                curResult.partnerLoginResult = partnerLoginResult;


                partnerSoapSforceCom.SessionHeader_element sessionHeader = new partnerSoapSforceCom.SessionHeader_element();  
                sessionHeader.sessionId = partnerLoginResult.sessionId;  
    

                for (SObject record : request.recordsToBeChanged) {
                    record.Id = 'foo';
                   
                    // record.put(OwnerId, request.newOwnerId);
                }

                partnerSoapSforceCom.OwnerChangeOption opt1 = new partnerSoapSforceCom.OwnerChangeOption();
                opt1.execute=true;
                opt1.type_x = 'TransferOwnedOpenOpportunities';

                partnerSoapSforceCom.OwnerChangeOptions_element curoptions = new partnerSoapSforceCom.OwnerChangeOptions_element();
                curoptions.options.add(opt1);

                partnerSoapSforceCom.SaveResult[] mySaveResults = partnerSoapSforceCom.update_x(request.recordsToBeChanged);
                System.debug('save results' + mySaveResults);
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
        global partnerSoapSforceCom.LoginResult partnerLoginResult;
    
       
    }
}
