/**
 * Created: 9/19/2024 AMM
 * Scope:   Given a caseId, get the thread token and return it to the caller, so that a flow can execute operations with thread token.
 * Uses:    Lightning Threading enabled in org, allows flow to retrieve the Thread Token provided in merge fields for email to case.  
 *          Helper method to stamp Token on case or flow interface for user interactions.
 * Refs:    https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_annotation_InvocableMethod.htm
 * 
 * @param caseId (list)
 * @return threadToken (list)
 */

 global with sharing class GetCaseThreadToken {

    @InvocableMethod(label = 'Get Case Thread Token' description = 'Provide a caseId and get back the thread token for the case that is provided to emails from case')
    global static List <Outputs> getTokenFromCaseId (List<Inputs> requestList) {
 
      //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
      List<Outputs> responseList = new List<Outputs>();
      
      for (Inputs req : requestList) {
            Outputs resp = new Outputs();
            resp.threadToken = EmailMessages.getFormattedThreadingToken(req.caseId);
            responseList.add(resp);
      }

      return responseList;
    }
     
    global class Inputs {      
      @InvocableVariable(required=true)
      global Id caseId;
    }

    global class Outputs {
      @InvocableVariable
      global String threadToken;
    }
}
