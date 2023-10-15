/**
 * Call an Invocable Action from a Reactive Flow Screen Component
 * 
 * Sample Controller with an AuraEnabled class, that calls an Invocable Flow Action, designed to be called by an LWC that is 
 * exposed to flow as a reactive Flow Screen Component
 * 
 * Created By:  Eric Smith
 * 
 *              10/03/23    Version: 1.0.1  Initial Release
 * 
 * LWC:         joinCollections
 * Controller:  JoinCollectionsCalculateController, JoinCollectionsCalculateControllerTest
 * Action:      JoinCollectionsCalculate
 *              Collection Processors (https://unofficialsf.com/list-actions-for-flow/)
 *       
**/

// Code commented this way is a standard part of the template and should stay as is
// * Code commented this way should be adjusted to fit your use case

// * Give the class a name similar to the invocable action
public with sharing class JoinCollectionsController {
    
    // * Define each of the attributes to be returned by the invocable action and then passed back to the calling LWC
    public class ReturnResultsWrapper {  
        List<SObject> outputCollection;     
    }

    @AuraEnabled
    // * Give the method a name similar to the invocable action
    public static String joinCollections(
        // * Define each of the arguments to be passed into this controller by the LWC and then directly on to the invocable action
        List<SObject> inputCollection,
        List<SObject> inputCollection2
    ) {

        // Initialize the return results object
        ReturnResultsWrapper curRR = new ReturnResultsWrapper();

        // * Set the 2nd argument to the name of the Invocable Apex Action
        Invocable.Action action = Invocable.Action.createCustomAction('apex', 'JoinCollections');

        // * For each of the action's input attributes (Request), set the 1st argument  to the name of the InvocableVariable
        // * and the 2nd argument to the corresponding value passed into this controller
        action.setInvocationParameter('inputCollection', inputCollection); 
        action.setInvocationParameter('inputCollection2', inputCollection2); 

        // Invoke the action
        List<Invocable.Action.Result> results = action.invoke();

        // If a result was returned ...
        if (results.size() > 0 && results[0].isSuccess()) { 
            
            // * Assign each of the returned attributes to the corresponding value in the ReturnResultsWrapper
            curRR.outputCollection = objToObj(results[0].getOutputParameters().get('outputCollection'));
            
        }
        // Return the results wrapper to the calling LWC
        return JSON.serialize(curRR);

    }

    // Convert an object to a list of objects and fix date format
    private static List<SObject> objToObj(Object obj) {
        return (List<SObject>) JSON.deserialize(JSON.serialize(obj).replace('+0000','Z'), List<SObject>.class);
    } 

    // Convert an object to a list of strings
    // private static List<String> objToList(Object obj) {
    //     return (List<String>) JSON.deserialize(JSON.serialize(obj), List<String>.class);
    // } 

    // Convert an object to a String
    // private static String objToString(Object obj) {  
    //     return String.valueof(obj);
    // }

    // Convert an object to an integer
    // private static Integer objToInteger(Object obj) {
    //     return Integer.valueof(obj);
    // }

}