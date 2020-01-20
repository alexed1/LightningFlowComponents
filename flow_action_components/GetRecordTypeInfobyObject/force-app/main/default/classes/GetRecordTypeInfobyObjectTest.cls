@isTest
public with sharing class GetRecordTypeInfobyObjectTest {
    
    @isTest
    public static void CanGetRecordType () {

        List<GetRecordTypeInfobyObject.Requests> requestList = new List<GetRecordTypeInfobyObject.Requests>();
        List<Account> accountList = new List<Account>();
        String objectName = 'Account';
        Boolean onlyReturnActiveRecordTypes = false;
        Boolean onlyReturnRecordTypesAvailableToCurrentUser = false;

        GetRecordTypeInfobyObject.Requests request = new GetRecordTypeInfobyObject.Requests();
        request.objectName = objectName;
        request.onlyReturnActiveRecordTypes = onlyReturnActiveRecordTypes;
        request.onlyReturnRecordTypesAvailableToCurrentUser = onlyReturnRecordTypesAvailableToCurrentUser;
        requestList.add(request);
        
        List <GetRecordTypeInfobyObject.Results> results = GetRecordTypeInfobyObject.get(requestList);
        System.assertNotEquals(results[0].recordTypeNames, null);
        System.assertNotEquals(results[0].recordTypeIds, null);
    }
}