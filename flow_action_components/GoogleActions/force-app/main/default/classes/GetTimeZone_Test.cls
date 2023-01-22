@isTest
public with sharing class GetTimeZone_Test {
    @isTest
    private static void GetTimeZone_Test_Success(){
        // 32.704
        // -97.285
        // OK
        // America/Chicago
        GetTimeZone.Request rq = new GetTimeZone.Request();
        rq.latitude = '32.704';
        rq.longitude = '-97.285';
        rq.googleApiKey = 'AIzaSyDZ2Z1Z2Z1Z2Z1Z2Z1Z2Z1Z2Z1Z2Z1Z1Z';
        list<GetTimeZone.request> rqLst = new list<GetTimeZone.request>();
        rqLst.add(rq);
        
        test.startTest();
        test.setMock(httpCalloutMock.class, new mockSuccess());
        GetTimeZone.GetTimeZone(rqLst);
        test.stopTest();
    }
    public class mockSuccess implements httpCalloutMock {
        public system.HttpResponse respond(system.HttpRequest req){
            httpResponse resp = new system.HttpResponse();
            resp.setStatusCode(200);
            resp.setStatus('OK');
            resp.setHeader('Content-Type', 'application/json');
            string jsonInp = '{' + '\n';
            jsonInp += '"dstOffset": 3600,' + '\n';
            jsonInp += '"rawOffset": -21600,' + '\n';
            jsonInp += '"status": "OK",' + '\n';
            jsonInp += '"timeZoneId": "America/Chicago",' + '\n';
            jsonInp += '"timeZoneName": "Central Daylight Time"' + '\n';
            jsonInp += '}';
            resp.setBody(jsonInp);
            return resp;
        }
    }

    @isTest
    private static void GetTimeZone_Test_Fail(){
        // 32.704
        // -97.285
        // OK
        // America/Chicago
        GetTimeZone.Request rq = new GetTimeZone.Request();
        rq.latitude = '32.704';
        rq.longitude = '-97.285';
        rq.googleApiKey = 'AIzaSyDZ2Z1Z2Z1Z2Z1Z2Z1Z2Z1Z2Z1Z2Z1Z1Z';
        list<GetTimeZone.request> rqLst = new list<GetTimeZone.request>();
        rqLst.add(rq);
        
        test.startTest();
        test.setMock(httpCalloutMock.class, new mockFail());
        GetTimeZone.GetTimeZone(rqLst);
        test.stopTest();
    }
    public class mockFail implements httpCalloutMock {
        public system.HttpResponse respond(system.HttpRequest req){
            httpResponse resp = new system.HttpResponse();
            resp.setStatusCode(500);
            resp.setStatus('ERROR');
            resp.setHeader('Content-Type', 'application/json');
            string jsonInp = '{' + '\n';
            jsonInp += '"status": "INVALID REQUEST",' + '\n';
            jsonInp += '}';
            resp.setBody(jsonInp);
            return resp;
        }
    }
}