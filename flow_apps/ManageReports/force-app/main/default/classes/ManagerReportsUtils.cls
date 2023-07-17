public with sharing class ManagerReportsUtils {
    public ManagerReportsUtils() {

    }

    public static HttpResponse  Send(String endpoint) {
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');

        HttpResponse res;
        res = transmit(req);
        String body = res.getBody();
        System.debug('back from transmit. body is: ' + body);
        return res;
    }

    public static HttpResponse transmit(HttpRequest req) {
        Http http = new Http();
        System.debug('req is: ' + req);
        System.debug('body is: ' + req.getBody());
        if(!Test.isRunningTest()){
            HttpResponse res = http.send(req);
            return res;
        } else {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"ok":true}');
            return res;
        }
    }
}