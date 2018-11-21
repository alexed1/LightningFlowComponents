@isTest
public class QuipTest {
    
    class QuipAPIMock implements StubProvider {

        private Map<String, ThreadResponse> threads = new Map<String, ThreadResponse>();

        public QuipAPIMock() {
            ThreadResponse response = new ThreadResponse();
            ThreadResponse.Thread thread = new ThreadResponse.Thread();
            thread.id = 'Thread000001';
            thread.type = 'document';
            thread.title = '01';
            response.thread = thread;
            response.html = '<table title="Sheet1"><tbody><tr id="1"><td id="1-1"><span>Text</span></td></tr></tbody></table>';
            threads.put(thread.id, response);

            
            response = new ThreadResponse();
            thread = new ThreadResponse.Thread();
            thread.id = 'Thread000002';
            thread.type = 'document';
            thread.title = '02';
            response.thread = thread;
            response.html = '<table title="Sheet2"><tbody><tr id="1"><td id="1-1"><span>Text</span></td></tr></tbody></table>';
            threads.put(thread.id, response);
        }

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (stubbedMethodName == 'likeId') {
                String idOrName = listOfArgs[0].toString();
                if (idOrName.length() == 12) {
                    return true;
                }
                return false;
            }
            if (stubbedMethodName == 'getThread') {
                String id = listOfArgs[0].toString();
                return threads.get(id);
            }
            if (stubbedMethodName == 'getThreadList') {
                List<String> idList = (List<String>)listOfArgs[0];
                ThreadListResponse response = new ThreadListResponse();
                for (String id : idList) {
                    response.threads.add(threads.get(id));
                }
                return response;
            }
            if (stubbedMethodName == 'getCurrentUser') {
                UserResponse user = new UserResponse();
                user.starred_folder_id = 'Folder000001';
                user.desktop_folder_id = 'Folder000001';
                user.private_folder_id = 'Folder000001';
                user.shared_folder_ids.add('Folder000001');
                user.group_folder_ids.add('Folder000001');
                return user;
            }
            if (stubbedMethodName == 'getFolder') {
                System.debug('getFolder got the following arguments: ' + String.valueOf(listOfArgs));
                String id = listOfArgs[0].toString();
                if (id == 'Folder000001') {
                    FolderResponse response = new FolderResponse();
                    FolderResponse.Folder folder = new FolderResponse.Folder();
                    folder.id = 'Folder000001';
                    folder.title = 'folder';
                    response.folder = folder;
                    FolderResponse.ThreadOrFolder thread = new FolderResponse.ThreadOrFolder();
                    thread.thread_id = 'Thread000001';
                    response.children.add(thread);
                    FolderResponse.ThreadOrFolder subFolder = new FolderResponse.ThreadOrFolder();
                    subFolder.folder_id = 'Folder000002';                    
                    response.children.add(subFolder);
                    return response;
                }
                if (id == 'Folder000002') {
                    FolderResponse response = new FolderResponse();
                    FolderResponse.Folder folder = new FolderResponse.Folder();
                    folder.id = 'Folder000002';
                    folder.title = 'folder';
                    response.folder = folder;
                    FolderResponse.ThreadOrFolder thread = new FolderResponse.ThreadOrFolder();
                    thread.thread_id = 'Thread000002';
                    response.children.add(thread);
                    return response;
                }
                System.debug('Unhandled arguments for method: ' + stubbedMethodName);
            }
            System.debug('Unhandled method call: ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void findThread_ThrowsExceptionIfIdOrNameIsEmpty() {
        IQuipAPI api = (IQuipAPI)Test.createStub(IQuipAPI.class, new QuipAPIMock());
        Quip quip = new Quip(api);
        try {
            quip.findThread('');
            System.assert(false, 'Must throw exception');
        }
        catch (QuipException ex) {
            System.assertEquals('Id or Name can\'t be blank', ex.getMessage());
        }
    }

    @isTest
    public static void findThread_WhenIdIsPassed_CallsApi() {
        IQuipAPI api = (IQuipAPI)Test.createStub(IQuipAPI.class, new QuipAPIMock());
        Quip quip = new Quip(api);
        Thread thread = quip.findThread('Thread000001');
        System.assertEquals('Sheet1', thread.sheets[0].title);
    }

    @isTest
    public static void findThread_WhenNameIsPassedAndFileDoesntExist_Fails() {
        IQuipAPI api = (IQuipAPI)Test.createStub(IQuipAPI.class, new QuipAPIMock());
        Quip quip = new Quip(api);
        try { 
            quip.findThread('DoesntExist');
            System.assert(false, 'Must throw exception');
        }
        catch (QuipException ex) {
            System.assertEquals('File "DoesntExist" doesn\'t exist', ex.getMessage());
        }
    }

    @isTest
    public static void findThread_WhenNameIsPassedAndFileExists_ReturnsIt() {
        IQuipAPI api = (IQuipAPI)Test.createStub(IQuipAPI.class, new QuipAPIMock());
        Quip quip = new Quip(api);
        Thread thread = quip.findThread('01');
        System.assertEquals('Sheet1', thread.sheets[0].title);
    }
}