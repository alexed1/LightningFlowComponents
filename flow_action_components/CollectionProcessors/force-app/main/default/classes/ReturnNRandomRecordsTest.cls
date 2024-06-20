@isTest
private class ReturnNRandomRecordsTest {

    @isTest
    static void testReturnNRandomRecords() {

        // Create test data
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        // Create the input request
        ReturnNRandomRecords.Requests request = new ReturnNRandomRecords.Requests();
        request.inputCollection = accounts;
        request.recordCount = 5;

        // Create a list of requests
        List<ReturnNRandomRecords.Requests> requestList = new List<ReturnNRandomRecords.Requests>();
        requestList.add(request);

        // Call the invocable method
        List<ReturnNRandomRecords.Results> resultsList = ReturnNRandomRecords.returnNRandomRecords(requestList);

        // Validate the results
        System.assertEquals(1, resultsList.size());

        List<Account> outputCollection = (List<Account>) resultsList[0].outputCollection;
        Integer returnCount = resultsList[0].returnCount;

        System.assertEquals(5, outputCollection.size());
        System.assertEquals(5, returnCount);

        for (Account acc : outputCollection) {
            System.assert(acc.Id != null && acc.Id.getSObjectType() == Account.SObjectType);
        }
    }
	
	@isTest
    static void testReturnALLRandomRecords() {

        // Create test data
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        // Create the input request
        ReturnNRandomRecords.Requests request = new ReturnNRandomRecords.Requests();
        request.inputCollection = accounts;
        request.recordCount = 11;

        // Create a list of requests
        List<ReturnNRandomRecords.Requests> requestList = new List<ReturnNRandomRecords.Requests>();
        requestList.add(request);

        // Call the invocable method
        List<ReturnNRandomRecords.Results> resultsList = ReturnNRandomRecords.returnNRandomRecords(requestList);

        // Validate the results
        System.assertEquals(1, resultsList.size());

        List<Account> outputCollection = (List<Account>) resultsList[0].outputCollection;
        Integer returnCount = resultsList[0].returnCount;

        System.assertEquals(10, outputCollection.size());
        System.assertEquals(10, returnCount);

        for (Account acc : outputCollection) {
            System.assert(acc.Id != null && acc.Id.getSObjectType() == Account.SObjectType);
        }
    }

}
