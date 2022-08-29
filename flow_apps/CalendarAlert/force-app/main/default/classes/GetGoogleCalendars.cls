global with sharing class GetGoogleCalendars {
  
    @InvocableMethod
    global static List <Result> execute(List<Request> requestList) {
     

    List<Result> responses = new List<Result>();
    String currentTime = GetCurrentTimeString();
    for (Request curRequest: requestList ){
       /*  String maxResultsString = String.valueOf(curRequest.maxResults);
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
        }  */
        ///calendar/v3/users/me/calendarList
        String endpoint = 'callout:' + curRequest.credName + '/calendar/v3/users/me/calendarList'; //+ curRequest.calendarIdentifier + '/events?';
        String params ='';  /*= 'maxResults=' + maxResultsString + '&orderBy=' + orderBy + '&singleEvents=true&timeMin='+ startTime;
        if(String.isNotEmpty(curRequest.endTime))
            params = params + '&timeMax=' + endTime;
        if(String.isNotEmpty(curRequest.queryString))
            params = params + '&q=' + curRequest.queryString; */
            
        String url = endpoint + params;
        System.debug('call is:' + url);
     
        Map<String,Object> responseMap = new Map<String,Object>();
        Result curResponse = new Result();
        List<GoogleCalendarEvent> eventList = new List<GoogleCalendarEvent>();
        String responseJSON;
        try {
            
            if(!Test.isRunningTest()) {
                System.debug ('url is: ' + url);
                responseJSON = Send(url);
                System.debug('initial responseJSON is: ' + responseJSON);
               
            } else {
                
                String testResponse = '{"ok": true, "channel": {"id": "CXX", "name": "endeavor"}}';
                responseMap = (Map<String, Object>) JSON.deserializeUntyped(testResponse);
                System.debug('response  is: ' + responseMap);
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.INFO,'post error: ' + e);
            curResponse.errors = e.getMessage();
            
        }

        /* //Google returns start times with the key 'datetime', which causes problems in Salesforce, so we map it to something more useful
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

        curResponse.eventList=curEventsList; */
        curResponse.responseBody= responseJSON;
        responses.add(curResponse);
         
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


    global static String  Send(String endpoint) {
        
        String res;
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            //req.setHeader('Authorization', 'Bearer ' + token); //right now you have to use a Named Credential, and can't pass in a raw token
            req.setHeader('Accept-Encoding', 'gzip, deflate, br');
            req.setHeader('Accept', '*/*');
            res = transmit(req);

            
            
            
        } catch (Exception e) {
            System.debug('error:' + e.getMessage());
            throw new InvocableActionException('Error: '+ e.getMessage());
        }

        return res;
    
    }

    global  static  string transmit(HttpRequest req) {
        Http http = new Http();
        System.debug('req is: ' + req);
        System.debug('body is: ' + req.getBody());
        if(!Test.isRunningTest()){
            HttpResponse res = http.send(req);
            System.debug('made it back: ' + res.getBody());
            return res.getBody();
        } else {
            return '{"ok":true}';
        }
    }
    

    global class Request {
      

        @InvocableVariable(required=true)
        global String credName;

       /*  @InvocableVariable(required=true)
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
        global String queryString; */
    }

    global class Result {

        public Result() {
            

        }

        @InvocableVariable
        global String responseBody;

        @InvocableVariable
        global String errors;

       /*  @InvocableVariable
        global List<GoogleCalendarEvent>  eventList;
 */


    }
    public class InvocableActionException extends Exception{}
}
