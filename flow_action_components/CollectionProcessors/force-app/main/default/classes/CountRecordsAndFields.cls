
global with sharing class CountRecordsAndFields {
    @InvocableMethod
    global static List <Results> count(List<Requests> requestList) {

        List<SObject> records = requestList[0].inputCollection;
        String fieldName = requestList[0].fieldName;
        String fieldValue = requestList[0].fieldValue;

        //Create a Results object to hold the return values
        Results response = new Results();
        try {
            for (SObject record : records) {
                if (!String.isBlank(fieldName) && !String.isBlank(fieldValue)) {
                    if (record.get(fieldName) == fieldValue) {
                        response.matchedNumber++;
                    }
                }

                response.totalNumber++;
            }
        } catch (Exception ex) {
            response.errors = ex.getMessage();
        }

//Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;

    }

    global class Requests {
        @InvocableVariable(required=true)
        global List<SObject> inputCollection;
        @InvocableVariable(required=true)
        global String fieldName;
        @InvocableVariable(required=true)
        global String fieldValue;
    }

    global class Results {
        public Results() {
            this.errors = '';
            this.matchedNumber = 0;
            this.totalNumber = 0;
        }
        @InvocableVariable
        global Integer matchedNumber;
        @InvocableVariable
        global Integer totalNumber;
        @InvocableVariable
        global String errors;
    }
}
