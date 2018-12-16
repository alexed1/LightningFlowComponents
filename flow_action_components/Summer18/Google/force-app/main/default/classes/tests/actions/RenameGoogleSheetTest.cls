@isTest
public class RenameGoogleSheetTest {

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
    public static void renameGoogleSheet_RenamesFile() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        RenameGoogleSheet.Request request = new RenameGoogleSheet.Request();
        request.FilePath = 'file';
        request.NewName = 'newName';
        RenameGoogleSheet.Response response = RenameGoogleSheet.RenameGoogleSheetImpl(drive, request);
        System.assert(response.IsSuccess);
        System.assertEquals('url', response.WebviewURL);
    }

    @isTest
    public static void renameGoogleSheet_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        RenameGoogleSheet.Request request = new RenameGoogleSheet.Request();
        request.FilePath = 'test';
        List<RenameGoogleSheet.Request> requests = new List<RenameGoogleSheet.Request> { request };
        List<RenameGoogleSheet.Response> responses = RenameGoogleSheet.RenameGoogleSheet(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}