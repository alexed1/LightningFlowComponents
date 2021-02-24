@IsTest
public class FindCommonAndUniqueRecordsTest {

	@TestSetup
    static void setup(){
        List<Account> accounts = new List<Account>();
        
        Account account1 = new Account(
        Name = 'Test Account 1');
        accounts.add(account1);

        Account account2 = new Account(
        Name = 'Test Account 2');
        accounts.add(account2);        
        
        Account account3 = new Account(
        Name = 'Test Account 3');
        accounts.add(account3);        
        insert accounts;
        
    	List<Contact> contacts = new List<Contact>();
        
        Contact contact1 = new Contact(
        FirstName = 'Dave',
        LastName = 'Buster',
        Email = 'dbuster@testytest.com',
        AccountId = account1.Id);  
        contacts.add(contact1);

        Contact contact2 = new Contact(
        FirstName = 'Sony',
        LastName = 'Canon',
        Email = 'scanon@testytest.com',
        AccountId = account1.Id);  
        contacts.add(contact2);
        
        Contact contact3 = new Contact(
        FirstName = 'Buster', 
        LastName = 'Vader',
        Email = 'dbluth@testytest.com',
        AccountId = account2.Id);  
        contacts.add(contact3);
        
        insert contacts;
    }
    
    @IsTest
    static void testCompareRecords() {
        List<Account> accountsInSource = [Select Id from Account];
        List<Contact> contactsInTarget = [Select Id,AccountId from Contact];
        
        List<FindCommonAndUniqueRecords.Request> flowRequests = new List<FindCommonAndUniqueRecords.Request>();
        FindCommonAndUniqueRecords.Request flowRequest = new FindCommonAndUniqueRecords.Request();
        flowRequest.sourceRecordCollection = accountsInSource;
        flowRequest.targetRecordCollection = contactsInTarget;
        flowRequest.sourceUniqueID = 'Id';
        flowRequest.targetUniqueID = 'AccountId';
        flowRequests.add(flowRequest);
        Test.startTest();
        List<FindCommonAndUniqueRecords.Result> results = FindCommonAndUniqueRecords.compareRecords(flowRequests);
        Test.stopTest();
        System.assertEquals(1, results[0].sourceUniqueRecordCollection.size(), 'sourceUnique failed');
        System.assertEquals(2, results[0].sourceCommonRecordCollection.size(), 'sourceCommon failed');
    }
    
    @IsTest
    static void testEmptyCollection() {
        List<Account> accountsInSource = [Select Id from Account];
        List<Contact> contactsInTarget = [Select Id,AccountId from Contact WHERE FirstName = 'Darth'];
        
        List<FindCommonAndUniqueRecords.Request> flowRequests = new List<FindCommonAndUniqueRecords.Request>();
        FindCommonAndUniqueRecords.Request flowRequest = new FindCommonAndUniqueRecords.Request();
        flowRequest.sourceRecordCollection = accountsInSource;
        flowRequest.targetRecordCollection = contactsInTarget;
        flowRequest.sourceUniqueID = 'Id';
        flowRequest.targetUniqueID = 'AccountId';
        flowRequests.add(flowRequest);
        Test.startTest();
        List<FindCommonAndUniqueRecords.Result> results = FindCommonAndUniqueRecords.compareRecords(flowRequests);
        Test.stopTest();
        System.assertEquals(3, results[0].sourceUniqueRecordCollection.size(), 'sourceUnique failed');
        System.assertEquals(0, results[0].sourceCommonRecordCollection.size(), 'sourceCommon failed');
    }
}