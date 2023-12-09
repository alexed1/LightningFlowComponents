/** 
 *  Check ID Flow Action
 * 
 *  Eric Smith - 4/3/23 - v1.0
 * 
 *  This class is designed to see if the provided text is a valid Salesforce record id based on the first 3 characters provided
 *  
 *  It takes a text input and returns a boolean value for valid id along with the Sobject Type 
 *  At least the first 3 characters of the id are required
 *  
 *  In order for this check to work, any SObject must be selected and any record must be passed in as well
 * 
**/ 

global inherited sharing class ers_CheckId {

    // Attributes passed in from the Flow
    global class Requests {
    
        @InvocableVariable(Label='Record Id')
        global String recordId;

        @InvocableVariable(Label='Dummy Record')
        global SObject dummyRecord;

    }

    // Attributes passed back to the Flow
    global class Results {

        @InvocableVariable 
        global Boolean isRecordId;

        @InvocableVariable
        global String sobjectType;

    }

    // Standard Exception Handling
    global class InvocableActionException extends Exception {}

    // Expose this Action to the Flow
    @InvocableMethod(label='Record Id Check by Eric Smith' iconName='resource:CheckIdSVG:Layer_1')
    global static List<Results> checkId(List<Requests> requestList) {

        // Prepare the response to send back to the Flow
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();

        // Bulkify proccessing of multiple requests
        for (Requests req : requestList) {

            // Get Input Value(s)
            String recordId = String.isEmpty(req.recordId) ? '' : req.recordId;
            SObject dummyRecord = req.dummyRecord;

            // Set initial values
            Boolean isRecordId = false;
            String sobjectType = '';
            Id testId = ((Id) dummyRecord.get('Id'));
            Id saveId = testId;

            // Process input attributes
            
            // Validate input attributes

// BEGIN APEX ACTION PROCESSING LOGIC

            // Define working variables

            // Start processing

            // Check for valid Id
            if (!String.isEmpty(recordId)) {
                try {
                    testId = recordId.rightPad(15,'0').substring(0,15);
                    sobjectType = testId.getSobjectType().getDescribe().getName();
                    isRecordId = true;
                } catch(Exception e) {
                    if (testId != saveId) {
                        String strId = (Id)testId;
                        if (strId?.length() == 18) {    // The pattern matches an id but not one in the running org
                            isRecordId = true;
                            sobjectType = '(unknown)';
                        }
                    }
                }
            }

// END APEX ACTION PROCESSING LOGIC

            // Set Output Values
            response.isRecordId = isRecordId;
            response.sobjectType = sobjectType;
            responseWrapper.add(response);

        }

        // Return values back to the Flow
        return responseWrapper;
    }

}