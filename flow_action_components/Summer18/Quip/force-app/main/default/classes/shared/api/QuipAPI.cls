public class QuipAPI {
    
    //We'll store it somewhere else later
    private static final String QUIP_URL = 'https://platform.quip.com/1';

    private String apiKey;

    public QuipAPI(String apiKey) {
        if (String.isBlank(apiKey)) {
            throw new QuipException('Api key can\'t be empty or blank');
        }
        this.apiKey = apiKey;
    }

    public UserResponse GetCurrentUser() {   
        String url = QUIP_URL + '/users/current';
        HttpRequest req = newRequest(url);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return UserResponse.parse(res.getBody());
    }

    private HttpRequest newRequest(String url) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');        
        req.setHeader('Accept', 'application/json, text/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + apiKey);
        return req;
    }
}
