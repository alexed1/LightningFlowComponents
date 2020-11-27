@isTest
global with sharing class FieldPickerControllerTest {
    private final static String TEST_OBJECT_TYPE_LEAD = 'Lead';
    private final static String TEST_OBJECT_PICKLIST_FIELD = 'LeadSource';

    @isTest
    global static void testGetPicklistValues() {
        List<FieldPickerController.Member> memberList = FieldPickerController.getPicklistValues(TEST_OBJECT_TYPE_LEAD, TEST_OBJECT_PICKLIST_FIELD);
        System.assertNotEquals(memberList, null);
    }

    @isTest
    global static void testGetObjects() {
        List<FieldPickerController.Member> memberList = FieldPickerController.getObjects(new List<String>{
                TEST_OBJECT_TYPE_LEAD
        });
        System.assertEquals(1, memberList.size());
        System.assertEquals(TEST_OBJECT_TYPE_LEAD, memberList[0].value);
        memberList = FieldPickerController.getObjects(null);
        System.assertEquals(true, memberList.size() > 1);
    }
}
