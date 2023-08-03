/**
 * 
 * By:      Eric Smith
 * Date:    07/24/23
 * Version: 1.0.0
 * 
 * LWC:         collectionCalculate
 * Controller:  CollectionCalculateController, CollectionCalculateControllerTest
 * Action:      CollectionCalculate
 *              Collection Processors (https://unofficialsf.com/list-actions-for-flow/)
 *       
**/

// Code commented this way is a standard part of the template and should stay as is
// * Code commented this way should be adjusted to fit your use case

// * Give the class a name similar to the invocable action
public with sharing class CollectionCalculateController {

    // * Define each of the attributes to be returned by the invocable action and then passed back to the calling LWC
    public class ReturnResultsWrapper {  
        Integer outputDecimalResult;
        String outputStringResult;      
    }

    @AuraEnabled
    // * Give the method a name similar to the invocable action
    public static String collectionCalculate(
        // * Define each of the arguments to be passed into this controller by the LWC and then directly on to the invocable action
        List<SObject> inputCollection,
        String fieldName,
        String operation,
        String policyForNullAndEmptyFields
    ) {

        // Initialize the return results object
        ReturnResultsWrapper curRR = new ReturnResultsWrapper();

        // * Set the 2nd argument to the name of the Invocable Apex Action
        Invocable.Action action = Invocable.Action.createCustomAction('apex', 'CollectionCalculate');

        // * For each of the action's input attributes (Request), set the 1st argument  to the name of the InvocableVariable
        // * and the 2nd argument to the corresponding value passed into this controller
        action.setInvocationParameter('inputCollection', inputCollection); 
        action.setInvocationParameter('fieldName', fieldName);
        action.setInvocationParameter('operation', operation);
        action.setInvocationParameter('policyForNullAndEmptyFields', policyForNullAndEmptyFields); 

        // Invoke the action
        List<Invocable.Action.Result> results = action.invoke();

        // If a result was returned ...
        if (results.size() > 0 && results[0].isSuccess()) { 
            
            // * Assign each of the returned attributes to the corresponding value in the ReturnResultsWrapper
            curRR.outputDecimalResult = objToInteger(results[0].getOutputParameters().get('outputDecimalResult'));
            curRR.outputStringResult = objToString(results[0].getOutputParameters().get('outputStringResult'));
            
        }
        // Return the results wrapper to the calling LWC
        return JSON.serialize(curRR);

    }

    // Convert an object to a list of strings
    private static List<String> objToList(Object obj) {
        return (List<String>) JSON.deserialize(JSON.serialize(obj), List<String>.class);
    } 

    // Convert an object to a String
    private static String objToString(Object obj) {  
        return String.valueof(obj);
    }

    // Convert an object to an integer
    private static Integer objToInteger(Object obj) {
        return Integer.valueof(obj);
    }

}