public class GoogleMapsAPI implements IGoogleMapsAPI {

    private static final String TOKEN_PLACEHOLDER = 'Replace with Valid Token';

    private static final String GOOGLE_MAPS_CREDENTIALS = 'google_maps';

    private Boolean allowEmptyKey;
    
    public GoogleMapsAPI(Boolean allowEmptyKey) {
        this.allowEmptyKey = allowEmptyKey;
    }

    private String apiKey;

    private String getApiKey() {
        if (allowEmptyKey) {
            return '';
        }
        if (apiKey == null) {
            List<Google_API_Key__mdt> keys = [SELECT Key__c FROM Google_API_Key__mdt];
            if (keys.size() == 0) {
                throw new GoogleException('There are no objects of custom metadata type "Google API Key"');
            }
            
            if (TOKEN_PLACEHOLDER.equalsIgnoreCase(keys[0].Key__c)) {
                throw new GoogleException('You should set your Google API key on the item of "Google API Key" type labeled');
            }
            apiKey = keys[0].Key__c;            
        }
        return apiKey;    
    }
    
    private HttpRequest newRequest(String url) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');        
        req.setHeader('Accept', 'application/json, text/json');
        req.setHeader('Content-Type', 'application/json');
        return req;
    }

    public RoutesResponse getDistanceBetween(String source, String destination) {
        if (String.isBlank(source)) {
            throw new GoogleException('Source was not specified');
        }
        if (String.isBlank(destination)) {
            throw new GoogleException('Destination was not specified');
        }
        System.debug(String.format('Looking for the routes between {0} and {1}', new List<String> { source, destination }));
        String url = String.format(
            'callout:{0}/distancematrix/json?origins={1}&destinations={2}&key={3}',
            new List<String> { 
                GOOGLE_MAPS_CREDENTIALS,
                EncodingUtil.urlEncode(source, 'UTF-8'),
                EncodingUtil.urlEncode(destination, 'UTF-8'),
                getApiKey()
            });
        HttpRequest request = newRequest(url);
        Http http = new Http();
        HTTPResponse response = http.send(request);
        return RoutesResponse.parseJson(response.getBody());     
    }
}
