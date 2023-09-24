@IsTest
private class GetPicklistValuesBulkifiedTests {
    @IsTest
    private static void testValid() {
        List<GetPicklistValuesBulkified.Requests> requestList;

        requestList = new List<GetPicklistValuesBulkified.Requests>();

        GetPicklistValuesBulkified.Requests request = new GetPicklistValuesBulkified.Requests();
        request.fieldName = 'Industry';
        request.objectName = 'Account';
        requestList.add(request);

        List<GetPicklistValuesBulkified.Results> response = GetPicklistValuesBulkified.getPicklistVals(
            requestList
        );

        System.assertNotEquals(null, response[0], 'Result should not be null.');
        System.assertNotEquals(
            0,
            response[0].picklistValues.size(),
            'List of picklist values should contain at least one element.'
        );
    }

    @IsTest
    private static void testInvalid() {
        List<GetPicklistValuesBulkified.Requests> requestList;

        requestList = new List<GetPicklistValuesBulkified.Requests>();

        GetPicklistValuesBulkified.Requests request = new GetPicklistValuesBulkified.Requests();
        request.fieldName = '';
        request.objectName = '';
        requestList.add(request);

        List<GetPicklistValuesBulkified.Results> response = GetPicklistValuesBulkified.getPicklistVals(
            requestList
        );

        System.assertNotEquals(null, response[0], 'Result should not be null.');
        System.assertEquals(
            0,
            response[0].picklistValues.size(),
            'List of picklist values should not contain anything.'
        );
        System.assertEquals(
            false,
            response[0].ok,
            '"ok" should be set to false because description failed.'
        );
        System.assertEquals(
            GetPicklistValuesBulkified.MSG_OBJECT_OR_FIELD_NOT_PROVIDED,
            response[0].message,
            'Messages should match.'
        );
    }
}
