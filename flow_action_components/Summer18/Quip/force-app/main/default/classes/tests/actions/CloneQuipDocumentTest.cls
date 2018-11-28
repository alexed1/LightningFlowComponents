@isTest
public class CloneQuipDocumentTest {

    class QuipMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (stubbedMethodName == 'cloneThread') {
                String fileName = listOfArgs[0].toString();
                if (fileName == 'file') {
                    Thread result = new Thread('id');
                    result.link = 'url';
                    return result;
                }
                throw new QuipException('File with the name "' + fileName + '" was not found');
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void CloneQuipDocumentImpl_ClonesDocument() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        CloneQuipDocument.Request request = new CloneQuipDocument.Request();
        request.FileName = 'file';
        request.NameOfCopy = 'copy';
        CloneQuipDocument.Response response = CloneQuipDocument.CloneQuipDocumentImpl(quip, request);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('id', response.FileId);
        System.assertEquals('url', response.FileUrl);
    }

    @isTest
    public static void CloneQuipDocumentImpl_WhenFileDoesntExist_ThrowsException() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        CloneQuipDocument.Request request = new CloneQuipDocument.Request();
        request.FileName = 'DoesntExist';
        request.NameOfCopy = 'copy';
        CloneQuipDocument.Response response = CloneQuipDocument.CloneQuipDocumentImpl(quip, request);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('File with the name "DoesntExist" was not found', response.ErrorMessage);
        System.assert(String.isBlank(response.FileId));
        System.assert(String.isBlank(response.FileUrl));
    }

    @isTest
    public static void CloneQuipDocument_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        CloneQuipDocument.Request request = new CloneQuipDocument.Request();
        request.FileName = 'test';
        request.NameOfCopy = 'copy';
        List<CloneQuipDocument.Request> requests = new List<CloneQuipDocument.Request> { request };
        List<CloneQuipDocument.Response> responses = CloneQuipDocument.CloneQuipDocument(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}
