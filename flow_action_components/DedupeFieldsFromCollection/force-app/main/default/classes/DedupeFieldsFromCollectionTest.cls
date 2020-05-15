@IsTest
private class DedupeFieldsFromCollectionTest {
    
    @TestSetup
    static void setup(){
        List<Account> accounts = new List<Account>();
        for(Integer i = 1; i <= 10; i++) {
            Account account = new Account(
                Name = 'Test Account ' + i
            );
            accounts.add(account);
        }
        accounts.add(new Account(Name='Test Account 1'));
        insert accounts;
    }

    @IsTest
    static void emptyInputCollectionReturnsEmptyOutputCollection() {
        List<DedupeFieldsFromCollection.FlowRequest> flowRequests = new List<DedupeFieldsFromCollection.FlowRequest>();
        DedupeFieldsFromCollection.FlowRequest flowRequest = new DedupeFieldsFromCollection.FlowRequest();
        flowRequest.inputRecordCollection = new List<Account>();
        flowRequest.fieldAPIName = '';
        flowRequests.add(flowRequest);
        DedupeFieldsFromCollection.DedupeFieldsFromCollection exc;
        Test.startTest();
        try {
           List<DedupeFieldsFromCollection.FlowResponse> results = DedupeFieldsFromCollection.dedupe(flowRequests);
        } catch (DedupeFieldsFromCollection.DedupeFieldsFromCollection e) {
            exc = e;
        }
        Test.stopTest();
        System.assert(exc != null, 'DedupeFieldsFromRecordCollectionTest : emptyInputCollectionReturnsEmptyOutputCollection failed');
    }
    
    @IsTest
    static void extractTextCollectionNoDedupe() {
        List<DedupeFieldsFromCollection.FlowRequest> flowRequests = new List<DedupeFieldsFromCollection.FlowRequest>();
        DedupeFieldsFromCollection.FlowRequest flowRequest = new DedupeFieldsFromCollection.FlowRequest();
        flowRequest.inputRecordCollection = [SELECT Name FROM Account LIMIT 50];
        flowRequest.fieldAPIName = 'name';
        flowRequest.dedupeValues = false;
        flowRequests.add(flowRequest);
        Test.startTest();
        List<DedupeFieldsFromCollection.FlowResponse> results = DedupeFieldsFromCollection.dedupe(flowRequests);
        Test.stopTest();
        System.assert(results[0].fieldValueCollection.size() == 11, 'DedupeFieldsFromRecordCollectionTest : dedupeTextCollectionSuccess failed');
    }

    @IsTest
    static void dedupeTextCollectionSuccess() {
        List<DedupeFieldsFromCollection.FlowRequest> flowRequests = new List<DedupeFieldsFromCollection.FlowRequest>();
        DedupeFieldsFromCollection.FlowRequest flowRequest = new DedupeFieldsFromCollection.FlowRequest();
        flowRequest.inputRecordCollection = [SELECT Name FROM Account LIMIT 50];
        flowRequest.fieldAPIName = 'name';
        flowRequests.add(flowRequest);
        Test.startTest();
        List<DedupeFieldsFromCollection.FlowResponse> results = DedupeFieldsFromCollection.dedupe(flowRequests);
        Test.stopTest();
        System.assert(results[0].fieldValueCollection.size() == 10, 'DedupeFieldsFromRecordCollectionTest : dedupeTextCollectionSuccess failed');
    }
    
    @IsTest
    static void dedupeTextCollectionSuccessNullValues() {
        List<Account> accounts = [Select Id, BillingCity from Account LIMIT 8]; // out of 10: leave one null, set one unique
        for (Account act: accounts) {
            act.BillingCity = 'Test City';
        }
        update accounts;
        List<Account> accounts2 = [Select Id, BillingCity from Account WHERE BillingCity != 'Test City' LIMIT 1]; // out of 10: leave one null, set one unique
		accounts2[0].BillingCity = 'Test City 2';
        update accounts2;
        
        List<DedupeFieldsFromCollection.FlowRequest> flowRequests = new List<DedupeFieldsFromCollection.FlowRequest>();
        DedupeFieldsFromCollection.FlowRequest flowRequest = new DedupeFieldsFromCollection.FlowRequest();
        flowRequest.inputRecordCollection = [SELECT BillingCity FROM Account LIMIT 50];
        flowRequest.fieldAPIName = 'BillingCity';
        flowRequests.add(flowRequest);
        Test.startTest();
        List<DedupeFieldsFromCollection.FlowResponse> results = DedupeFieldsFromCollection.dedupe(flowRequests);
        Test.stopTest();
        System.assert(results[0].fieldValueCollection.size() == 2, 'DedupeFieldsFromRecordCollectionTest : dedupeTextCollectionSuccess failed');
    }
}