/** 
 *  Return First N Records Flow Action
 * 
 *  This invocable flow action is designed to take a collection of record and a numeric count (N)
 *  and return the first N records from the collection.
 * 
 *  This is useful when you want to programatically decide how many records you need unlike having to provide a fixed value in actions such as the flow Sort element.
 * 
 *  Eric Smith - 4/23/23 - v1.0.0
 *      Initial Release
 * 
 * 
**/ 
global inherited sharing class ReturnFirstNRecords {

    // Attributes passed in from the Flow
    global class Requests {
    
        @InvocableVariable(Label='Input Record Collection')
        global List<SObject> inputCollection;

        @InvocableVariable(Label='Record Count')
        global Integer recordCount;

    }

    // Attributes passed back to the Flow
    global class Results {

        @InvocableVariable(Label='Output Record Collection') 
        global List<SObject> outputCollection;

        @InvocableVariable(Label='Return Count')
        global Integer returnCount;

    }

    // Standard Exception Handling
    global class InvocableActionException extends Exception {}

    // Expose this Action to the Flow
    @InvocableMethod(label='Return First N Records by Eric Smith [USF Collection Processor]' category='Util' iconName='resource:CollectionProcessorsSVG:colproc')
    global static List<Results> returnNRecords(List<Requests> requestList) {

        // Prepare the response to send back to the Flow
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();

        // Bulkify proccessing of multiple requests
        for (Requests req : requestList) {

            // Get Input Value(s)
            List<SObject> inputCollection = req.inputCollection;
            Integer recordCount = req.recordCount;

            // Set initial values
            List<SObject> outputCollection = new List<SObject>();
            Integer returnCount = 0;

            // Process input attributes
            
            // Validate input attributes

// BEGIN APEX ACTION PROCESSING LOGIC

            // Define working variables

            // Start processing
            if (inputCollection != null && inputCollection.size() != 0) {
                if(inputCollection.size() <= recordCount) {
                    outputCollection = inputCollection;
                    returnCount = outputCollection.size();
                } else {
                    while(returnCount<recordCount) {
                        outputCollection.add(inputCollection[returnCount++]);
                    }
                }
            }


// END APEX ACTION PROCESSING LOGIC

            // Set Output Values
            response.outputCollection = outputCollection;
            response.returnCount = returnCount;
            responseWrapper.add(response);

        }

        // Return values back to the Flow
        return responseWrapper;
    }

}