@isTest
public class CreateGoogleDriveFolderTest {

    class GoogleDriveMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            //Pretend that file Id equals file name requested
            if (stubbedMethodName.equalsIgnoreCase('getFolder')) {
                return new File('id', 'name', 'mimeType', 'url');
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void createGoogleDriveFolder_CreatesFolder() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        CreateGoogleDriveFolder.Request request = new CreateGoogleDriveFolder.Request();
        request.FolderPath = 'file';
        CreateGoogleDriveFolder.Response response = CreateGoogleDriveFolder.CreateGoogleDriveFolderImpl(drive, request);
        System.assert(response.IsSuccess);
        System.assertEquals('url', response.WebviewURL);
    }

    @isTest
    public static void createGoogleDriveFolder_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        CreateGoogleDriveFolder.Request request = new CreateGoogleDriveFolder.Request();
        request.FolderPath = 'test';
        List<CreateGoogleDriveFolder.Request> requests = new List<CreateGoogleDriveFolder.Request> { request };
        List<CreateGoogleDriveFolder.Response> responses = CreateGoogleDriveFolder.CreateGoogleDriveFolder(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}