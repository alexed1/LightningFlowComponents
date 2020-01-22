/* 
 *  Description: An InvocableMethod wrapped in a Queueable class to allow for asynchronous saving of generic SObject records from Flow.
 *  Author: (github) davidentremont
 *  Date 2020-01-22
 */
public with sharing class SaveRecordsQueueable implements Queueable {
    
    // Local variables
    private List<SObject> records = new List<SObject>(); // The collection to be saved

    // Constructor for Queuebale interface
    private SaveRecordsQueueable(List<SObject> records) {
        // Assign contructor param to local variable
        this.records = records;

        // TODO: Maybe check permissions to object, saves async exception handling
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
    public void execute(QueueableContext context) {
        
    }

    /* 
     *  Description: Method to be called by Flow action to save records in a Queueable context.
     *  @param: List<Request>, A Request class object populated from Flow inputs and containing data to be saved
     *  @return: List<Result>, A Result class object used to return result of the request being validated and the job being queued 
     */
    @InvocableMethod(label='Save Records Later' description='Upserts a collection of records asynchronously. Returns an Apex JobId to track status of the request.')
    public static List<Results> saveRecordsQueueable(List<Requests> requests) {
        return null;
    }

    public class Requests {
        @InvocableVariable(required=true)
        public List<SObject> inputCollection;
    }

    public class Results {
        @InvocableVariable
        public Boolean success;

        @InvocableVariable
        public String message;
    }
    
    // Custom exception class for local exceptions
    public class SaveRecordsQueueableException extends Exception {}
}
