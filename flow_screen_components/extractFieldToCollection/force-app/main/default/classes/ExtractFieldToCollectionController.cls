public with sharing class ExtractFieldToCollectionController {

    public class ReturnResultsWrapper {                                                                             // Inside of the wrapper, define each of the attributes to be returned by
        List<String> fieldValueCollection;                                                                          // the invocable action and then passed back to the calling LWC
        String fieldValueString;                                                                                    // 
    }

    @AuraEnabled
    public static String extractFieldToCollection(
        List<SObject> inputRecordCollection,                                                                        // Define each of the arguments to be passed into this controller by the LWC
        String fieldAPIName,                                                                                        // and then directly on to the invocable action
        Boolean dedupeValues,                                                                                       //
        Boolean allowEmptyCollection                                                                                //
    ) {

        ReturnResultsWrapper curRR = new ReturnResultsWrapper();                                                    // Initialize the return results object

        Invocable.Action action = Invocable.Action.createCustomAction('apex', 'ExtractStringsFromCollection');      // Set the 2nd argument to the name of the Invocable Apex Action

        action.setInvocationParameter('inputRecordCollection', inputRecordCollection);                              // For each of the action's input attributes (Request), set the 1st argument    
        action.setInvocationParameter('fieldAPIName', fieldAPIName);                                                // to the name of the InvocableVariable and the 2nd argument to the corresponding
        action.setInvocationParameter('dedupeValues', dedupeValues);                                                // value passed into this controller
        action.setInvocationParameter('allowEmptyCollection', allowEmptyCollection);                                // 

        List<Invocable.Action.Result> results = action.invoke();                                                    // Invoke the action

        if (results.size() > 0 && results[0].isSuccess()) {                                                         // If a result was returned ...
        
            curRR.fieldValueCollection = results[0].getOutputParameters().get('fieldValueCollection');              // Assign each of the returned attributes to the corresponding ReturnResultsWrapper
            curRR.fieldValueString = String.valueof(results[0].getOutputParameters().get('fieldValueString'));      // 

        }

        return JSON.serialize(curRR);                                                                               // Return the results wrapper to the calling LWC

    }

}