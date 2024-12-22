/** 
 *  Get Index from Key - Flow Action
 * 
 *  Eric Smith - 11/26/24 - v1.0
 * 
 *  This class is a Collection Utility designed to find the index of a record in a collection of records based on the value of a field 
 *  
 *  It takes for input a record collection, the API name of a field and the target value of that field.
 * 
 *  It will then loop through the collection and compare the field value to the target value. If the field value matches the target value, 
 *  the index of that record is returned.  If a matching record is not found, an index value of -1 will be returned.
 * 
 *  The primary use case for this action is to find the index of a record based on the value of a key field so it can be used in
 *  other collecion actions that require an index value such as Add or Insert Record or Remove Recod from Collection.
 * 
 *  Release Notes: 
 *  v1.0.0 - 11/26/24 - Initial Version 
 *  v1.0.1 - 11/27/24 - Allow Field API value to be null
 *
**/ 

global inherited sharing class GetIndexFromKey {
    
    // Attributes passed in from the Flow
    global class Requests {

        @InvocableVariable(label='Input Collection' required=true)
        global List<SObject> inputCollection;

        @InvocableVariable(label='Field API Name')
        global String fieldAPIName;

        @InvocableVariable(label='Field API Value')
        global String fieldValue;

    }

    // Attributes passed back to the Flow
    global class Results {

        @InvocableVariable(label='Index')
        global Integer index;

    }

    // Standard Exception Handling
    global class InvocableActionException extends Exception {}

    // Expose this Action to the Flow
    @InvocableMethod(label='Get Index from Keyfield Value [USF Collection Processor]' category='Util' iconName='resource:CollectionProcessorsSVG:colproc')
    global static List<Results> getIndexFromKey(List<Requests> requestList) {
        
        // Prepare the response to send back to the Flow
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();
        
        // Bulkify proccessing of multiple requests
        for (Requests curRequest : requestList) {

            // Get Input Value(s)
            List<SObject> inputCollection = curRequest.inputCollection;
            String fieldAPIName  = curRequest.fieldAPIName;
            Object fieldValue = curRequest.fieldValue;

            // Process input attributes
            if (fieldAPIName == '' || fieldAPIName == null) {
                fieldAPIName = 'Id';
            }

            // Define working variables
            Integer index = -1;
            Integer counter = 0;

            // Start processing
            for (SObject record: inputCollection) {
                if (record.get(fieldAPIName)?.toString() == fieldValue) {
                    index = counter;
                    break;
                }
                counter++;
            }

            // Set Output Values
            response.index = counter;
            responseWrapper.add(response);
        }

        // Return values back to the Flow
        return responseWrapper;
    }

}