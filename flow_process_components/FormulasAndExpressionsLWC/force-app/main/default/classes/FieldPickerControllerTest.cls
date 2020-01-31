@isTest
public with sharing class FieldPickerControllerTest {
    private static final String OBJECT_NAME = 'Account';
    private static final String PICKLIST_FIELD_NAME = 'AccountSource';

    @IsTest
    static void testGetObjects() {
        //Get two supported and one not supported object
        List<FieldPickerController.Member> members = FieldPickerController.getObjects(new List<String>{
                'Account', 'User'
        });
        System.assertEquals(2, members.size());
        System.assertEquals('Account', members[0].label);
        System.assertEquals('User', members[1].label);
        //Get all objects
        members = FieldPickerController.getObjects(NULL);
        for (FieldPickerController.Member m : members) {
            System.debug(m.label);
        }
        //All supported objects plus all custom are different on different types of orgs, so commenting this line out.
        //System.assertEquals(true, members.size() >= FieldPickerController.allowedStandardObjects.size());
    }

    @IsTest
    static void testGetPicklistValues() {
        List<FieldPickerController.Member> members = FieldPickerController.getPicklistValues(OBJECT_NAME, PICKLIST_FIELD_NAME);

        Schema.DescribeSObjectResult describeObject = Schema.getGlobalDescribe().get(OBJECT_NAME).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = describeObject.fields.getMap();
        List<Schema.PicklistEntry> values = fieldMap.get(PICKLIST_FIELD_NAME).getDescribe().getPickListValues();

        System.assertEquals(members.size(), values.size());
    }
}