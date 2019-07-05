
@isTest
public class GetPicklistValuesTests {
    
    @isTest
    public static void MainTest() {

        List<GetPicklistValues.Requests> requestList;
        
        requestList = new List<GetPicklistValues.Requests>();
            
        GetPicklistValues.Requests request = new GetPicklistValues.Requests();
        request.fieldName = 'Industry';
        request.objectName = 'Account';
        requestList.add(request);
        
        List<GetPicklistValues.Results> response = GetPicklistValues.getPicklistVals(requestList);
        System.assertNotEquals(null, response[0]);
    }
}