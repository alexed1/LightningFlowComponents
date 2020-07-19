@isTest
public with sharing class fbc_FieldPickerControllerTest {
    private final static String TEST_OBJECT_TYPE_LEAD = 'Lead';
    private final static String TEST_OBJECT_PICKLIST_FIELD = 'LeadSource';

    @isTest
    public static void testGetPicklistValues() {
        List<fbc_FieldPickerController.Member> memberList = fbc_FieldPickerController.getPicklistValues(TEST_OBJECT_TYPE_LEAD, TEST_OBJECT_PICKLIST_FIELD);
        System.assertNotEquals(memberList, null);
    }

    @isTest
    public static void testGetObjects() {
        List<fbc_FieldPickerController.Member> memberList = fbc_FieldPickerController.getObjects(new List<String>{
                TEST_OBJECT_TYPE_LEAD
        });
        System.assertEquals(1, memberList.size());
        System.assertEquals(TEST_OBJECT_TYPE_LEAD, memberList[0].value);
        memberList = fbc_FieldPickerController.getObjects(null);
        System.assertEquals(true, memberList.size() > 1);
    }
}
