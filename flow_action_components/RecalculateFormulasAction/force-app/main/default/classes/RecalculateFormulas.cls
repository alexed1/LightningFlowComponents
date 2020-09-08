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

global with sharing class RecalculateFormulas {
    @InvocableMethod(label='Refresh Formulas' description='' category='Util')
	global static List<Output> refreshFormulas(List<Input> inputList) {
         List<Output> outputResponses =  new List<Output>();
        
        for (Input curInput: inputList) {
            List<SObject> collectionToHydrate = new List<SObject>();
            Output output = new Output();
            output.refreshedCollection = new List<SObject>();
            //call the Formula recalc method to refresh the formulas on the input collection
        	List<FormulaRecalcResult> results = Formula.recalculateFormulas(curInput.inputCollection);
            Boolean successResult = results[0].IsSuccess();
            system.debug('Success?: ' + successResult );
            //goes through all of the results and adds them to the refreshedCollection output for flow
          		 for (FormulaRecalcResult result : results) {
           			 output.refreshedCollection.add(result.getSObject());
             }
            outputResponses.add(output);
        }
    
    return outputResponses;
    }
        
        
    global class Input {
        @InvocableVariable(description='Collection to recalculate' required=true)
        global List<sObject> inputCollection;       
    }
        
    global class Output {
        @InvocableVariable(description='List of records refreshed from query.')
        global List<sobject> refreshedCollection;
    }

}