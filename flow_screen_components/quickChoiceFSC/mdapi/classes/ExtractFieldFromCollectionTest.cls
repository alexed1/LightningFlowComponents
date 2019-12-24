@isTest
public with sharing class ExtractFieldFromCollectionTest {
    
    @isTest
    public static void CanExtractField () {

        List<ExtractFieldFromCollection.Requests> requestList = new List<ExtractFieldFromCollection.Requests>();
        List<Account> accountList = new List<Account>();
        String fieldName = 'foobar';
        ExtractFieldFromCollection.Requests request = new ExtractFieldFromCollection.Requests();
        request.fieldName = fieldName;
        request.inputCollection = accountList;
        requestList.add(request);
        
        List <ExtractFieldFromCollection.Results> results = ExtractFieldFromCollection.extract(requestList);
        System.assertNotEquals(results, null);
    
    }
}