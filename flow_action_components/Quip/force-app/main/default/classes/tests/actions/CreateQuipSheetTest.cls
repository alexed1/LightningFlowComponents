@isTest
public class CreateQuipSheetTest {

    class QuipMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (stubbedMethodName.equalsIgnoreCase('findFolder')) {
                Folder result = new Folder('1', 'Private');
                result.subfolders.add(new FolderRef('2'));
                return result;
            } else if (stubbedMethodName.equalsIgnoreCase('getFolders')) {
                return new List<Folder> { new Folder('2', 'Level 1') };
            } else if (stubbedMethodName.equalsIgnoreCase('createFolder')) {
                return new Folder('3', 'Level 2');
            } else if (stubbedMethodName.equalsIgnoreCase('createThread')) {
                return new Thread('4');
            } else if (stubbedMethodName.equalsIgnoreCase('getFolderByPath')) {
                return new Folder('3', 'Level 2');
            }     
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void CreateQuipSheet_CreateNewFolderAndSheet() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        CreateQuipSheet.Request request = new CreateQuipSheet.Request();
        request.FileName = 'test';
        request.Path = 'Level 2';
        CreateQuipSheet.Response response = CreateQuipSheet.CreateQuipSheetImpl(quip, request);
        System.assert(response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('4', response.FileId);
    }

    @isTest
    public static void CreateQuipSheet_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        CreateQuipSheet.Request request = new CreateQuipSheet.Request();
        request.FileName = 'test';
        List<CreateQuipSheet.Request> requests = new List<CreateQuipSheet.Request> { request };
        List<CreateQuipSheet.Response> responses = CreateQuipSheet.CreateQuipSheet(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
    }
}
