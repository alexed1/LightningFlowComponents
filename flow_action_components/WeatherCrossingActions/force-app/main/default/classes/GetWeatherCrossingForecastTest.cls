@isTest
public with sharing class GetWeatherCrossingForecastTest {

    @isTest
    static void canTransmitRequest() {

        HttpRequest req = new HttpRequest();
           String response = GetWeatherCrossingForecast.transmit(req);
           System.assert(response != null);
        }
    
        @isTest
        static void canPrepareRequest() {
    
            String endpoint = 'https://foo.com';
            String token = 'token';
            String body = 'body';
            GetWeatherCrossingForecast.Result curResponse = new GetWeatherCrossingForecast.Result();
            
            GetWeatherCrossingForecast.Result result = GetWeatherCrossingForecast.Send(endpoint, curResponse);
            System.assert(result != null);
            }
    
        @isTest
         static  void canExecuteRequest() {
    
            List<GetWeatherCrossingForecast.Request> requestList = new List<GetWeatherCrossingForecast.Request>();
            GetWeatherCrossingForecast.Request request = new GetWeatherCrossingForecast.Request();
            request.locations = 'placeholder';
            requestList.add(request);
    
            List<GetWeatherCrossingForecast.Result> resultsList = GetWeatherCrossingForecast.execute(requestList);
         }
}
