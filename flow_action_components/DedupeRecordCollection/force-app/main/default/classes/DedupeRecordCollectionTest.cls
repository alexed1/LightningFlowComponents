@IsTest
private class DedupeRecordCollectionTest {
    
    @TestSetup
    static void setup(){
        List<Account> accounts = new List<Account>();
        for(Integer i = 1; i <= 10; i++) {
            Account account = new Account(
                Name = 'Test Account ' + i,
                BillingCity = 'Test Account ' + i
            );
            accounts.add(account);
        }
        accounts.add(new Account(Name='Test Account 1', BillingCity='Test Account 1'));
        insert accounts;
    }

    @IsTest
    static void emptyInputCollectionReturnsEmptyOutputCollection() {
        List<DedupeRecordCollection.FlowRequest> flowRequests = new List<DedupeRecordCollection.FlowRequest>();
        DedupeRecordCollection.FlowRequest flowRequest = new DedupeRecordCollection.FlowRequest();
        flowRequest.inputRecordCollection = new List<SObject>();
        flowRequest.fieldToDedupeOn = '';
        flowRequests.add(flowRequest);
        DedupeRecordCollection.DedupeRecordException exc;
        Test.startTest();
        try {
            List<DedupeRecordCollection.FlowResponse> results = DedupeRecordCollection.dedupe(flowRequests);
        } catch (DedupeRecordCollection.DedupeRecordException e) {
            exc = e;
        }
        Test.stopTest();
        System.assert(exc != null, 'DedupeRecordCollectionTest : emptyInputCollectionReturnsEmptyOutputCollection failed');
    }

    @IsTest
    static void dedupeRecordCollectionSuccess() {
        List<Account> accounts = [Select Id, Name from Account WHERE BillingCity != 'Test Account 1' LIMIT 1]; // set one field to null to assert null value handling
        accounts[0].BillingCity = null;
        update accounts;
        
        List<DedupeRecordCollection.FlowRequest> flowRequests = new List<DedupeRecordCollection.FlowRequest>();
        DedupeRecordCollection.FlowRequest flowRequest = new DedupeRecordCollection.FlowRequest();
        flowRequest.inputRecordCollection = [SELECT BillingCity FROM Account LIMIT 50];
        flowRequest.fieldToDedupeOn = 'BillingCity';
        flowRequests.add(flowRequest);
        Test.startTest();
        List<DedupeRecordCollection.FlowResponse> results = DedupeRecordCollection.dedupe(flowRequests);
        Test.stopTest();
        System.assert(results[0].outputRecordCollection.size() == 10, 'DedupeRecordCollectionTest : dedupeRecordCollectionSuccess failed');
    }
}
