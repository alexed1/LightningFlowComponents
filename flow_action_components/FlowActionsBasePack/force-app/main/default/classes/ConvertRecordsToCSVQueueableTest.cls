@isTest
private class ConvertRecordsToCSVQueueableTest {
    @isTest
    private static void testGenerateCSVContent() {
        List <SObject> objects = new List<SObject>{new Account(Name='Test1', AccountNumber='3445556676'), new Account(Name='Test2', BillingCity='Richmond'), new Account(Name='Test3')};
        Test.startTest();
        String fullCSV = ConvertRecordsToCSVQueueable.generateCSVContent(objects, null, ConvertRecordsToCSVQueueable.CSVParseType.ALL, false);
        Test.stopTest();
        List<String> rows = fullCSV.split('\n');
        System.assertEquals(4, rows.size());

        System.assertEquals(3, rows[0].split(',').size());
        System.assertEquals('Name,AccountNumber,BillingCity', rows[0]);
        System.assertEquals('Test1,3445556676', rows[1]);
        System.assertEquals('Test2,,Richmond', rows[2]);
        System.assertEquals('Test3,,', rows[3]);
    }

    //@isTest The GROUPBY LastName causes a test failure on orgs with Shield Encryption turned on, so disabling this test
    private static void testGenerateCSVContentListedFields() {
        Account account = new Account(Name='Linked Account');
        insert account;
        
	Contact contact1 = new Contact(LastName='Test1');
        Contact contact2 = new Contact(LastName='Test2', Email='abc@gmail.com');
        Contact contact3 = new Contact(LastName='Test3', Email='abc@gmail.com', FirstName='Jonny');
        insert new List<Contact>{contact1, contact2, contact3};
		
        contact2.AccountId = account.Id;
        // Testing Note: add your own custom field here to validate custom relationships
        // contact2.Related_Contact__c = contact1.Id;
        update contact2;

        List<Contact> contacts = [Select FirstName, LastName, Email, Account.Name from Contact];

        Test.startTest();
        String allFields = ConvertRecordsToCSVQueueable.generateCSVContent(contacts, null, ConvertRecordsToCSVQueueable.CSVParseType.ALL, false);
        String fullCSV = ConvertRecordsToCSVQueueable.generateCSVContent(contacts, new List<String>{'LastName','Email','Account.Name'}, ConvertRecordsToCSVQueueable.CSVParseType.ALL, false);
        String csv_CaseSensitive = ConvertRecordsToCSVQueueable.generateCSVContent(contacts, new List<String>{'lastName','email','Account.Name'}, ConvertRecordsToCSVQueueable.CSVParseType.ALL, false);
        Test.stopTest();
        List<String> rows = fullCSV.split('\n');
        System.assertEquals(4, rows.size());

        System.assertEquals(3, rows[0].split(',').size(), 'Full row text: ' + rows[0]);
        System.assertEquals('LastName,Email,Account.Name', rows[0]);

        System.assertEquals('Test1,,', rows[1]);
        System.assertEquals('Test2,abc@gmail.com,Linked Account', rows[2]);
        System.assertEquals('Test3,abc@gmail.com,', rows[3]);
        
        List<String> rows2 = csv_CaseSensitive.split('\n');
        System.assertEquals('lastName,email,Account.Name', rows2[0]);
        System.assertEquals('Test2,abc@gmail.com,Linked Account', rows2[2]);
        
        List<String> rows3 = allFields.split('\n');
        System.assertEquals('LastName,Id,Email,AccountId,FirstName', rows3[0]);
    }

    @isTest
        private static void testGenerateCSVContentAggregateResult() {
		
	//@isTest The GROUPBY LastName causes a test failure on orgs with Shield Encryption turned on, so chaged it to Group By LeadSource instead
	Contact contact1 = new Contact(LastName='Test', FirstName='Sally', LeadSource = 'Web');
        Contact contact2 = new Contact(LastName='Test', FirstName='Mary', Email='abc@gmail.com', LeadSource = 'Advertisement');
        Contact contact3 = new Contact(LastName='Test2', Email='abc@gmail.com', FirstName='Jonny', LeadSource = 'Social');
        insert new List<Contact>{contact1, contact2, contact3};
        update contact2;

        List<AggregateResult> contacts = [Select LeadSource from Contact GROUP BY LeadSource];
        
        Test.startTest();
        String fullCSV = ConvertRecordsToCSVQueueable.generateCSVContent(contacts, new List<String>{'name'}, ConvertRecordsToCSVQueueable.CSVParseType.ALL, false);
        String unnamed = ConvertRecordsToCSVQueueable.generateCSVContent(contacts, null, ConvertRecordsToCSVQueueable.CSVParseType.ALL, false);
        Test.stopTest();
        
        List<String> rows = fullCSV.split('\n');
       	System.assertEquals(3, rows.size(), 'Full text: ' + fullCSV);
        System.assertEquals('name', rows[0]);
        System.assertEquals('Test', rows[1]);
        System.assertEquals('Test2', rows[2]);
          
        List<String> rows2 = unnamed.split('\n');
       	System.assertEquals(3, rows2.size(), 'Full text: ' + unnamed);
        System.assertEquals('name', rows[0]);
        System.assertEquals('Test', rows2[1]);
        System.assertEquals('Test2', rows2[2]);
    }
    
