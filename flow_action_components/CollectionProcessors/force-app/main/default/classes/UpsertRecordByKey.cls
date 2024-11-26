/** 
 *  Upsert Record by Key - Flow Action
 * 
 *  Eric Smith - 11/26/24 - v1.0
 * 
 *  This class is a Collection Utility designed to upsert a record into a collection of records based on the value of a field in the source record.
 *  
 *  It takes for input a record collection, a single record and the API name of a key field.
 * 
 *  If it finds a matching record in the collection based on the value of the key field, it will replace that record in the collection.
 *  If a matching record is not found,the record will be added to the collection.
 * 
 *  The primary use case for this action is to update a record collection in a flow prior to saving the changes to the database.
 * 
**/ 

global inherited sharing class UpsertRecordByKey {

    // Attributes passed in from the Flow
    global class Requests {

        @InvocableVariable(label='Origginal record collection' required=true)
        global List<SObject> inputCollection;

        @InvocableVariable(label='New or replacement record' required=true)
        global SObject inputRecord;

        @InvocableVariable(label='API name of keyfield (Default = Id)')
        global String fieldAPIName;

    }

    // Attributes passed back to the Flow
    global class Results {

        @InvocableVariable(Label='Collection with upserted record')
        global List<SObject> outputCollection;

    }

    // Standard Exception Handling
    global class InvocableActionException extends Exception {}

    // Expose this Action to the Flow
    @InvocableMethod(label='Upsert Record by Key [USF Collection Processor]' category='Util' iconName='resource:CollectionProcessorsSVG:colproc')
    global static List <Results> upsertRecordByKey(List<Requests> requestList) {

        // Prepare the response to send back to the Flow
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();

        // Bulkify proccessing of multiple requests
        for (Requests curRequest : requestList) {
            
            // Get Input Value(s)
            List<SObject> inputCollection = curRequest.inputCollection;
            SObject inputRecord = curRequest.inputRecord;
            String fieldAPIName  = curRequest.fieldAPIName;

            // Process input attributes
            if (fieldAPIName == '' || fieldAPIName == null) {
                fieldAPIName = 'Id';
            }
            String fieldValue = inputRecord.get(fieldAPIName)?.toString();

            // Set initial values
            getIndexResults idx = new getIndexResults();

            // Start processing
            idx = getIndexFromKey(inputCollection, fieldAPIName, fieldValue);
            Integer index = idx.index;

            if (inputCollection != null && inputRecord != null) {
                if (index == -1 || index == null || index >= inputCollection.size()) {
                    inputCollection.add(inputRecord);
                } else {
                    inputCollection.remove(index);
                    inputCollection.add(index, inputRecord);
                }

                // Set Output Values
                response.outputCollection = inputCollection.clone();
            }

            responseWrapper.add(response);

        }

        // Return values back to the Flow
        return responseWrapper;
    }

    public class getIndexResults {
        Integer index;
    }

    public static getIndexResults getIndexFromKey(List<SObject> inputCollection, String fieldAPIName, String fieldValue) {
    
        Invocable.Action indexAction = Invocable.Action.createCustomAction('apex', 'GetIndexFromKey');

        indexAction.setInvocationParameter('inputCollection', inputCollection);
        indexAction.setInvocationParameter('fieldAPIName', fieldAPIName);
        indexAction.setInvocationParameter('fieldValue', fieldValue);

        List<Invocable.Action.Result> results = indexAction.invoke();  
        System.debug('results: '+results);

        getIndexResults gir = new getIndexResults();

        gir.index = -1;
        if (results.size() > 0 && results[0].isSuccess()) {
            gir.index = Integer.valueOf(results[0].getOutputParameters().get('index'));
        }
        System.debug('gir.index: '+gir.index);

        return gir;
    }

    // Convert an object to an integer
    // private static Integer objToInteger(Object obj) {
    //     return Integer.valueof(obj);
    // }

}