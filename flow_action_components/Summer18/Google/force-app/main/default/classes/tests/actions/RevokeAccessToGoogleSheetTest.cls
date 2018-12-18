@isTest
public class RevokeAccessToGoogleSheetTest {

    class GoogleDriveMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (stubbedMethodName.equalsIgnoreCase('revokeAccess')) {
                return null;
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void revokeAccessToGoogleSheet_CallsApi() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        RevokeAccessToGoogleSheet.Request request = new RevokeAccessToGoogleSheet.Request();
        request.FilePath = 'file';
        request.User1 = 'email';
        RevokeAccessToGoogleSheet.Response response = RevokeAccessToGoogleSheet.RevokeAccessToGoogleSheetImpl(drive, request);
        System.assert(response.IsSuccess);
    }

    @isTest
    public static void revokeAccessToGoogleSheet_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        RevokeAccessToGoogleSheet.Request request = new RevokeAccessToGoogleSheet.Request();
        request.FilePath = 'test';
        List<RevokeAccessToGoogleSheet.Request> requests = new List<RevokeAccessToGoogleSheet.Request> { request };
        List<RevokeAccessToGoogleSheet.Response> responses = RevokeAccessToGoogleSheet.RevokeAccessToGoogleSheet(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}