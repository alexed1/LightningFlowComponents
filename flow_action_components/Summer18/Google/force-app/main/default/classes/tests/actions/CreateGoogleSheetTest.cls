@isTest
public class CreateGoogleSheetTest {

    class GoogleDriveMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            //Pretend that file Id equals file name requested
            if (stubbedMethodName.equalsIgnoreCase('createSpreadsheet')) {
                return new File('id', 'name', 'mimeType', 'url');
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void CreateGoogleSheet_CreatesFolder() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        CreateGoogleSheet.Request request = new CreateGoogleSheet.Request();
        request.FilePath = 'file';
        CreateGoogleSheet.Response response = CreateGoogleSheet.CreateGoogleSheetImpl(drive, request);
        System.assert(response.IsSuccess);
        System.assertEquals('url', response.WebviewURL);
    }

    @isTest
    public static void CreateGoogleSheet_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        CreateGoogleSheet.Request request = new CreateGoogleSheet.Request();
        request.FilePath = 'test';
        List<CreateGoogleSheet.Request> requests = new List<CreateGoogleSheet.Request> { request };
        List<CreateGoogleSheet.Response> responses = CreateGoogleSheet.CreateGoogleSheet(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}