@isTest
public with sharing class ManagePicklistFieldTest {
    final static String FIELD_NAME = 'Picklist_Field__c';
    final static String OBJECT_NAME = 'Account';
    @isTest
    static void managePicklistFieldTest() {
        Test.setMock(WebServiceMock.class, new MockPicklistValueGenerator());
        ManagePicklistField.Requests request = new ManagePicklistField.Requests();
        request.objectApiName = OBJECT_NAME;
        request.fieldName = FIELD_NAME;
        request.action = ManagePicklistField.DEACTIVATE_STATUS;
        request.picklistValueNameListJSON = '[{"value":"1234","label":"1234","isDefaultValue":false,"isActive":true},{"value":"qwerty","label":"qwerty","isDefaultValue":false,"isActive":true},{"value":"test","label":"test","isDefaultValue":false,"isActive":true}]';
        ManagePicklistField.Results result = ManagePicklistField.managePicklistField(new List<ManagePicklistField.Requests>{request })[0];
        System.debug(result);
        System.assert(!result.isSuccess);
        
        request.action = ManagePicklistField.DEACTIVATE_STATUS;
        request.picklistValueNameListJSON = '[{"value":"qwerty","label":"qwerty","isDefaultValue":false,"isActive":true},{"value":"test","label":"test","isDefaultValue":false,"isActive":true}]';
        result = ManagePicklistField.managePicklistField(new List<ManagePicklistField.Requests>{request })[0];
        System.debug(result);
        System.assert(result.isSuccess);

        //set Deploy error
        Test.setMock(WebServiceMock.class, new MockPicklistValueGenerator(false));
        request.action = ManagePicklistField.ACTIVATE_STATUS;
        request.picklistValueNameListJSON = '[{"value":"qwerty","label":"qwerty","isDefaultValue":false,"isActive":true},{"value":"test","label":"test","isDefaultValue":false,"isActive":true}]';
        result = ManagePicklistField.managePicklistField(new List<ManagePicklistField.Requests>{request })[0];
        System.debug(result);
        System.assert(!result.isSuccess);
        
    }
}
