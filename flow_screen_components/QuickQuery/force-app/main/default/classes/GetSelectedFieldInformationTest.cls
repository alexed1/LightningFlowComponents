@IsTest
public with sharing class GetSelectedFieldInformationTest {
    @IsTest
    static void testGetFieldInformation() {
        String fieldListString = 'Status,Subject,OwnerId,Origin,Type';

        GetSelectedFieldInformation.Requests request = new GetSelectedFieldInformation.Requests();
        request.objectName = 'Case';
        request.fieldListString = 'Status,Subject,OwnerId,Origin,Type';

        GetSelectedFieldInformation.Results result = GetSelectedFieldInformation.getFieldInformation(new List<GetSelectedFieldInformation.Requests>{request})[0];

        System.assert(result.fields.size() == 5);
        
    }
}
