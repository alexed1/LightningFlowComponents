@isTest
public class ObjectFieldSelectorControllerTest {

    @isTest
    public static void testOFSController() {
        ObjectFieldSelectorController.GetObjectsResult result1 = ObjectFieldSelectorController.getObjects('all', new List<String>());
        ObjectFieldSelectorController.GetObjectsResult result2 = ObjectFieldSelectorController.getObjects('both', new List<String>());
        ObjectFieldSelectorController.GetObjectsResult result3 = ObjectFieldSelectorController.getObjects('specific', new List<String>{'Account', 'Opportunity'});
        System.assertEquals(result3.objects.size(), 2);
        System.assert(result3.objects.size() < result2.objects.size());
        System.assert(result2.objects.size() < result1.objects.size());

        ObjectFieldSelectorController.GetObjectFieldsResult result4 = ObjectFieldSelectorController.getObjectFields('Account');
        ObjectFieldSelectorController.GetObjectFieldsResult result5 = ObjectFieldSelectorController.getObjectFields('NotARealObject');
        System.assert(String.isBlank(result4.errorMessage));
        System.assert(!String.isBlank(result5.errorMessage));
    }
}