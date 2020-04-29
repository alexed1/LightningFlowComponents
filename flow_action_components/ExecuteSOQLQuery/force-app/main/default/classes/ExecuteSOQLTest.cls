@isTest
public class ExecuteSOQLTest {
    @isTest
    public static void testExecuteSOQLDateTime() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        //Not formatted DateTime
        ExecuteSOQL.Requests requests = new ExecuteSOQL.Requests();
        requests.soqlQuery = 'Select Id From Account Where CreatedDate >= 04/12/2020 03:24 PM';

        Test.startTest();
        List<ExecuteSOQL.Results> results = ExecuteSOQL.getEligibleProducts(new List<ExecuteSOQL.Requests>{
                requests
        });
        Test.stopTest();
        System.assertEquals(acc.Id, results[0].sObjects[0].Id);
    }
    
    @isTest
    private static void testExecuteSOQLShortDate() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        //Not formatted Date
        ExecuteSOQL.Requests requests = new ExecuteSOQL.Requests();
        requests.soqlQuery = 'Select Id From Account Where CreatedDate >= April 12, 2020';

        Test.startTest();
        List<ExecuteSOQL.Results> results = ExecuteSOQL.getEligibleProducts(new List<ExecuteSOQL.Requests>{
                requests
        });
        Test.stopTest();

        System.assertEquals(acc.Id, results[0].sObjects[0].Id);
    }
    
    @isTest
    private static void testExecuteSOQLLonDateTime() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        //Formatted date time
        ExecuteSOQL.Requests requests = new ExecuteSOQL.Requests();
        requests.soqlQuery = 'Select Id From Account Where CreatedDate >= 2020-04-12T15:24:00Z';

        Test.startTest();
        List<ExecuteSOQL.Results> results = ExecuteSOQL.getEligibleProducts(new List<ExecuteSOQL.Requests>{
                requests
        });
        Test.stopTest();

        System.assertEquals(acc.Id, results[0].sObjects[0].Id);
    }

    @isTest
    private static void testExecuteSOQLMultipleRecords() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        //Multiple records returned
        Set<Id> accIds = new Set<Id>();
        accIds.add(acc.Id);
        acc = new Account(Name = 'Test Account2');
        insert acc;
        accIds.add(acc.Id);
        
        ExecuteSOQL.Requests requests = new ExecuteSOQL.Requests();
        requests.soqlQuery = 'Select Id From Account Where Name != \'TEST\' ORDER BY CreatedDate LIMIT 2';
                
        Test.startTest();
        List<ExecuteSOQL.Results> results = ExecuteSOQL.getEligibleProducts(new List<ExecuteSOQL.Requests>{
                requests
        });
        Test.stopTest();
        
        for (SObject so : results[0].sObjects) {
            System.assertEquals(true, accIds.contains(so.Id));
        }
    }

    @isTest
    private static void testExecuteSOQLRelationshipQuery() {
        Account act = new Account(Name = 'Test1');
        insert act;

        Contact ct = new Contact(LastName='Test Contact', AccountId=act.Id);
        insert ct;

        ExecuteSOQL.Requests requests = new ExecuteSOQL.Requests();
        requests.soqlQuery = 'Select Id, AccountId, Account.Name From Contact Where AccountId in (SELECT Id from Account WHERE Name in (\'Test1\', \'Test2\', \'Test3\')) ';

        Test.startTest();
        List<ExecuteSOQL.Results> results = ExecuteSOQL.getEligibleProducts(new List<ExecuteSOQL.Requests>{requests});
        Test.stopTest();

        System.assertEquals(1, results[0].sObjects.size());

        Contact returnedContact = (Contact) (results[0].sObjects[0]);
        System.assertEquals(ct.Id, returnedContact.Id);
        System.assertEquals(act.Id, returnedContact.AccountId);
        System.assertEquals('Test1', returnedContact.Account.Name);
    }
}