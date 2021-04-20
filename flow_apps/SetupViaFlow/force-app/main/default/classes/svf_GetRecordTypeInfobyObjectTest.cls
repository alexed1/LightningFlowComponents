@isTest
public with sharing class svf_GetRecordTypeInfobyObjectTest {
    @isTest
    static void getTest() {
        svf_GetRecordTypeInfobyObject.Requests request = new svf_GetRecordTypeInfobyObject.Requests();
        request.objectName = 'Account';
        request.ignoreMasterRecordType = true;
        svf_GetRecordTypeInfobyObject.Results result = svf_GetRecordTypeInfobyObject.get(new List<svf_GetRecordTypeInfobyObject.Requests> {request})[0];
        // without master record type
        System.assert(result.recordTypeIds.size() > 0);

        request.ignoreMasterRecordType = false;
        request.onlyReturnActiveRecordTypes = true;
        request.onlyReturnRecordTypesAvailableToCurrentUser = true;

        result = svf_GetRecordTypeInfobyObject.get(new List<svf_GetRecordTypeInfobyObject.Requests> {request})[0];
        // with master record type
        System.assert(result.recordTypeIds.size() > 0);

    }
}
