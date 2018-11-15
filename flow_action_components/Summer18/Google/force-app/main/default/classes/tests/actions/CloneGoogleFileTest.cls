@isTest
public class CloneGoogleFileTest {

    class GoogleDriveMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            //Pretend that file Id equals file name requested
            if (stubbedMethodName == 'CloneFile') {
                String fileId = listOfArgs[0].toString();
                if (fileId == 'test') {
                    return new ClonedFile('test id', 'test url');
                }
                else if (fileId == 'fail') {
                    throw new GoogleException('fail');
                }
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void CloneGoogleFileImpl_EmptyIdOrNameIsNotAllowed() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        CloneGoogleFile.Request request = new CloneGoogleFile.Request();
        request.NameOfCopy = 'test';
        CloneGoogleFile.Response response = CloneGoogleFile.CloneGoogleFileImpl(drive, request);
        System.assert(!response.IsSuccess);
        System.assertEquals('"File Id" or "File Name" can\'t be empty', response.ErrorMessage);
    }

    @isTest
    public static void CloneGoogleFileImpl_EmptyCopyNameIsNotAllowed() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        CloneGoogleFile.Request request = new CloneGoogleFile.Request();
        request.FileIdOrName = 'test';
        CloneGoogleFile.Response response = CloneGoogleFile.CloneGoogleFileImpl(drive, request);
        System.assert(!response.IsSuccess);
        System.assertEquals('"Copy Name" can\'t be empty', response.ErrorMessage);
    }

    @isTest
    public static void CloneGoogleFileImpl_ReturnsClonedFile() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        CloneGoogleFile.Request request = new CloneGoogleFile.Request();
        request.NameOfCopy = 'test copy';
        request.FileIdOrName = 'test';
        CloneGoogleFile.Response response = CloneGoogleFile.CloneGoogleFileImpl(drive, request);
        System.assert(response.IsSuccess);
        System.assertEquals('test id', response.FileId);
        System.assertEquals('test url', response.FileURL);
    }

    @isTest
    public static void CloneGoogleFileImpl_ReturnsErrorOnGoogleDriveFilure() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        CloneGoogleFile.Request request = new CloneGoogleFile.Request();
        request.NameOfCopy = 'fail';
        request.FileIdOrName = 'fail';
        CloneGoogleFile.Response response = CloneGoogleFile.CloneGoogleFileImpl(drive, request);
        System.assert(!response.IsSuccess);
        System.assertEquals('fail', response.ErrorMessage);
    }

    @isTest
    public static void CloneGoogleFile_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        CloneGoogleFile.Request request = new CloneGoogleFile.Request();
        request.FileIdOrName = 'test';
        request.NameOfCopy = 'test';
        List<CloneGoogleFile.Request> requests = new List<CloneGoogleFile.Request> { request };
        List<CloneGoogleFile.Response> responses = CloneGoogleFile.CloneGoogleFile(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}