public with sharing class RunFlowOnAnotherOrg {

    static final String RUN_FLOW_URL = '{0}/services/data/v51.0/actions/custom/flow/{1}';
    static final String GET_TOKEN_URL = '{0}/services/oauth2/token';
    static final String GET_TOKEN_BODY = 'grant_type=password&' +
    'client_id={0}&' +
    'client_secret={1}&' +
    'username={2}&' +
    'password={3}';
    static final String ERROR_MESSAGE = 'error';
    static final String SUCCESS_MESSAGE = 'success';
    static final String POST_METHOD = 'POST';

    @InvocableMethod(label='Run Flow on Another Org' description='Run Flow on Another Org' callout=true configurationEditor='c:runFlowOnAnotherOrgCPE')
    static public List<Response> execute(List<Request> requestList) {
        List<response> responseList = new List<response>();
        for(Request request: requestList) {
            Response resp = new Response();
            if(request.useFutureMethod) {
                launchFuture(JSON.serialize(request));
            } else {
                HTTPResponse res = sendRequest(request);
            
                if(res.getStatusCode() == 200) {
                    resp.result = SUCCESS_MESSAGE;
                } else {
                    resp.result = ERROR_MESSAGE;
                }
                
            }
            responseList.add(resp);
            
        }
        return responseList;
    }

    static HttpResponse sendRequest(Request request) {
        System.debug('sending request: ' + JSON.serialize(request));
        HttpRequest req = new HttpRequest();
        req.setEndpoint(String.format(RUN_FLOW_URL, new List<String> {request.baseOrgURL, request.flowName}));
        req.setMethod(POST_METHOD);
        String accessToken = getAccessToken(request);
        //'Basic client_id=' + request.consumerSecret + '&client_secret=' + request.consumerSecret;
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept','application/json');
        String postBody = '';
        if(String.isNotEmpty(request.inputsJSON)) {
            List<InputParam> inputList = (List<InputParam>) JSON.deserialize(request.inputsJSON, List<InputParam>.class);
            Map<String, String> inputMap = new Map<String,String>();

            for (InputParam param : inputList){
                if(String.isNotBlank( param.key)) {
                    inputMap.put(param.key, param.value);
                }                 
            }
            if(inputMap.size() > 0) {
                postBody += '{ "inputs" :  ' + JSON.serialize(new List<Object> {inputMap}) + ' }';
            }
        }
        req.setBody(postBody);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug ('response is: ' + res.getBody());
        return res;
    }

    static String getAccessToken(Request request) {
        HttpRequest req = new HttpRequest();
        String accessToken = '';
        req.setEndpoint(String.format(GET_TOKEN_URL, new List<String> {request.baseOrgURL}));
        req.setMethod(POST_METHOD);

        req.setBody(String.format(GET_TOKEN_BODY, new List<String>{request.consumerKey, request.consumerSecret, request.username, request.password}));
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if(res.getStatusCode() == 200) {
            Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
            accessToken = (String)responseMap.get('access_token');
        }

        return accessToken;
    }
    @future(callout=true)
    private static void launchFuture(String requestJSON) {
        Request request = (Request)JSON.deserialize(requestJSON, Request.class);
        sendRequest(request);
    }
    public class Request {
        @InvocableVariable(label='Base URL of the org' required=true)
        public String baseOrgURL;

        @InvocableVariable(label='Consumer Key' required=true)
        public String consumerKey;

        @InvocableVariable(label='Consumer Secret' required=true)
        public String consumerSecret;

        @InvocableVariable(label='username' required=true)
        public String username;

        @InvocableVariable(label='password' required=true)
        public String password;

        @InvocableVariable(label='Name of the flow' required=true)
        public String flowName;

        @InvocableVariable
        public Boolean useFutureMethod = false;
        

        @InvocableVariable(label='inputsJSON')
        public String inputsJSON;
    }

    public class Response{
        @InvocableVariable
        public String result;
    }

    private class InputParam{
        private String key;
        private String value;
    }
}
