/**
 * Call an Invocable Action from a Reactive Flow Screen Component
 * 
 * Sample Controller with an AuraEnabled class, that calls an Invocable Flow Action, designed to be called by an LWC that is 
 * exposed to flow as a reactive Flow Screen Component
 * 
 * Created By:  Eric Smith
 * 
 *              07/21/23    Version: 1.0.0  Initial Release
 *              10/15/23    Version: 1.0.1  Updated with date format fix
 * 
 * LWC:         extractFieldToCollection
 * Controller:  ExtractFieldToCollectionController, ExtractFieldToCollectionControllerTest
 * Action:      ExtractStringsFromCollection
 *              Collection Processors (https://unofficialsf.com/list-actions-for-flow/)
 *       
**/

// Code commented this way is a standard part of the template and should stay as is
// * Code commented this way should be adjusted to fit your use case

public with sharing class ExtractFieldToCollectionController {                                                      // * Give the class a name similar to the invocable action

    public class ReturnResultsWrapper {                                                                             // Inside of the wrapper, 
        List<String> fieldValueCollection;                                                                          // * define each of the attributes to be returned by the invocable action
        String fieldValueString;                                                                                    // * and then passed back to the calling LWC
    }

    @AuraEnabled
    public static String extractFieldToCollection(                                                                  // * Give the method a name similar to the invocable action
        List<SObject> inputRecordCollection,                                                                        // * Define each of the arguments to be passed into this controller by the LWC
        String fieldAPIName,                                                                                        // * and then directly on to the invocable action
        Boolean dedupeValues,                                                                                       // * 
        Boolean allowEmptyCollection                                                                                // * 
    ) {

        ReturnResultsWrapper curRR = new ReturnResultsWrapper();                                                    // Initialize the return results object

        Invocable.Action action = Invocable.Action.createCustomAction('apex', 'ExtractStringsFromCollection');      // * Set the 2nd argument to the name of the Invocable Apex Action

        action.setInvocationParameter('inputRecordCollection', inputRecordCollection);                              // * For each of the action's input attributes (Request), set the 1st argument    
        action.setInvocationParameter('fieldAPIName', fieldAPIName);                                                // * to the name of the InvocableVariable and the 2nd argument to the corresponding
        action.setInvocationParameter('dedupeValues', dedupeValues);                                                // * value passed into this controller
        action.setInvocationParameter('allowEmptyCollection', allowEmptyCollection);                                // * 

        List<Invocable.Action.Result> results = action.invoke();                                                    // Invoke the action
        if (results.size() > 0 && results[0].isSuccess()) {                                                         // If a result was returned ...
        
            curRR.fieldValueCollection = objToList(results[0].getOutputParameters().get('fieldValueCollection'));   // * Assign each of the returned attributes to the corresponding value 
            curRR.fieldValueString = objToString(results[0].getOutputParameters().get('fieldValueString'));         // * in the ReturnResultsWrapper
        }
        return JSON.serialize(curRR);                                                                               // Return the results wrapper to the calling LWC

    }

    private static List<SObject> objToObj(Object obj) {                                                             // Convert an object to a list of objects and fix date format
        return (List<SObject>) JSON.deserialize(JSON.serialize(obj).replace('+0000','Z'), List<SObject>.class); 
    } 

    private static List<String> objToList(Object obj) {                                                             // Convert an object to a list of strings
        return (List<String>) JSON.deserialize(JSON.serialize(obj), List<String>.class);
    } 

    private static String objToString(Object obj) {                                                                 // Convert an object to a string
        return String.valueof(obj);
    }

    private static Integer objToInteger(Object obj) {                                                               // Convert an object to an integer
        return Integer.valueof(obj);
    }

}