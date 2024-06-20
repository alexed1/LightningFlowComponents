@isTest
private class InvocableCheckLimitTest {
    @isTest
    static void testInvokeMethod() {
        // Create a list of requests for all limit types handled by the service
        List<InvocableCheckLimit.Request> requests = new List<InvocableCheckLimit.Request>();

        // Add a request for each limit type
        List<String> limitNames = new List<String>{
            'aggregatequeries', 'asynccalls', 'callouts', 'cputime', 'dmlrows',
            'dmlstatements', 'emailinvocations', 'futurecalls', 'heapsize',
            'mobilepushapexcalls', 'publishimmediatedml', 'queries', 'queryrows',
            'queueablejobs', 'soslqueries', 'querylocatorrows'
            // ... add other limit types as necessary
        };

        for (String limitName : limitNames) {
            InvocableCheckLimit.Request req = new InvocableCheckLimit.Request();
            req.limitName = limitName;
            requests.add(req);
        }

        // Call the invocable method for all limit types
        Test.startTest();
        List<InvocableCheckLimit.Response> responses = InvocableCheckLimit.invoke(requests);
        Test.stopTest();

        // Assertions
        Integer index = 0;
        for (InvocableCheckLimit.Response response : responses) {
            System.assertNotEquals(null, response.totalLimit, 'Total limit should not be null for ' + limitNames[index]);
            System.assertNotEquals(0, response.totalLimit, 'Total limit should not be 0 for ' + limitNames[index]);
            System.assertNotEquals(null, response.totalIssued, 'Total issued should not be null for ' + limitNames[index]);
            Boolean isRatioValid = response.ratioIssuedToLimit >= 0 && response.ratioIssuedToLimit <= 1;
            System.assertEquals(true, isRatioValid, 'Ratio of issued to limit should be between 0 and 1 for ' + limitNames[index]);
            index++;
        }
    }
}