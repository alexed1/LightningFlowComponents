@isTest
public class AddQuipDocumentToFolderTest {

    class QuipMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (stubbedMethodName.equalsIgnoreCase('addDocumentToFolder')) {
                return null;
            }   
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void AddQuipDocumentToFolder_AddsDocument() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        AddQuipDocumentToFolder.Request request = new AddQuipDocumentToFolder.Request();
        request.FileName = 'Test';
        request.FolderPath = 'Test';
        AddQuipDocumentToFolder.Response response = AddQuipDocumentToFolder.AddQuipDocumentToFolderImpl(quip, request);
        System.assert(response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
    }

    @isTest
    public static void AddQuipDocumentToFolder_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        AddQuipDocumentToFolder.Request request = new AddQuipDocumentToFolder.Request();
        request.FolderPath = 'test';
        List<AddQuipDocumentToFolder.Request> requests = new List<AddQuipDocumentToFolder.Request> { request };
        List<AddQuipDocumentToFolder.Response> responses = AddQuipDocumentToFolder.AddQuipDocumentToFolder(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
    }
}
