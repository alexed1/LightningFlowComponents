@isTest
public with sharing class GenerateMarketingCloudTokenTest {
    
    @isTest
    static void canTransmitRequest() {

        HttpRequest req = new HttpRequest();
           String response = GenerateMarketingCloudToken.transmit(req);
           System.assert(response != null);
        }
    
        @isTest
        static void canPrepareRequest() {
    
            String endpoint = 'https://mcgs269vcy2ztdsfpt5bjwv1mfl1.rest.marketingcloudapis.com';
            String token = 'token';
            String body = 'body';
            GenerateMarketingCloudToken.Result curResponse = new GenerateMarketingCloudToken.Result();
            
            GenerateMarketingCloudToken.Result result = GenerateMarketingCloudToken.Send(endpoint, token, curResponse);
            System.assert(result != null);
            }
    
        @isTest
         static  void canExecuteRequest() {
    
            List<GenerateMarketingCloudToken.Request> requestList = new List<GenerateMarketingCloudToken.Request>();
            GenerateMarketingCloudToken.Request request = new GenerateMarketingCloudToken.Request();
            requestList.add(request);
    
            List<GenerateMarketingCloudToken.Result> resultsList = GenerateMarketingCloudToken.execute(requestList);
         }
    
}
