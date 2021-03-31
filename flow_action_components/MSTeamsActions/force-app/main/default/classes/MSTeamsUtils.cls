public with sharing class MSTeamsUtils {
    public final static STRING GET_METHOD = 'GET';
    public final static STRING POST_METHOD = 'POST';
    public final static STRING DELETE_METHOD = 'DELETE';
    public static HTTPRequest prepareHTTPRequest(String endpoint, String method, String body, String token) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(method);
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        if(String.isNotEmpty(body)) {
            
            req.setBody(body);
        }
        return req;
    }

    public static String getErrorMessageFromResponse(String responseBody) {
        MSTeamsEntity errorEntity = (MSTeamsEntity)JSON.deserialize(responseBody, MSTeamsEntity.class);
        if(errorEntity != null && errorEntity.error != null){
            return errorEntity.error.code + ' : ' + errorEntity.error.message;
        }
        return null;
    }
    public class MSTeamsEntity {
        public String id;
        public String displayName;
        public MSteamsError error;

        public MSTeamsEntity() {

        }

        public MSTeamsEntity(String id, String displayName) {
            this.id = id;
            this.displayName = displayName;
        }
    }

    public class MSTeamsError {
        String code;
        String message;
    }

}
