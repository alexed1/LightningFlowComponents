@isTest
public class DeleteGoogleSheetTest {

    class GoogleDriveMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            //Pretend that file Id equals file name requested
            if (stubbedMethodName.equalsIgnoreCase('getFile')) {
                String fileId = listOfArgs[0].toString();
                if (fileId == 'file') {
                    return new File('id', 'name', 'mimeType', 'url');
                }
                return null;
            }
            if (stubbedMethodName.equalsIgnoreCase('deleteFile')) {
                return null;
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void deleteGoogleSheet_RenamesFile() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        DeleteGoogleSheet.Request request = new DeleteGoogleSheet.Request();
        request.FilePath = 'file';
        DeleteGoogleSheet.Response response = DeleteGoogleSheet.DeleteGoogleSheetImpl(drive, request);
        System.assert(response.IsSuccess);
    }

    @isTest
    public static void deleteGoogleSheet_WhenFileDoesntExist_Fails() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        DeleteGoogleSheet.Request request = new DeleteGoogleSheet.Request();
        request.FilePath = 'DoesntExist';
        DeleteGoogleSheet.Response response = DeleteGoogleSheet.DeleteGoogleSheetImpl(drive, request);
        System.assert(!response.IsSuccess);
        System.assertEquals('Google Sheet with the name "DoesntExist" doesn\'t exist' , response.ErrorMessage);
    }

    @isTest
    public static void deleteGoogleSheet_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        DeleteGoogleSheet.Request request = new DeleteGoogleSheet.Request();
        request.FilePath = 'test';
        List<DeleteGoogleSheet.Request> requests = new List<DeleteGoogleSheet.Request> { request };
        List<DeleteGoogleSheet.Response> responses = DeleteGoogleSheet.DeleteGoogleSheet(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}