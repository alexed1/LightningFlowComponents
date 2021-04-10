public with sharing class MSTeamsUtils {
    public final static String GET_METHOD = 'GET';
    public final static String POST_METHOD = 'POST';
    public final static String DELETE_METHOD = 'DELETE';
    public final static String PRIVATE_MEMBERSHIP = 'private';
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
        String result;
        MSTeamsEntity errorEntity = (MSTeamsEntity)JSON.deserialize(responseBody, MSTeamsEntity.class);
        if(errorEntity != null && errorEntity.error != null){
            result = errorEntity.error.code + ' : ' + errorEntity.error.message;
        }
        return result;
    }
    public class MSTeamsEntity {
        public String id;
        public String displayName;
        public MSteamsError error;
        public String membershipType;

    }

    public class MSTeamsError {
        String code;
        String message;
    }

}