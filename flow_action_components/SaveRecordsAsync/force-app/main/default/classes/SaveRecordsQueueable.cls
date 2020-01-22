/* 
 *  Description: An InvocableMethod wrapped in a Queueable class to allow for asynchronous saving of generic SObject records from Flow.
 *  Author: (github) davidentremont
 *  Date 2020-01-22
 */
global with sharing class SaveRecordsQueueable implements Queueable {
    
    // Local variables
    private List<SObject> records = new List<SObject>(); // The collection to be saved

    // Constructor for Queuebale interface
    private SaveRecordsQueueable(List<SObject> records) {
        // Assign contructor param to local variable
        this.records = records;

        // TODO: Maybe check permissions to object, saves async exception handling but adds to loop iterations
        // Schema.sObjectType sobjectType = this.records[0].getSObjectType();
        // Schema.DescribeSObjectResult describe = sobjectType.getDescribe();
        
        // Check collection size doesn't exceed limit
        if(this.records.size() > Limits.getLimitDMLRows()) {
            throw new SaveRecordsQueueableException(
                String.format(
                    'The number of records to be saved [{0}] is larger than the limit allowed [{1}].', 
                    new List<Object>{this.records.size(), Limits.getLimitDMLRows()}
                )
            );
        }
    }

    // Primary execution method for Queueable
    global void execute(QueueableContext context) {
        // Get generic type information to support generic upsert
        Schema.sObjectType typeName = this.records[0].getSObjectType();
        Type listType = Type.forName('List<' + typeName + '>');
        
    }

    /* 
     *  Description: Method to be called by Flow action to save records in a Queueable context.
     *  @param: List<Request>, A Request class object populated from Flow inputs and containing data to be saved
     *  @return: List<Result>, A Result class object used to return result of the request being validated and the job being queued 
     */
    @InvocableMethod(label='Save Records Later' description='Upserts a collection of records asynchronously. Returns an Apex JobId to track status of the request.')
    global static List<Results> saveRecordsQueueable(List<Requests> requests) {
        Results result;

        try {
            SaveRecordsQueueable job = new SaveRecordsQueueable(requests[0].inputCollection);
        	Id jobId = System.enqueueJob(job);

            // Create result object with success
            result = new Results(jobId);
        } catch(Exception e) {
            // Create new result object with error
            result = new Results(e.getMessage());
        }
        
        return new List<Results>{result};
    }

    global class Requests {
        @InvocableVariable(required=true)
        global List<SObject> inputCollection;
    }

    global class Results {
        @InvocableVariable
        global Boolean success;

        @InvocableVariable
        global String message;

        @InvocableVariable
        global Id jobId;

        public Results(Id jobId) {
            this.success = true;
            this.message = 'Successfully enqueued job';
            this.jobId = jobId;
        }

        public Results(String error) {
            this.success = false;
            this.message = error;
        }
    }
    
    global class SaveRecordsQueueableException extends Exception {}
}