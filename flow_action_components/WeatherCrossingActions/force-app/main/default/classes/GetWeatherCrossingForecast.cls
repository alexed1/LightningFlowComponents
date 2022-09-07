global with sharing class GetWeatherCrossingForecast {

    @InvocableMethod
    global static List <Result> execute(List<Request> requestList) {
     

        List<Result> responses = new List<Result>();

        for (Request curRequest: requestList ){
            String locations = EncodingUtil.urlEncode(curRequest.locations, 'UTF-8');
            
            String token = curRequest.key;
            String aggregateHours = curRequest.aggregateHours;
            String contentType;
            String unitGroup;
            if (String.isEmpty(curRequest.contentType)){
                contentType = 'json';
            } else contentType = curRequest.contentType;
            if (String.isEmpty(curRequest.unitGroup)){
                unitGroup = 'us';
            } else unitGroup = curRequest.unitGroup;

            String endpoint = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?';
            String params = 'key=' + token+ '&locations=' + locations + '&aggregateHours='+ aggregateHours +'&contentType='+ contentType +'&unitGroup='+ unitGroup;
                
            String url = endpoint + params;
            System.debug('call is:' + url);
        
            Map<String,Object> responseMap = new Map<String,Object>();
            Result curResponse = new Result();
            
            String responseJSON;
            WeatherReport curWeatherReport = new WeatherReport();
            WeatherResultSet curWeatherResultSet = new WeatherResultSet();
           // curWeatherResultSet = (WeatherResultSet)System.JSON.deserialize(curResponse.responseBody, WeatherResultSet.class);

           //the Locations data is not well formed and has to be parsed out by hand
           List<WeatherLocation> curWeatherLocationList = new List<WeatherLocation>();
           WeatherLocation curLocation = new WeatherLocation();

            System.debug ('url is: ' + url);
            try {
                
                if(!Test.isRunningTest()) {
               
                    curResponse = Send(url, curResponse);
                  
                
                } else {
                    
                     curResponse.responseBody = '{"ok": true, "channel": {"id": "CXX", "name": "endeavor"}}';
                    curResponse.errors = 'errortext';
                    curWeatherLocationList.add(curLocation);
                }
            } catch (Exception e) {
                System.debug(LoggingLevel.INFO,'post error: ' + e);
                curResponse.errors = e.getMessage();
                
            }
            System.debug('errors is: ' + curResponse.errors);
            System.debug('initial responseBody is: ' + curResponse.responseBody);

          
           JSONParser parser = JSON.createParser(curResponse.responseBody);
           while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'locations')) {
                parser.nextToken(); // '{'
                parser.nextToken(); // 'San Francisco'
                
                while (parser.nextToken() != null) {
                    system.debug('current parser values is: ' + parser.getText());
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        // Read entire invoice object, including its array of line items.
                        curLocation = (WeatherLocation)parser.readValueAs(WeatherLocation.class);
                        system.debug('weather distance: ' + curLocation.distance);
                        //system.debug('Size of list items: ' + inv.lineItems.size());
                        // For debugging purposes, serialize again to verify what was parsed.
                        //String s = JSON.serialize(inv);
                        //system.debug('Serialized invoice: ' + s);

                     
                        curWeatherLocationList.add(curLocation);
                        System.debug ('location is: ' + curLocation);
                    }
                
                }
             }
            }



            curResponse.fullLocationsReport = curWeatherLocationList;
            curResponse.singleLocationReport = curWeatherLocationList[0];


            responses.add(curResponse);
            
        }
        return responses;
}


    global static Result  Send(String endpoint, Result curResponse ) {
        
        String res;
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'text/plain');
            //req.setHeader('Authorization', 'Bearer ' + token); //right now you have to use a Named Credential, and can't pass in a raw token
            req.setHeader('Accept-Encoding', 'gzip, deflate, br');
            req.setHeader('Accept', '*/*');
            res = transmit(req);
            curResponse.responseBody = res;
            
            
            
        } catch (Exception e) {
            System.debug('error:' + e.getMessage());
            //throw new InvocableActionException('Error: '+ e.getMessage());
            curResponse.errors=e.getMessage();
        }

        return curResponse;
    
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
        global String key;

        @InvocableVariable(required=true)
        global String locations;

        @InvocableVariable(label='aggregateHours - The interval between weather forecast data in the output. 1 represents an hourly forecast, 24 represents a daily forecast.')
        global String aggregateHours;

        @InvocableVariable(label='Format -  this can be csv or json. default is json')
        global String contentType;

        @InvocableVariable(label='Unit Group - set to us, metric, uk, or base')
        global String unitGroup;

 
    }

    global class Result {

        public Result() {
            

        }

        @InvocableVariable
        global String responseBody;

        @InvocableVariable
        global String errors;

        @InvocableVariable
        global WeatherLocation[] fullLocationsReport;

        @InvocableVariable
        global WeatherLocation singleLocationReport; //the first entry in the array

 



    }
    public class InvocableActionException extends Exception{}
}
