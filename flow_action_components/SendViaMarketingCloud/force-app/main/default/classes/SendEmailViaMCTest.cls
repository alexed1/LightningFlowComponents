@isTest
public with sharing class SendEmailViaMCTest {

    static testMethod void canTransmitRequest() {

    HttpRequest req = new HttpRequest();
       String response = SendEmailViaMC.transmit(req);
       System.assert(response != null);
    }

    static testMethod void canPrepareRequest() {

        String endpoint = 'https://mcgs269vcy2ztdsfpt5bjwv1mfl1.rest.marketingcloudapis.com/messaging/v1/email/messages/';
        String token = 'token';
        String body = 'body';
        SendEmailViaMC.Result curResponse = new SendEmailViaMC.Result();
        
        SendEmailViaMC.Result result = SendEmailViaMC.Send(endpoint, token, body, curResponse);
        System.assert(result != null);
        }

     static testMethod void canExecuteRequest() {

        List<SendEmailViaMC.Request> requestList = new List<SendEmailViaMC.Request>();
        SendEmailViaMC.Request request = new SendEmailViaMC.Request();
        requestList.add(request);

        List<SendEmailViaMC.Result> resultsList = SendEmailViaMC.execute(requestList);
     }



}
