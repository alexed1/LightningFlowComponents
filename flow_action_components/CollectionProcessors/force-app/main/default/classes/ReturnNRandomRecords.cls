/** 
 *  Return N Random Records Flow Action
 * 
 *  This invocable flow action is designed to take a collection of records and a numeric count (N)
 *  and return the N records randomly selected from the collection.
 * 
 *  Flow has no built-in random number generator, and getting the Nth record from a collection is not easy.
 * 
 *  Derek Camp - 9/5/23 - v1.0.0
 *      Initial Release
 * 
 *  Eric Smith - 3/18/24 - v1.0.1
 *      Fix intermittant test class bug (index out of bounds)
 *      Available in Collection Processor package v3.2.2 and later
 * 
**/ 
global inherited sharing class ReturnNRandomRecords {

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
    @InvocableMethod(label='Return N Random Records' category='Util' iconName='resource:CollectionProcessorsSVG:colproc')
    global static List<Results> returnNRandomRecords(List<Requests> requestList) {

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

// BEGIN APEX ACTION PROCESSING LOGIC

            // Capture a list of random numbers that will be our collection indices
            List<Integer> randomNumbers = new List<Integer>();

            // Start processing
            if (inputCollection != null && inputCollection.size() != 0 && recordCount != null && recordCount > 0) {
                if(inputCollection.size() <= recordCount) {
                    // our collection is less than or equal to the number of records requested
                    // return the whole collection
                    outputCollection = inputCollection;
					returnCount = outputCollection.size();
                } else {
                    // Generate a list of random numbers
                    while (randomNumbers.size() < recordCount) {
                        Integer randomNumber = (Integer)Math.round(Math.random() * (inputCollection.size()-1));
                        if( !randomNumbers.contains(randomNumber) ) {
                            randomNumbers.add(randomNumber);
                        }
                    }
                    
					// loop over the random numbers and use them as an index to access a record from input collection
                    for (Integer i = 0; i < randomNumbers.size(); i++) {
                        outputCollection.add(inputCollection[randomNumbers[i]]);
						returnCount++;
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