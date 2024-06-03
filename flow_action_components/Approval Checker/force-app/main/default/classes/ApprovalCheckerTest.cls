@isTest
private class ApprovalCheckerTest {
    @isTest
    static void testIsLocked() {
        // Create test data
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        // Call the method to be tested
        List<Boolean> result = ApprovalChecker.isLocked(new List<Id>{acc.Id});
        
        // Perform assertions
        System.assertEquals(1, result.size(), 'Result should have only one entry');
        System.assertEquals(false, result[0], 'The test account should not be locked');
    }
}