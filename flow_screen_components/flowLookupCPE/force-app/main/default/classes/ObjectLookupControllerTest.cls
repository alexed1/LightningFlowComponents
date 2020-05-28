@isTest
public with sharing class ObjectLookupControllerTest {
    private final static String TEST_STRING = 'Test record name';

    @isTest
    public static void testSearch() {
        Account acc = new Account(Name = TEST_STRING);
        insert acc;
        //Test search by displayWhichField
        List<LookupSearchResult> searchResults = ObjectLookupController.search('Account', 'Name', 'Id', TEST_STRING, null, 0);
        LookupSearchResult curResult = searchResults[0];
        System.assertEquals(1, searchResults.size());
        System.assertEquals('standard:account', curResult.getIcon());
        System.assertEquals(acc.Id, curResult.getId());
        System.assertEquals('Account', curResult.getSObjectType());
        System.assertEquals('', curResult.getSubtitle());
        System.assertEquals(TEST_STRING, curResult.getTitle());
        //Test search by ID
        searchResults = ObjectLookupController.search('Account', 'Name', 'Id', null, new List<String>{
                acc.id
        }, 0);
        curResult = searchResults[0];
        System.assertEquals(TEST_STRING, curResult.getTitle());
    }
}
