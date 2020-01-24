@IsTest
private class SaveRecordsQueueableTest {
    
    @IsTest 
    private static void positiveInsertCollection() {
        // Create test account records
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < Limits.getLimitDMLRows(); i++) {
            accounts.add(new Account(Name = 'Account #' + i));
        }

        // Create request with accounts
        SaveRecordsQueueable.Requests request = new SaveRecordsQueueable.Requests();
        request.inputCollection = accounts;

        // Store result outside test context
        List<SaveRecordsQueueable.Results> result;

        Test.startTest();
            // Invoke 
            result = SaveRecordsQueueable.createJob(new List<SaveRecordsQueueable.Requests>{request});
        Test.stopTest();

        // Check job was created. No need to check account creation against customer org
        System.assertEquals(true, result[0].success, 'Incorrect success result');
        System.assertEquals('Successfully enqueued job', result[0].message, 'Incorrect result message');
        System.assertEquals(Schema.AsyncApexJob.SObjectType, result[0].jobId.getSobjectType(), 'Job Id not returned');
    }

    @IsTest
    private static void negativeInsertCollectionOversized() {
        // Create test account records, but more than allowed by the governor
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < (Limits.getLimitDMLRows() + 1); i++) {
            accounts.add(new Account(Name = 'Account #' + i));
        }

        // Create request with accounts
        SaveRecordsQueueable.Requests request = new SaveRecordsQueueable.Requests();
        request.inputCollection = accounts;

        // Store result outside test context
        List<SaveRecordsQueueable.Results> result;

        Test.startTest();
            // Invoke 
            result = SaveRecordsQueueable.createJob(new List<SaveRecordsQueueable.Requests>{request});
        Test.stopTest();

        // Check job was created. No need to check account creation against customer org
        System.assertEquals(false, result[0].success, 'Incorrect success result');
        System.assertEquals('The number of records to be saved [' + accounts.size() + '] is larger than the limit allowed [' + Limits.getLimitDMLRows() + '].', result[0].message, 'Incorrect result message');
    }

    @IsTest
    private static void negativeInsertCollectionEmpty() {
        // Pass an empty collection
        List<Account> accounts = new List<Account>();

        // Create request with accounts
        SaveRecordsQueueable.Requests request = new SaveRecordsQueueable.Requests();
        request.inputCollection = accounts;

        // Store result outside test context
        List<SaveRecordsQueueable.Results> result;

        Test.startTest();
            // Invoke 
            result = SaveRecordsQueueable.createJob(new List<SaveRecordsQueueable.Requests>{request});
        Test.stopTest();

        // Check job was created. No need to check account creation against customer org
        System.assertEquals(true, result[0].success, 'Incorrect success result');
        System.assertEquals('The collection provided is empty.', result[0].message, 'Incorrect result message');
        System.assertEquals(null, result[0].jobId, 'Job enqueued');
    }
}