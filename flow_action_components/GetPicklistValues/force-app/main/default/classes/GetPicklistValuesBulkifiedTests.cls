
@isTest
public class GetPicklistValuesBulkifiedTests {
    
    @isTest
    public static void MainTest() {

        List<GetPicklistValuesBulkified.Requests> requestList;
        
        requestList = new List<GetPicklistValuesBulkified.Requests>();
            
        GetPicklistValuesBulkified.Requests request = new GetPicklistValuesBulkified.Requests();
        request.fieldName = 'Industry';
        request.objectName = 'Account';
        requestList.add(request);
        
        List<GetPicklistValuesBulkified.Results> response = GetPicklistValuesBulkified.getPicklistVals(requestList);
        System.assertNotEquals(null, response[0]);
    }
}