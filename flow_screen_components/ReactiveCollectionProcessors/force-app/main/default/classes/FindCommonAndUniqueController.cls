/**
 * 
 * By:      Eric Smith
 * Date:    10/04/23
 * Version: 1.0.0
 * 
 * LWC:         findCommonAndUnique
 * Controller:  FindCommonAndUniqueController, FindCommonAndUniqueControllerTest
 * Action:      FindCommonAndUniqueRecords
 *              Collection Processors (https://unofficialsf.com/list-actions-for-flow/)
 *       
**/

// Code commented this way is a standard part of the template and should stay as is
// * Code commented this way should be adjusted to fit your use case

// * Give the class a name similar to the invocable action
public with sharing class FindCommonAndUniqueController {

        // * Define each of the attributes to be returned by the invocable action and then passed back to the calling LWC
        public class ReturnResultsWrapper {  
            List<SObject> sourceUniqueRecordCollection; 
            List<SObject> sourceCommonRecordCollection; 
            List<SObject> targetUniqueRecordCollection; 
            List<SObject> targetCommonRecordCollection;     
        }
    
        @AuraEnabled
        // * Give the method a name similar to the invocable action
        public static String findCommonAndUnique(
            // * Define each of the arguments to be passed into this controller by the LWC and then directly on to the invocable action
            List<SObject> sourceRecordCollection,
            String sourceUniqueID,
            List<SObject> targetRecordCollection,
            String targetUniqueID,
            Boolean emptyListsReturnNull
        ) {
    
            // Initialize the return results object
            ReturnResultsWrapper curRR = new ReturnResultsWrapper();
    
            // * Set the 2nd argument to the name of the Invocable Apex Action
            Invocable.Action action = Invocable.Action.createCustomAction('apex', 'FindCommonAndUniqueRecords');
    
            // * For each of the action's input attributes (Request), set the 1st argument  to the name of the InvocableVariable
            // * and the 2nd argument to the corresponding value passed into this controller
            action.setInvocationParameter('sourceRecordCollection', sourceRecordCollection); 
            action.setInvocationParameter('sourceUniqueID', sourceUniqueID); 
            action.setInvocationParameter('targetRecordCollection', targetRecordCollection); 
            action.setInvocationParameter('targetUniqueID', targetUniqueID); 
            action.setInvocationParameter('emptyListsReturnNull', emptyListsReturnNull); 

            // Invoke the action
            List<Invocable.Action.Result> results = action.invoke();
    
            // If a result was returned ...
            if (results.size() > 0 && results[0].isSuccess()) { 
                
                // * Assign each of the returned attributes to the corresponding value in the ReturnResultsWrapper
                curRR.sourceCommonRecordCollection = objToObj(results[0].getOutputParameters().get('sourceCommonRecordCollection'));
                curRR.targetCommonRecordCollection = objToObj(results[0].getOutputParameters().get('targetCommonRecordCollection'));
                curRR.sourceUniqueRecordCollection = objToObj(results[0].getOutputParameters().get('sourceUniqueRecordCollection'));
                curRR.targetUniqueRecordCollection = objToObj(results[0].getOutputParameters().get('targetUniqueRecordCollection'));
                
            }
            // Return the results wrapper to the calling LWC
            return JSON.serialize(curRR);
    
        }
    
        // Convert an object to a list of objects
        private static List<SObject> objToObj(Object obj) {
            return (List<SObject>) JSON.deserialize(JSON.serialize(obj), List<SObject>.class);
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