    @isTest 
    private static void testAggregateResultCount() {
        List <Account> objects = new List<Account>{new Account(Name='Test1', AccountNumber='3445556676', Type='Prospect'), new Account(Name='Test2', BillingCity='Richmond', Type='Prospect'), new Account(Name='Test3', Type='Other')};
        insert objects;

        List<AggregateResult> count = [SELECT count(Id) NumberOfAccounts, Type FROM Account WHERE Type != null Group by Type];
        
        String aggrResult = ConvertRecordsToCSVQueueable.generateCSVContent(count, null, ConvertRecordsToCSVQueueable.CSVParseType.ALL, false);

        List<String> rows = aggrResult.split('\n');
        System.assertEquals(3, rows.size(), 'Full text: ' + aggrResult);
        
        List<String> headers = rows[0].split(',');
       	System.assertEquals(2, headers.size(), 'Full text: ' + headers);
        System.assertEquals('NumberOfAccounts', headers[0]);
        System.assertEquals('Type', headers[1]);
    }
    
    @isTest
    private static void testFullAction() {
		Contact contact1 = new Contact(LastName='Test1');
        Contact contact2 = new Contact(LastName='Test2', Email='abc@gmail.com');
        Contact contact3 = new Contact(LastName='Test3', Email='abc@gmail.com', FirstName='Jonny');
        insert new List<Contact>{contact1, contact2, contact3};

        List<Contact> contacts = [Select FirstName, LastName, Email from Contact];
        
        ConvertRecordsToCSVQueueable.Inputs input = new ConvertRecordsToCSVQueueable.Inputs();
        input.recordCollection = contacts;
        input.documentTitle = 'Test';
        
        // Test Synchronously
        ConvertRecordsToCSVQueueable.Outputs syncOutput = ConvertRecordsToCSVQueueable.generateCSV(new List<ConvertRecordsToCSVQueueable.Inputs>{input})[0];
        System.assert(syncOutput.contentDocumentId != null);
        System.assert(syncOutput.contentVersionId != null);
        System.assert(syncOutput.contentDocumentLinks.size() == 0);
        
        input.executeAsyncIdentifier = 'uniqueID';
        ConvertRecordsToCSVQueueable.Outputs asyncOutput = ConvertRecordsToCSVQueueable.generateCSV(new List<ConvertRecordsToCSVQueueable.Inputs>{input})[0];
        System.assert(asyncOutput.contentDocumentId == null);
        System.assert(asyncOutput.contentVersionId == null);
        System.assert(asyncOutput.contentDocumentLinks == null);
        System.assertEquals(1, asyncOutput.asyncJobIds.size());
    }
    
    @isTest
    private static void testFullActionAggrResult() {
       	List <Account> objects = new List<Account>{new Account(Name='Test1', AccountNumber='3445556676', Type='Prospect'), new Account(Name='Test2', BillingCity='Richmond', Type='Prospect'), new Account(Name='Test3', Type='Other')};
        insert objects;

        List<AggregateResult> count = [SELECT count(Id) NumberOfAccounts, Type FROM Account WHERE Type != null Group by Type];
        ConvertRecordsToCSVQueueable.Inputs input = new ConvertRecordsToCSVQueueable.Inputs();
        input.recordCollection = count;
        input.documentTitle = 'Test';
        
        // Test Synchronously
        ConvertRecordsToCSVQueueable.Outputs syncOutput = ConvertRecordsToCSVQueueable.generateCSV(new List<ConvertRecordsToCSVQueueable.Inputs>{input})[0];
        System.assert(syncOutput.contentDocumentId != null);
        System.assert(syncOutput.contentVersionId != null);
        System.assert(syncOutput.contentDocumentLinks.size() == 0);
    }

    @isTest
    private static void testGenerateDocument() {
        String csvContent = 'this, this, this, this, this \n';

        Account account = new Account(Name='Test');
        insert account;

        Test.startTest();
        ConvertRecordsToCSVQueueable.Outputs result = ConvertRecordsToCSVQueueable.generateDocument(new List<String>{account.Id}, 'MyDoc', 'V', 'ALlUsers', csvContent);
        Test.stopTest();

        System.assert(result.contentDocumentId != null);
        System.assert(result.contentVersionId != null);
        System.assert(result.contentDocumentLinks.size() == 1);
        System.assert(result.contentDocumentLinks[0] != null);
    }

    @isTest
    private static void testGenearteDocumentNoLinks() {
        String csvContent = 'this, this, this, this, this \n';
    
        Test.startTest();
        ConvertRecordsToCSVQueueable.Outputs result = ConvertRecordsToCSVQueueable.generateDocument(null, 'MyDoc', 'V', 'AllUsers', csvContent);
        Test.stopTest();

        System.assert(result.contentDocumentId != null);
        System.assert(result.contentVersionId != null);
        System.assert(result.contentDocumentLinks.size() == 0);
    }
}
