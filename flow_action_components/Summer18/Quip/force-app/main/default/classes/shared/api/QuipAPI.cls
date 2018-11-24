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

    public UserResponse getCurrentUser() {   
        String url = 'callout:' + QUIP_URL + '/users/current';
        HttpRequest req = newRequest(url);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return UserResponse.parse(res.getBody());
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

    private static final String TOKEN_PLACEHOLDER = 'Put your token here';

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
