@isTest
private class GetLayoutByProfileAndRecordTypeTest {

    

    @isTest
    static void CanGetLayoutProfile() {
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            


             List<GetLayoutByProfileAndRecordType.Requests> requestList = new List<GetLayoutByProfileAndRecordType.Requests>();
            String profileId  = '';
            String recordTypeId = '';
            GetLayoutByProfileAndRecordType.Requests request = new GetLayoutByProfileAndRecordType.Requests();
            request.profileId = profileId;
            request.recordTypeId = recordTypeId;
            requestList.add(request);


            // Call method to test.
            // This causes a fake response to be sent
            // from the class that implements HttpCalloutMock. 
            //HttpResponse res = CalloutClass.getInfoFromExternalService();
            

            List <GetLayoutByProfileAndRecordType.Results> results = GetLayoutByProfileAndRecordType.get(requestList);
            System.assertNotEquals(results, null);


            // Verify response received contains fake values
            //String contentType = res.getHeader('Content-Type');
            //System.assert(contentType == 'application/json');
            //String actualValue = res.getBody();
            //String expectedValue = '{"example":"test"}';
            //System.assertEquals(actualValue, expectedValue);
            //System.assertEquals(200, res.getStatusCode());
        }
}




   /* @isTest
   public static void CanGetLayoutProfile() {
        List<GetLayoutByProfileAndRecordType.Requests> requestList = new List<GetLayoutByProfileAndRecordType.Requests>();
        String profileId  = '';
        String recordTypeId = '';
        GetLayoutByProfileAndRecordType.Requests request = new GetLayoutByProfileAndRecordType.Requests();
        request.profileId = profileId;
        request.recordTypeId = recordTypeId;
        requestList.add(request);

        List <GetLayoutByProfileAndRecordType.Results> results = GetLayoutByProfileAndRecordType.get(requestList);
        System.assertNotEquals(results, null);
   } */

