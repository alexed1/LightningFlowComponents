
/* @author: Munawir
 * @authorEmail: munawirrahman@gmail.com
 * @authorMedium: https://medium.com/@munawirrahman
 * @Description: Callout with Invocable Method
 * @Inputs:
 	* Method ==> (GET, POST, PATCH, PUT, DELETE, TRACE, CONNECT, HEAD, OPTIONS)
        * Endpoint ==> Endpoint (and Query String), support named credential
        * Body ==> Request Body
        * Timeout ==> Request Timeout in millisecond
        * Headers ==> Request Headers, format :[{"key":"Content-Type","value":"application/json"},{"key":"Accept","value":"*\*"}]
        * BodyAsBlob ==> Convert Body to Blob Type
        * Compressed_gzip ==> Compressed Body to gzip
 * @Outputs:
	* Status ==> Status Response in text
	* Status_code ==> Status Response in code
	* Body ==> Response Body
	* CollectionOfHeaders ==> Response headers in List, example: [{"key":"Content-Type","value":"application/json"},{"key":"Accept","value":"*\*"}]
	* Error Message ==> Error Message if there's something wrong with callout
 */
public with sharing class MakeHTTPCall {
    
    public class Request {
        @InvocableVariable(label='Method (GET, POST, PATCH, PUT, DELETE, TRACE, CONNECT, HEAD, OPTIONS)' 
                           required=True description='HTTP Method')
        public String Method;
        @InvocableVariable(label='Endpoint (and Query String)'
                           required=True description='Endpoint (and Query String)')
        public String Endpoint;
        @InvocableVariable(label='Body'description='request Body')
        public String Body;
        @InvocableVariable(label='Timeout in millisecods, default is 10000ms'
                           description='Timeout in milliseconds, default is 10000ms/10s')
        public Integer Timeout;
        @InvocableVariable(label='Params e.g => [{“key”:”queryObject”,”value”:”Account”},{“key”:”queryField”,”value”:”Rating”}]'
                           description='e.g => [{“key”:”queryObject”,”value”:”Account”},{“key”:”queryField”,”value”:”Rating”}]')
        public String Params;
        @InvocableVariable(label='Headers e.g => [{"key":"Content-Type","value":"application/json"},{"key":"Accept","value":"*/*"}]'
                           description='e.g => [{"key":"Content-Type","value":"application/json"},{"key":"Accept","value":"*/*"}]')
        public String Headers;
        @InvocableVariable(label='Body as Blob?'
                           description='Convert Body to Blob if True')
        public Boolean BodyAsBlob;
        @InvocableVariable(label='Compress Body to gzip?'
                           description='If true, the data in the Body is delivered to the Endpoint in the gzip compressed format. If false, no compression format is used.')
        public Boolean Compressed_gzip;
    }
    
    public class Response {
        @InvocableVariable(label='Status')
        public String Status;
        @InvocableVariable(label='Status Code')
        public Integer Status_code;
        @InvocableVariable(label='Body')
        public String Body;
        @InvocableVariable(label='Collection of Headers')
        public List<String> CollectionOfHeaders;
        @InvocableVariable(label='Error Message')
        public String Error_message;
    }
    
    @InvocableMethod(label='Make HTTP Call' description='Make HTTP Call' configurationEditor='c:MakeHTTPCallCPE')
    public static List<Response> Invoke (List<Request> requests) {
        List<Response> responseList = new List<Response>();
        String[] AllowedMethods = new String[]{'GET', 'POST', 'PATCH', 'PUT', 'DELETE', 'TRACE', 'CONNECT', 'HEAD', 'OPTIONS'};
        for (Request curRequest : requests) {
            Response response = new Response();
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            
            //set Method
            if (AllowedMethods.contains(curRequest.Method.toUpperCase())){
                req.setMethod(curRequest.Method.toUpperCase());
            }
            // if Method not in AllowedMethods, return error
            else{
                response.error_message = 'Method Not Allowed';
                System.debug('Method Not Allowed');
                responseList.add(response);
                continue;
            }
            system.debug('setMethod : '+ curRequest.Method.toUpperCase());
            
            //set Endpoint
            String url = curRequest.Endpoint;
            if(String.isNotEmpty(curRequest.Params)) {
                List<QueryParams> listParams = (List<QueryParams>) System.JSON.deserialize(curRequest.Params, List<QueryParams>.class);
                //url+='?';
                List<String> paramsList = new List<string>();
                for (QueryParams param:listParams){
                    if(String.isNotBlank( param.key) && String.isNotBlank( param.key)) {
                        paramsList.add(param.key+'='+EncodingUtil.urlEncode(param.value, 'UTF-8'));
                    }
                       
                    

                    
                }
                if(paramsList.size() > 0) {
                    url += '?' + String.join(paramsList, '&');
                }
            }
            req.setEndpoint(url);
            
            //set Body, there's possibility Body is null
            if (curRequest.BodyAsBlob == True && curRequest.BodyAsBlob != Null){
                req.setBodyAsBlob(Blob.valueof(curRequest.Body));
                system.debug('setBody (As Blob) : '+ Blob.valueof(curRequest.Body));
            }
            else if(curRequest.Body != Null && curRequest.Body != ''){
                req.setBody(curRequest.Body);
                system.debug('setBody : '+curRequest.Body);
            }
			
            //set Timeout. If null, Timeout is 10000ms
            System.debug('curRequest' + curRequest.Timeout);
            if (curRequest.Timeout != null && curRequest.Timeout != 0){
                req.setTimeout(curRequest.Timeout);
                system.debug('setTimeout : '+curRequest.Timeout);
            }
            
            //set Headers, example: [{"key":"Content-Type","value":"application/json"},{"key":"Accept","value":"*/*"}]
            if(curRequest.Headers != Null && curRequest.Headers != ''){
                req = setRequestHeaders(curRequest.Headers,req);}
            	system.debug('setHeaders : '+curRequest.Headers);
            
            //set compress to gzip
            if (curRequest.Compressed_gzip == True && curRequest.Compressed_gzip != Null){
                req.setCompressed(True);
                system.debug('setCompressed succeed');
            }
            
            system.debug('Ready to Callout...' + req);
            
            try {
                HttpResponse res = http.send(req);
                response.Status = res.getStatus();
                response.Status_code = res.getStatusCode();
                response.Body = res.getBody();
                response.CollectionOfHeaders = getResponseHeaders(res);
            }
            catch (CalloutException e) {
                response.error_message = e.getMessage();
            }
            responseList.add(response);
        }
        return responseList;
    }
    
    //construct for parsing Headers
    private class HeaderKeyValue{
        private String key;
        private String value;
    }
    
    //@input example => [{"key":"Content-Type","value":"application/json"},{"key":"Accept","value":"*/*"}]
    //@return req with Header
    private static HTTPRequest setRequestHeaders(String Headers, HTTPRequest req){
        List<HeaderKeyValue> ListHeaders = (List<HeaderKeyValue>) System.JSON.deserialize(Headers, List<HeaderKeyValue>.class);
        for (HeaderKeyValue Header:ListHeaders){
            if(String.isNotEmpty(Header.key)) {
                req.setHeader(Header.key, Header.value);
            }
            System.debug('setHeader Key : '+Header.key+' with value : '+Header.value);
        }
        return req;
    }
    
    //@input res with Header
    //@return list of string example => [{"key":"Content-Type","value":"application/json"},{"key":"Accept","value":"*/*"}]
    private static String[] getResponseHeaders(HTTPResponse res){
        List<String> responseHeaderKeys = res.getHeaderKeys();
        String[] ListHeaders = new String[]{};
        for (String responseHeaderKey:responseHeaderKeys){
            String responseHeaderValue = res.getHeader(responseHeaderKey);
            String singleHeader = '{"key": "'+responseHeaderKey+'","value": "'+responseHeaderValue+'"}';
            system.debug('catchHeader '+'{"key": "'+responseHeaderKey+'","value": "'+responseHeaderValue+'"}');
            ListHeaders.add(singleHeader);
        }
        return ListHeaders;
    }
    private class QueryParams{
        private String key;
        private String value;
    }
}