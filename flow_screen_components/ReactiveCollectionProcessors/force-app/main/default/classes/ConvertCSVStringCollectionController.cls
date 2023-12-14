/**
 * Call an Invocable Action from a Reactive Flow Screen Component
 * 
 * Sample Controller with an AuraEnabled class, that calls an Invocable Flow Action, designed to be called by an LWC that is 
 * exposed to flow as a reactive Flow Screen Component
 * 
 * Created By:  Eric Smith
 * 
 *              12/12/23    Version: 1.0.2  Initial Release
 * 
 * LWC:         convertCSVStringCollection_rsc
 * Controller:  ConvertCSVStringCollectionController, ConvertCSVStringCollectionControllerTest
 * Actions:     ConvertCSVToStringCollection, ConvertStringCollectionToCSV
 * Original:    Convert Strings to String Collections, and Vice Versa (https://unofficialsf.com/new-flow-actions-to-convert-csv-strings-to-string-collections-and-vice-versa/)
 *              Requires v1.3 or later
**/

// Code commented this way is a standard part of the template and should stay as is
// * Code commented this way should be adjusted to fit your use case

// * Give the class a name similar to the invocable action
public with sharing class ConvertCSVStringCollectionController {
    
    // * Define each of the attributes to be returned by the invocable action and then passed back to the calling LWC
    public class ReturnResultsWrapper {  
        List<String> stringCollectionOut;   // String to Collection
        String csvStringOut;                // Collection to String    
    }

    @AuraEnabled
    // * Give the method a name similar to the invocable action
    public static String convertCSVCollection(
        // * Define each of the arguments to be passed into this controller by the LWC and then directly on to the invocable action
        String csvStringIn,                 // String to Collection
        List<String> stringCollectionIn,    // Collection to String 
        String delimiter                    // Used for both
    ) {

        // Initialize the return results object
        ReturnResultsWrapper curRR = new ReturnResultsWrapper();

        // * Set the 2nd argument to the name of the Invocable Apex Action
        // String to Collection
        Invocable.Action action1 = Invocable.Action.createCustomAction('apex', 'ConvertCSVToStringCollection_CP');
        // Collection to String 
        Invocable.Action action2 = Invocable.Action.createCustomAction('apex', 'ConvertStringCollectionToCSV_CP');
        
        // * For each of the action's input attributes (Request), set the 1st argument  to the name of the InvocableVariable
        // * and the 2nd argument to the corresponding value passed into this controller
        // String to Collection
        action1.setInvocationParameter('delimiter', delimiter);
        action1.setInvocationParameter('csvString', csvStringIn); 
        // Collection to String 
        action2.setInvocationParameter('delimiter', delimiter);
        action2.setInvocationParameter('stringCollection', stringCollectionIn); 

        // Invoke the action
        List<Invocable.Action.Result> results1 = action1.invoke();  // String to Collection
        List<Invocable.Action.Result> results2 = action2.invoke();  // Collection to String      

        // * Clear prior results
        curRR.stringCollectionOut = New List<String>();
        curRR.csvStringOut = '';

        // If a result was returned ...
        if (results1.size() > 0 && results1[0].isSuccess()) {   // String to Collection 
            // * Assign each of the returned attributes to the corresponding value in the ReturnResultsWrapper
            curRR.stringCollectionOut = objToList(results1[0].getOutputParameters().get('stringCollection'));
        }
        if (results2.size() > 0 && results2[0].isSuccess()) {   // Collection to String 
            // * Assign each of the returned attributes to the corresponding value in the ReturnResultsWrapper
            curRR.csvStringOut = objToString(results2[0].getOutputParameters().get('csvString'));
        }

        // Return the results wrapper to the calling LWC
        return JSON.serialize(curRR);

    }

    // Convert an object to a list of objects and fix date format
    // private static List<SObject> objToObj(Object obj) {
    //     return (List<SObject>) JSON.deserialize(JSON.serialize(obj).replace('+0000','Z'), List<SObject>.class);
    // } 

    // Convert an object to a list of strings
    private static List<String> objToList(Object obj) {
        return (List<String>) JSON.deserialize(JSON.serialize(obj), List<String>.class);
    } 

    // Convert an object to a String
    private static String objToString(Object obj) {  
        return String.valueof(obj);
    }

    // Convert an object to an integer
    // private static Integer objToInteger(Object obj) {
    //     return Integer.valueof(obj);
    // }

}