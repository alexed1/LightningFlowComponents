global with sharing class GetGoogleCalendarEvents {
 

    @InvocableMethod
    global static List <Result> execute(List<Request> requestList) {
     

    List<Result> responses = new List<Result>();
    String currentTime = GetCurrentTimeString();
    for (Request curRequest: requestList ){
        String maxResultsString = String.valueOf(curRequest.maxResults);
        if (String.isEmpty(maxResultsString)){
            maxResultsString = '3';
        }

        String orderBy;
        if (String.isEmpty(curRequest.orderBy))
            orderBy = 'startTime';
       
        String startTime= curRequest.startTime;
        String endTime = curRequest.endTime;
        if(String.isEmpty(startTime)){
            startTime = GetCurrentTimeString();
        } 

        String endpoint = 'callout:' + curRequest.credName + '/calendar/v3/calendars/' + curRequest.calendarIdentifier + '/events?';
        String params = 'maxResults=' + maxResultsString + '&orderBy=' + orderBy + '&singleEvents=true&timeMin='+ startTime;
        if(String.isNotEmpty(curRequest.endTime))
            params = params + '&timeMax=' + endTime;
        if(String.isNotEmpty(curRequest.queryString))
            params = params + '&q=' + curRequest.queryString;
            
        String url = endpoint + params;
        System.debug('call is:' + url);
     
        Map<String,Object> responseMap = new Map<String,Object>();
        Result curResponse = new Result();
        List<GoogleCalendarEvent> eventList = new List<GoogleCalendarEvent>();
        String responseJSON;
        Result curResult = new Result();
        try {
            
            if(!Test.isRunningTest()) {
                System.debug ('url is: ' + url);
                curResult = Send(url, curResponse);
                
                
               
            } else {
                
                String testResponse = '{"ok": true, "channel": {"id": "CXX", "name": "endeavor"}}';
                responseMap = (Map<String, Object>) JSON.deserializeUntyped(testResponse);
                System.debug('response  is: ' + responseMap);
                curResult.responseBody = testResponse;
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.INFO,'post error: ' + e);
            curResponse.errors = e.getMessage();
            curResponse.status = false;
            
        }

        responseJSON = curResult.responseBody;
        System.debug('initial responseJSON is: ' + responseJSON);
        responseJSON = responseJSON.replace('"dateTime"', '"startTime"');
        System.debug('modified responseJSOn is: ' + responseJSON);
        curResponse.responseBody= responseJSON;
        //(GoogleCalendarEvent) System.JSON.deserialize(json, GoogleCalendarEvent.class);
        GoogleCalendarEventSet curEventSet  = new GoogleCalendarEventSet();
        GoogleCalendarEvent curEvent = new GoogleCalendarEvent();
        curEventSet = (GoogleCalendarEventSet)System.JSON.deserialize(responseJSON, GoogleCalendarEventSet.class);
        System.debug('curEventSet parsed out is: ' + curEventSet);
        List<GoogleCalendarEvent> curEventsList = curEventSet.items;
        System.debug('event list  is: ' + curEventsList);

        curResponse.eventList=curEventsList;
        curResponse.status= true;
        responses.add(curResponse);

        //Google returns start times with the key 'datetime', which causes problems in Salesforce, so we map it to something more useful
        
         
    }
    return responses;
}

    public static String GetCurrentTimeString() {
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = Datetime.now();
        Integer offset = tz.getOffset(dt)/1000;
        system.debug('current time at UTC0 ' + dt);
        system.debug('Offset ' + tz.getOffset(dt)/1000);
        DateTime localTime = dt.addSeconds(-offset);
        system.debug('current time with tz offset: ' + dt.format() );
        String localTimeString = localTime.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        system.debug('current time in Zulu format: ' + localTimeString );
        return localTimeString;
    }


    global static Result  Send(String endpoint, Result curResponse) {
        
        HttpResponse res;
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            //req.setHeader('Authorization', 'Bearer ' + token); //right now you have to use a Named Credential, and can't pass in a raw token
            req.setHeader('Accept-Encoding', 'gzip, deflate, br');
            req.setHeader('Accept', '*/*');
            res = transmit(req);

            if(res.getStatusCode() != 200) {
                throw new InvocableActionException(res.getBody());
            }
            curResponse.responseBody = res.getBody();
            
        } catch (Exception e) {
            System.debug('error:' + e.getMessage());
            //throw new InvocableActionException('Error: '+ e.getMessage());
            curResponse.errors=e.getMessage();
        }

        return curResponse;
    
    }

    global  static  HttpResponse transmit(HttpRequest req) {
        Http http = new Http();
        System.debug('req is: ' + req);
        System.debug('body is: ' + req.getBody());
        if(!Test.isRunningTest()){
            HttpResponse res = http.send(req);
            System.debug('made it back: ' + res);
            System.debug('made it back: ' + res.getBody());
            return res;
        } else {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"ok":true}');
            return res;
        }
    }
    

    global class Request {
      

        @InvocableVariable(required=true)
        global String credName;

        @InvocableVariable(required=true)
        global String calendarIdentifier;

        @InvocableVariable(label='Max Results - defaults to 3')
        global Integer maxResults;

        @InvocableVariable(label='Sort Order - allowable values are \'start time\'  and \'updated\'')
        global String orderBy;

        @InvocableVariable(label='Start Time - requires RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00. If left null or empty, the current time will be used')
        global String startTime;

        @InvocableVariable(label='End Time - requires RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00.')
        global String endTime;

        @InvocableVariable(label='Search Query - this will do a free text search on summary, description, location, attendee\'s displayName, attendee\'s email')
        global String queryString;
    }

    global class Result {

        public Result() {
            

        }

        @InvocableVariable
        global String responseBody;

        @InvocableVariable
        global String errors;

        @InvocableVariable
        global Boolean status;

        @InvocableVariable
        global List<GoogleCalendarEvent>  eventList;



    }
    public class InvocableActionException extends Exception{}
}
