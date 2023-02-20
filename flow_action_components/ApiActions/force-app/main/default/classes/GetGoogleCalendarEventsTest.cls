@isTest
public with sharing class GetGoogleCalendarEventsTest {
        
    @isTest
    static void canTransmitRequest() {

    HttpRequest req = new HttpRequest();
        HttpResponse response = GetGoogleCalendarEvents.transmit(req);
        System.assert(response != null);
    }

    @isTest
    static void canPrepareRequest() {

        String endpoint = 'https://foo.com';
        String token = 'token';
        String body = 'body';
        GetGoogleCalendarEvents.Result curResponse = new GetGoogleCalendarEvents.Result();
        
        GetGoogleCalendarEvents.Result result = GetGoogleCalendarEvents.Send(endpoint, curResponse);
        System.assert(result != null);
        }

    @isTest
        static  void canExecuteRequest() {

        List<GetGoogleCalendarEvents.Request> requestList = new List<GetGoogleCalendarEvents.Request>();
        GetGoogleCalendarEvents.Request request = new GetGoogleCalendarEvents.Request();
        
        requestList.add(request);

        List<GetGoogleCalendarEvents.Result> resultsList = GetGoogleCalendarEvents.execute(requestList);
        }
}

