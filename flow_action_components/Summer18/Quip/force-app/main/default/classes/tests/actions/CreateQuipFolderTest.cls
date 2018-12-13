@isTest
public class CreateQuipFolderTest {

    class QuipMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (stubbedMethodName.equalsIgnoreCase('getFolderByPath')) {
                return new Folder('1', 'Test');
            }   
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void CreateQuipFolder_CreateNewFolder() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        CreateQuipFolder.Request request = new CreateQuipFolder.Request();
        request.FolderPath = 'Test';
        CreateQuipFolder.Response response = CreateQuipFolder.CreateQuipFolderImpl(quip, request);
        System.assert(response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
    }

    @isTest
    public static void CreateQuipFolder_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        CreateQuipFolder.Request request = new CreateQuipFolder.Request();
        request.FolderPath = 'test';
        List<CreateQuipFolder.Request> requests = new List<CreateQuipFolder.Request> { request };
        List<CreateQuipFolder.Response> responses = CreateQuipFolder.CreateQuipFolder(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}
