@isTest
public class RenameQuipFolderTest {

    class QuipMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (stubbedMethodName.equalsIgnoreCase('renameFolder')) {
                return null;
            } else if (stubbedMethodName.equalsIgnoreCase('getFolderByPath')) {
                return new Folder('1', 'Test');
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void RenameQuipFolder_RenamesFolder() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        RenameQuipFolder.Request request = new RenameQuipFolder.Request();
        request.FolderPath = 'Test';
        request.NewFolderName = 'Test';
        RenameQuipFolder.Response response = RenameQuipFolder.RenameQuipFolderImpl(quip, request);
        System.assert(response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
    }

    @isTest
    public static void RenameQuipFolder_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        RenameQuipFolder.Request request = new RenameQuipFolder.Request();
        request.FolderPath = 'test';
        List<RenameQuipFolder.Request> requests = new List<RenameQuipFolder.Request> { request };
        List<RenameQuipFolder.Response> responses = RenameQuipFolder.RenameQuipFolder(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
    }
}
