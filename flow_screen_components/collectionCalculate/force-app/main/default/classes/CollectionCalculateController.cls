/**
 * 
 * By:      Eric Smith
 * Date:    07/24/23
 * Version: 1.0.0
 * 
 * LWC:         collectionCalculate
 * Controller:  collectionCalculateController
 * Action:      CollectionCalculate
 *              Collection Processors (https://unofficialsf.com/list-actions-for-flow/)
 *       
**/

public with sharing class CollectionCalculateController {

    public class ReturnResultsWrapper {  
        Decimal outputDecimalResult;
        String outputStringResult;      
    }

    @AuraEnabled
    public static String collectionCalculate(
        List<SObject> inputCollection,
        String fieldName,
        String operation,
        String policyForNullAndEmptyFields
    ) {

        ReturnResultsWrapper curRR = new ReturnResultsWrapper();

        Invocable.Action action = Invocable.Action.createCustomAction('apex', 'CollectionCalculate');

        action.setInvocationParameter('inputRecordCollection', inputCollection); 
        action.setInvocationParameter('fieldAPIName', fieldName);
        action.setInvocationParameter('dedupeValues', operation);
        action.setInvocationParameter('allowEmptyCollection', policyForNullAndEmptyFields); 

        List<Invocable.Action.Result> results = action.invoke();
        if (results.size() > 0 && results[0].isSuccess()) { 
            curRR.outputDecimalResult = objToInteger(results[0].getOutputParameters().get('outputDecimalResult'));
            curRR.outputStringResult = objToString(results[0].getOutputParameters().get('outputStringResult'));
        }
        return JSON.serialize(curRR);

    }

    private static List<String> objToList(Object obj) {                                                             // Convert an object to a list of strings
        return (List<String>) JSON.deserialize(JSON.serialize(obj), List<String>.class);
    } 

    private static String objToString(Object obj) {                                                                 // Convert an object to a string
        return String.valueof(obj);
    }

    private static Integer objToInteger(Object obj) {                                                                // Convert an object to an integer
        return Integer.valueof(obj);
    }

}