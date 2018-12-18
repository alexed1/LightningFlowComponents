@isTest
public class GrantAccessToGoogleSheetTest {

    class GoogleDriveMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (stubbedMethodName.equalsIgnoreCase('grantAccess')) {
                return null;
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void grantAccessToGoogleSheet_CallsApi() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GrantAccessToGoogleSheet.Request request = new GrantAccessToGoogleSheet.Request();
        request.FilePath = 'file';
        request.User1 = 'email';
        request.Readonly = true;
        GrantAccessToGoogleSheet.Response response = GrantAccessToGoogleSheet.GrantAccessToGoogleSheetImpl(drive, request);
        System.assert(response.IsSuccess);
    }

    @isTest
    public static void grantAccessToGoogleSheet_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        GrantAccessToGoogleSheet.Request request = new GrantAccessToGoogleSheet.Request();
        request.FilePath = 'test';
        List<GrantAccessToGoogleSheet.Request> requests = new List<GrantAccessToGoogleSheet.Request> { request };
        List<GrantAccessToGoogleSheet.Response> responses = GrantAccessToGoogleSheet.GrantAccessToGoogleSheet(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}