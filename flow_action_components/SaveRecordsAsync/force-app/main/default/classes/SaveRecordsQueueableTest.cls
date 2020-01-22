@IsTest
private class SaveRecordsQueueableTest {
    
    @IsTest 
    private static void positiveInsertCollection() {
        // Create test account records
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 10000; i++) {
            accounts.add(new Account(Name = 'Account #' + i));
        }

        // Create request with accounts
        SaveRecordsQueueable.Requests request = new SaveRecordsQueueable.Requests();
        request.inputCollection = accounts;

        // Store result outside test context
        List<SaveRecordsQueueable.Results> result;

        Test.startTest();
            // Invoke 
            result = SaveRecordsQueueable.saveRecordsQueueable(new List<SaveRecordsQueueable.Requests>{request});
        Test.stopTest();

        // Check job was created. No need to check account creation against customer org
        System.assertEquals(true, result[0].success, 'Job failed to enqueue');
        System.assertEquals('Successfully enqueued job', result[0].message, 'Success result message incorrect.');
        System.assertEquals(Schema.AsyncApexJob.SObjectType, result[0].jobId.getSobjectType());
    }

    @IsTest
    private static void negativeInsertCollection() {

    }
}
