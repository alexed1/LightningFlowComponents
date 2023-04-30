@isTest
public with sharing class SObjectAggregateCalculator_Test {
    // Create a test class that will test SObjectAggregateCalculator.calculate
    // Build a request class from SObjectAggregateCalculator.Requests class
    // Different Test Classes that are needed
    // 1. sum
    // 2. count
    // 3. average
    // 4. max
    // 5. min

    public List<Account> mockAccounts() {
        List<Account> accountsList = new List<Account>();
        Integer[] numOfEmployees = new Integer[]{10, 20, 30, 40, 50, 60, 70, 80, 90, 100};
        
        for(Integer i=0; i<10; i++) {
            Account acc = new Account();
            acc.Name = 'Test Account ' + i;
            acc.NumberOfEmployees = numOfEmployees[Math.mod(Math.abs(Crypto.getRandomInteger()), numOfEmployees.size())];
            accountsList.add(acc);
        }
        insert accountsList;

        return accountsList;
    }
    
    
    @isTest
    public static void testSum() {
        // Call the mockAccount class
        List<Accounts> accts = mockAccounts();

        // Create Request Class
        SObjectAggregateCalculator.Requests request = new SObjectAggregateCalculator.Requests();
        request.action = 'Sum';
        request.fieldName = 'NumberOfEmployees';
        request.inputCollection = accts;

        List<SObjectAggregateCalculator.Requests> requests = new List<SObjectAggregateCalculator.Requests>();
        requests.add(request);

        Test.startTest();
        SObjectAggregateCalculator.calculate(requests);
        Test.stopTest();
    }
}