@isTest
public with sharing class RetrievePicklistValuesTest {
    @isTest
    static void getPicklistValuesTest() {
        RetrievePicklistValues.Requests request = new RetrievePicklistValues.Requests();
        //retrieve picklist values for custom field
        request.objectApiName = 'Account';
        request.fieldName = 'Picklist_Field__c';
        RetrievePicklistValues.Results result = RetrievePicklistValues.getPicklistValues(
            new List<RetrievePicklistValues.Requests>{request }
        )[0];

        System.assert(result.isCustomField);
        //in MockPicklistValueGenerator class added 3 picklist values for Custom Field
        System.assert(result.listSize == 3);
        //retrieve picklist values for standart field
        request.objectApiName = 'Account';
        request.fieldName = 'AccountSource';
        result = RetrievePicklistValues.getPicklistValues(
            new List<RetrievePicklistValues.Requests>{request }
        )[0];

        System.assert(!result.isCustomField);
    }
}