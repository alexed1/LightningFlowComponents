@isTest
public class RenameGoogleDriveFolderTest {

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
                String fileId = listOfArgs[0].toString();
                if (fileId == 'DoesntExist') {
                    return null;
                }
                return new File('id', 'name', 'mimeType', 'url');
            }
            if (stubbedMethodName.equalsIgnoreCase('renameFile')) {
                return null;
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void RenameGoogleDriveFolder_RenamesFile() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        RenameGoogleDriveFolder.Request request = new RenameGoogleDriveFolder.Request();
        request.FolderPath = 'folder';
        request.NewName = 'newName';
        RenameGoogleDriveFolder.Response response = RenameGoogleDriveFolder.RenameGoogleDriveFolderImpl(drive, request);
        System.assert(response.IsSuccess);
        System.assertEquals('url', response.WebviewURL);
    }

    @isTest
    public static void renameGoogleDriveFolder_WhenFileDoesntExist_ThrowsException() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        RenameGoogleDriveFolder.Request request = new RenameGoogleDriveFolder.Request();
        request.FolderPath = 'DoesntExist';
        RenameGoogleDriveFolder.Response response = RenameGoogleDriveFolder.RenameGoogleDriveFolderImpl(drive, request);
         System.assert(!response.IsSuccess);
        System.assertEquals('Google Drive folder with the name "DoesntExist" doesn\'t exist' , response.ErrorMessage);
    }

    @isTest
    public static void RenameGoogleDriveFolder_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        RenameGoogleDriveFolder.Request request = new RenameGoogleDriveFolder.Request();
        request.FolderPath = 'test';
        List<RenameGoogleDriveFolder.Request> requests = new List<RenameGoogleDriveFolder.Request> { request };
        List<RenameGoogleDriveFolder.Response> responses = RenameGoogleDriveFolder.RenameGoogleDriveFolder(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}