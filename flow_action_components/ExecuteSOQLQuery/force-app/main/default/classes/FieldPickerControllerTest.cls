@isTest
public class FieldPickerControllerTest {
    
    @isTest
    public static void CanGetPicklistValues() {
        String objName = 'Account';
        String fieldName = 'Type';
        List<FieldPickerController.Member> memberList = FieldPickerController.getPicklistValues(objName, fieldName);
        System.assertNotEquals(memberList, null);
    
    }
}
