@isTest
public with sharing class GetLayoutFieldsTest {

        
        @isTest
        public static void CanGetRecordType () {

            List<GetLayoutFields.Requests> requestList = new List<GetLayoutFields.Requests>();
           
            String objectName = 'Case';
            String layoutName = 'Case Layout';
            String excludeFields = 'ContactId';
            

            GetLayoutFields.Requests request = new GetLayoutFields.Requests();
            request.objectName = objectName;
            request.layoutName = layoutName;
            request.excludeFields = excludeFields;
            
            requestList.add(request);
            
            List <GetLayoutFields.Results> results = GetLayoutFields.get(requestList);
            System.assertNotEquals(results[0].layoutFieldsCSV, null);
            
        }
}