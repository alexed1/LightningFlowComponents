@isTest
global with sharing class SubscriptionData_MockHTTP  implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        req.setEndpoint('https://salesforce.com/' + 
                        'services/data/v55.0/analytics/' + 
                        'notifications?source=lightningReportSubscribe');
        req.setMethod('GET');
        System.assertEquals('https://salesforce.com/services/data/v55.0/analytics/notifications?source=lightningReportSubscribe', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"thresholds":[{"type":"always","conditions":null,"actions":[{"type":"sendEmail","configuration":{"recipients":[{"type":"user","id":"0055e000001mKpCAAU","displayName":"Andy Haas"}],"excludeSnapshot":false}}]}],"source":"lightningReportSubscribe","schedule":{"frequencyType":null,"frequency":"weekly","details":{"weekInMonth":null,"timeOfDay":18,"daysOfWeek":["tue","wed"],"daysOfMonth":null}},"runAs":null,"recordId":"00O5e000008VIIbEAO","owner":{"name":"Andy Haas","id":"0055e000001mKpCAAU"},"name":"Notification","lastModifiedDate":"2022-10-25T04:28:18.000Z","id":"0Au3C00000000knSAA","deactivateOnTrigger":false,"createdDate":"2022-10-12T23:24:40.000Z","active":true}]');
        res.setStatusCode(200);
        return res;
    }
}