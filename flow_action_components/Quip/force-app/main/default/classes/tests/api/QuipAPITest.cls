@isTest
public class QuipAPITest {

    class HttpResponseMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String endpoint = req.getEndpoint();
            System.debug('Test call for: ' + endpoint);
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);      
            if (endPoint.endsWith('/users/current')) {
                res.setBody('{ "id": "id" }');
            } else if (endpoint.endsWith('threads/1')) {
                res.setBody('{ "html": "html", "thread": { "id" : "id", "type" : "type", "title" : "title" } }');
            } else if (endpoint.endsWith('threads/?ids=1,2')) {
                res.setBody('{ "1" : { "html" : "html", "thread": { "id" : "id", "type" : "type", "title" : "title" } }, "2": { "html" : "html", "thread": { "id" : "id", "type" : "type", "title" : "title" } } }');
            } else if (endpoint.endsWith('folders/1')) {
                res.setBody('{ "folder": { "id" : "id" } }');
            } else if (endpoint.endsWith('threads/edit-document')) {
                res.setBody('{ "html": "html", "thread": { "id" : "1", "type" : "type", "title" : "title" } }');
            } else if (endpoint.endsWith('threads/new-document')) {
                res.setBody('{ "html": "html", "thread": { "id" : "1", "type" : "type", "title" : "title" } }');
            } else if (endpoint.endsWith('folders/new')) {
                res.setBody('{ "folder": { "id": "id", "title" : "title" }, "children": [ { "folder_id" : "1" } ]}');
            } else if (endpoint.endsWith('folders/?ids=1,2')) {
                res.setBody('{ "1" : { "folder": { "id": "1", "title" : "title" }, "children": [] }, "2": { "folder": { "id": "2", "title" : "title" }, "children": [] } }');
            } else if (endpoint.endsWith('users/?ids=1')) {
                res.setBody('{ "1" : { "id": "1", "name" : "name" } }');
            } else if (endpoint.endsWith('threads/add-members')) {
                res.setBody('{ "html": "html", "thread": { "id" : "1", "type" : "type", "title" : "title" } }');
            } else if (endpoint.endsWith('threads/remove-members')) {
                res.setBody('{ "html": "html", "thread": { "id" : "1", "type" : "type", "title" : "title" } }');
            }
            return res;
        }
    }

    @isTest
    public static void likeId_Blank_ReturnsFalse() {
        Boolean likeId = new QuipAPI().likeId('');
        System.assert(!likeId);
    }

    @isTest
    public static void likeId_HasSpace_ReturnsFalse() {
        Boolean likeId = new QuipAPI().likeId('1234567890 2');
        System.assert(!likeId);
    }

    @isTest
    public static void likeId_TrueId_ReturnsTrue() {
        Boolean likeId = new QuipAPI().likeId('123456789012');
        System.assert(likeId);
    }

    @isTest
    public static void getCurrentUser_ReturnsCurrentUser() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        QuipAPI api = new QuipAPI(true);
        CurrentUserResponse user = api.getCurrentUser();
        System.assertEquals('id', user.id);
    }

    @isTest
    public static void getThread_ReturnsThread() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        QuipAPI api = new QuipAPI(true);
        ThreadResponse thread = api.getThread('1');
        System.assertEquals('html', thread.html);
    }

    @isTest
    public static void getThreadList_ReturnsThreadList() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        QuipAPI api = new QuipAPI(true);
        List<String> idList = new List<String> { '1', '2' };
        ThreadListResponse response = api.getThreadList(idList);
        System.assertEquals(2, response.threads.size());
    }

    @isTest
    public static void getFolder_ReturnsFolder() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        QuipAPI api = new QuipAPI(true);
        FolderResponse folder = api.getFolder('1');
        System.assertEquals('id', folder.folder.id);
    }

    @isTest
    public static void editDocument_ReturnsThread() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        QuipAPI api = new QuipAPI(true);
        ThreadResponse thread = api.editDocument('1', 'content', 'sectionId', SectionLocation.REPLACE_SECTION);
        System.assertEquals('1', thread.thread.id);
    }

    @isTest
    public static void createDocument_ReturnsThread() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        QuipAPI api = new QuipAPI(true);
        ThreadResponse thread = api.createDocument('title', 'content', 'document', null);
        System.assertEquals('1', thread.thread.id);
    }

    @isTest
    public static void createFolder_ReturnsFolder() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        QuipAPI api = new QuipAPI(true);
        FolderResponse folder = api.createFolder('title', 'id');
        System.assertEquals('id', folder.folder.id);
    }

    @isTest
    public static void getFolderList_ReturnsFolderList() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        QuipAPI api = new QuipAPI(true);
        FolderListResponse folders = api.getFolderList(new List<String> { '1', '2' });
        System.assertEquals(2, folders.folders.size());
    }

    @isTest
    public static void getUsers_ReturnsFolderList() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        QuipAPI api = new QuipAPI(true);
        UserListResponse users = api.getUsers(new List<String> { '1' });
        System.assertEquals(1, users.users.size());
    }

    @isTest
    public static void addMembers_ReturnsFolderList() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        QuipAPI api = new QuipAPI(true);
        ThreadResponse thread = (ThreadResponse)api.addMembers('1', new List<String> { '1', '2' });
        System.assertEquals('1', thread.thread.id);
    }

    @isTest
    public static void removeMembers_ReturnsFolderList() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        QuipAPI api = new QuipAPI(true);
        ThreadResponse thread = (ThreadResponse)api.removeMembers('1', new List<String> { '1', '2' });
        System.assertEquals('1', thread.thread.id);
    }
}