global with sharing class ConvertInternetTime {

    @InvocableMethod
    global static List<Results> execute (List<Requests> requests)
       {

        List<Results> responseList = new List<Results>();

        for (Requests curRequest : requests) {
            Results curResponse = new Results();
         /*    Long longTime = Long.valueOf(curRequest.inputTimeMilliseconds);
            curResponse.outputDateTime = DateTime.newInstance(longTime); 
            System.debug('outputDateTime is: ' + curResponse.outputDateTime);
 */

           
            curResponse.outputDateTime = DateTime.newInstance(curRequest.numberInputTimeMilliseconds); 
            System.debug('outputDateTime is: ' + curResponse.outputDateTime);

            responseList.add(curResponse);
        }

        
        return responseList;
       }
    
    global class Requests {
        @InvocableVariable
        global String stringInputTimeMilliseconds;
        @InvocableVariable
        global Integer numberInputTimeMilliseconds;

    }
    
    global class Results {
        @InvocableVariable
        global Datetime outputDateTime;
    }

}