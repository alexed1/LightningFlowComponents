@isTest
public with sharing class ManagePicklistFieldTest {
    final static String FIELD_NAME = 'Picklist_Field__c';
    final static String OBJECT_NAME = 'Account';
    @isTest
    static void managePicklistFieldTest() {
        
        ManagePicklistField.Requests request = new ManagePicklistField.Requests();
        request.objectApiName = OBJECT_NAME;
        request.fieldName = FIELD_NAME;
        request.action = Label.DEACTIVATE_STATUS_LABEL;
        request.picklistValueNameListJSON = '[{"value":"1234","label":"1234","isDefaultValue":false,"isActive":true},{"value":"qwerty","label":"qwerty","isDefaultValue":false,"isActive":true},{"value":"test","label":"test","isDefaultValue":false,"isActive":true}]';
        ManagePicklistField.Results result = ManagePicklistField.managePicklistField(new List<ManagePicklistField.Requests>{request })[0];
        System.assert(!result.isSuccess);
        
        request.action = Label.DEACTIVATE_STATUS_LABEL;
        request.picklistValueNameListJSON = '[{"value":"qwerty","label":"qwerty","isDefaultValue":false,"isActive":true},{"value":"test","label":"test","isDefaultValue":false,"isActive":true}]';
        result = ManagePicklistField.managePicklistField(new List<ManagePicklistField.Requests>{request })[0];
        System.assert(result.isSuccess);

        //set Deploy error
        request.action = Label.ACTIVATE_STATUS_LABEL;
        request.picklistValueNameListJSON = '[{"value":"qwerty","label":"qwerty","isDefaultValue":false,"isActive":true},{"value":"test","label":"test","isDefaultValue":false,"isActive":true}]';
        result = ManagePicklistField.managePicklistField(new List<ManagePicklistField.Requests>{request })[0];
        System.assert(result.isSuccess);
        
    }

    public static usf3.MetadataService.CustomField getCustomField() {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'CustomFieldMetadataAPIResponse' LIMIT 1];

        usf3.MetadataService.CustomField customField = (usf3.MetadataService.CustomField)JSON.deserializeStrict(sr.Body.toString(), usf3.MetadataService.CustomField.class);
        return customField;
    }

    public static List<usf3.MetadataService.SaveResult> getSaveResult() {
        usf3.MetadataService.updateMetadataResponse_element mtdRespose = new usf3.MetadataService.updateMetadataResponse_element();
        usf3.MetadataService.SaveResult result = new usf3.MetadataService.SaveResult();
        result.success  = true;
        mtdRespose.result = new List<usf3.MetadataService.SaveResult> {result};
        return mtdRespose.result;
    }
}