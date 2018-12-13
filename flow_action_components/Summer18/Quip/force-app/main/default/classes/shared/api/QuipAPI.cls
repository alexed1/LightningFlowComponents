public class QuipAPI implements IQuipAPI {
    
    private static final String QUIP_URL = 'quip';

    private static final Integer ID_LENGTH = 12;

    private String apiKey;

    public QuipAPI() {
    }

    public Boolean likeId(String id) {
        if (String.isBlank(id)) {
            return false;
        }
        if (id.length() != ID_LENGTH) {
            return false;
        }
        if (id.contains(' ')) {
            return false;
        }
        return true;
    }

    public CurrentUserResponse getCurrentUser() {   
        String url = 'callout:' + QUIP_URL + '/users/current';
        HttpRequest req = newRequest(url);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return CurrentUserResponse.parse(res.getBody());
    }

    public ThreadResponse getThread(String id) {
        String url = 'callout:' + QUIP_URL + '/threads/' + EncodingUtil.urlEncode(id, 'UTF-8');
        HttpRequest req = newRequest(url);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return ThreadResponse.parse(res.getBody());
    }

    public ThreadListResponse getThreadList(List<String> id) {
        List<String> idList = new List<String>();
        for (String rawId: id) {
            idList.add(EncodingUtil.urlEncode(rawId, 'UTF-8'));
        }
        String url = 'callout:' + QUIP_URL + '/threads/?ids=' + String.join(idList, ',');
        HttpRequest req = newRequest(url);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return ThreadListResponse.parse(res.getBody());
    }

    public FolderResponse getFolder(String id) {
        String url = 'callout:' + QUIP_URL + '/folders/' + EncodingUtil.urlEncode(id, 'UTF-8');
        HttpRequest req = newRequest(url);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return FolderResponse.parse(res.getBody());
    }

    public FolderListResponse getFolderList(List<String> id) {
        List<String> idList = new List<String>();
        for (String rawId: id) {
            idList.add(EncodingUtil.urlEncode(rawId, 'UTF-8'));
        }
        String url = 'callout:' + QUIP_URL + '/folders/?ids=' + String.join(idList, ',');
        HttpRequest req = newRequest(url);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return FolderListResponse.parse(res.getBody());
    }

    public ThreadResponse editDocument(String threadId, String content, String sectionId, SectionLocation location) {
        String url = 'callout:' + QUIP_URL + '/threads/edit-document'; 
        HttpRequest req = newRequest(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String body = 'thread_id=' + threadId 
                    + '&content=' + EncodingUtil.urlEncode(content, 'UTF-8')
                    + '&format=html&section_id=' + sectionId
                    + '&location=' + String.valueOf(location.valueOf());
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return ThreadResponse.parse(res.getBody());
    }

    public ThreadResponse createDocument(String title, String content, String type, List<String> usersAndFolders) {
        String url = 'callout:' + QUIP_URL + '/threads/new-document';
        HttpRequest req = newRequest(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String body = 'title=' + EncodingUtil.urlEncode(title, 'UTF-8')
                    + '&content=' + EncodingUtil.urlEncode(content, 'UTF-8')
                    + '&format=html&type=' + type;
        if (usersAndFolders != null && usersAndFolders.size() > 0) {
            body += '&member_ids=' + String.join(usersAndFolders,',');
        }
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return ThreadResponse.parse(res.getBody());
    }

    public FolderResponse createFolder(String title, String parentId) {
        String url = 'callout:' + QUIP_URL + '/folders/new';
        HttpRequest req = newRequest(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String body = 'title=' + EncodingUtil.urlEncode(title, 'UTF-8')
                    + '&parent_id=' + EncodingUtil.urlEncode(parentId, 'UTF-8');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return FolderResponse.parse(res.getBody());
    }

    public Response addMembers(String threadId, List<String> usersAndFolders) {
        if (usersAndFolders == null || usersAndFolders.size() == 0) {
            return new Response();
        }
        String url = 'callout:' + QUIP_URL + '/threads/add-members';
        HttpRequest req = newRequest(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String body = 'thread_id=' + EncodingUtil.urlEncode(threadId, 'UTF-8')
                    + '&member_ids=' + String.join(usersAndFolders,',');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return ThreadResponse.parse(res.getBody());
    }

    public Response removeMembers(String threadId, List<String> usersAndFolders) {
        if (usersAndFolders == null || usersAndFolders.size() == 0) {
            return new Response();
        }
        String url = 'callout:' + QUIP_URL + '/threads/remove-members';
        HttpRequest req = newRequest(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String body = 'thread_id=' + EncodingUtil.urlEncode(threadId, 'UTF-8')
                    + '&member_ids=' + String.join(usersAndFolders,',');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return ThreadResponse.parse(res.getBody());
    }

    public Response editFolder(String folderId, String newName) {        
        String url = 'callout:' + QUIP_URL + '/folders/update';
        HttpRequest req = newRequest(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String body = 'folder_id=' + EncodingUtil.urlEncode(folderId, 'UTF-8')
                    + '&title=' + EncodingUtil.urlEncode(newName, 'UTF-8');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return FolderResponse.parse(res.getBody());
    }

    public UserListResponse getUsers(List<String> idsOrEmails) {
        if (idsOrEmails == null || idsOrEmails.size() == 0) {
            return new UserListResponse();
        }
        String url = 'callout:' + QUIP_URL + '/users/?ids=' + String.join(idsOrEmails, ',');
        HttpRequest req = newRequest(url);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return UserListResponse.parse(res.getBody());
    }

    private HttpRequest newRequest(String url) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');        
        req.setHeader('Accept', 'application/json, text/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + getApiKey());
        req.setTimeout(20 * 1000);
        return req;
    }

    private static final String TOKEN_LABEL = 'Token';

    private static final String TOKEN_PLACEHOLDER = 'Replace with Valid Token';

    private String getApiKey() {
        if (String.isBlank(apiKey)) {
            List<Quip_Access_Token__mdt> tokens = [SELECT Token__c FROM Quip_Access_Token__mdt WHERE Label = 'Token'];
            if (tokens.size() == 0) {
                throw new QuipException('The item labeled "' + TOKEN_LABEL + '" of "Quip Access Token" custom metadata type was not found');
            }
            if (tokens[0].Token__c == TOKEN_PLACEHOLDER) {
                throw new QuipException('You should set your Quip API key on the item of "Quip Access Token" type labeled "' + TOKEN_LABEL + '"');
            }
            apiKey = tokens[0].Token__c;
        }
        return apiKey;
    }
}
