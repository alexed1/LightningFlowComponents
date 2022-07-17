global with sharing class GetGoogleCalendarEvents {
 

    @InvocableMethod
    global static List <Result> execute(List<Request> requestList) {
     

    List<Result> responses = new List<Result>();
    String currentTime = GetCurrentTimeString();
    for (Request curRequest: requestList ){
        //String endpoint = 'https://www.googleapis.com/discovery/v1/apis/calendar/v3/rest';
        //this works to get the list of all cals: String endpoint = 'callout:GoogleCredential/calendar/v3/users/me/calendarList';
        String endpoint = 'callout:GoogleCredential/calendar/v3/calendars/aedelstein@salesforce.com/events?';
        String params = 'maxResults=3&orderBy=startTime&singleEvents=true&timeMin='+ currentTime;
        String url = endpoint + params;
        System.debug('call is:' + url);
     
       // String endpoint = AIzaSyASmhaizFZ2oYvIzVgGb0q4BgnoEBel8mc
        String token = curRequest.token;
        Map<String,Object> responseMap = new Map<String,Object>();
        Result curResponse = new Result();
        List<GoogleCalendarEvent> eventList = new List<GoogleCalendarEvent>();
        String responseJSON;
        try {
            
            if(!Test.isRunningTest()) {
               // String body = '{"roomId": "'+curRequest.roomId+'","text":"' + curRequest.text + '"}';
                System.debug ('url is: ' + url);
                responseJSON = Send(url, token);
                System.debug('initial responseJSON is: ' + responseJSON);
               
                //responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseJSON);

                //System.debug('response after deserialization is  is: ' + responseMap);
            } else {
                
                String testResponse = '{"ok": true, "channel": {"id": "CXX", "name": "endeavor"}}';
                responseMap = (Map<String, Object>) JSON.deserializeUntyped(testResponse);
                System.debug('response  is: ' + responseMap);
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.INFO,'post error: ' + e);
            curResponse.errors = e.getMessage();
            
        }

        //Google returns start times with the key 'datetime', which causes problems in Salesforce, so we map it to something more useful
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


    global static String  Send(String endpoint, String token) {
        
        String res;
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
           // req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('Accept-Encoding', 'gzip, deflate, br');
            req.setHeader('Accept', '*/*');

            //req.setBody(body);
            //System.debug('set body to:' + body);
            //System.debug('req is: ' + req);
            res = transmit(req);
           // System.debug('First Response back is: ' + res);
            
            
            
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
        global String token;

        @InvocableVariable
        global String text ;

        @InvocableVariable
        global String roomId ;
    }

    global class Result {

        public Result() {
            

        }

        @InvocableVariable
        global String responseBody;

        @InvocableVariable
        global String errors;

        @InvocableVariable
        global List<GoogleCalendarEvent>  eventList;



    }
    public class InvocableActionException extends Exception{}
}
