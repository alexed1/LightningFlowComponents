/**
 * @Description        : Recalculates all of the formula fields in a given sObject collection passed in from flow, then outputs a refreshed collection
 *						Note that this will not make any calls to the Database and all fields needed in the formulas have to be present in the collection -
 *						Contrary to the Formula class documentation it will not actually call out to the DB to get what it needs!
 * @Author             : Adam White
 * @Last Modified By   : adwhite@captechconsulting.com
 * @Last Modified On   : 9/1/2020
 * @Modification Log   : 
 * Ver      Date            Author      		      		  Modification
 * 1.0      9/1/2020      adwhite@captechconsulting.com      Initial release
**/

global with sharing class RefreshFormulaFields {
    @InvocableMethod(label='Refresh Formula Fields' description='' category='Util')
	global static List<Response> refreshFormulas(List<Request> inputList) {
         List<Response> outputResponses =  new List<Response>();
        
        for (Request curRequest: inputList) {
            List<SObject> collectionToHydrate = new List<SObject>();
            Response response = new Response();
            response.refreshedCollection = new List<SObject>();
            //call the Formula recalc method to refresh the formulas on the input collection
        	List<FormulaRecalcResult> results = Formula.recalculateFormulas(curRequest.inputCollection);
            Boolean successResult = results[0].IsSuccess();
            system.debug('Success?: ' + successResult );
            //goes through all of the results and adds them to the refreshedCollection output for flow
          		 for (FormulaRecalcResult result : results) {
           			 response.refreshedCollection.add(result.getSObject());
             }
            outputResponses.add(response);
        }
    
    return outputResponses;
    }
        
        
    global class Request {
        @InvocableVariable(description='Collection to recalculate' required=true)
        global List<sObject> inputCollection;       
    }
        
    global class Response {
        @InvocableVariable(description='List of records refreshed from query.')
        global List<sobject> refreshedCollection;
    }

}