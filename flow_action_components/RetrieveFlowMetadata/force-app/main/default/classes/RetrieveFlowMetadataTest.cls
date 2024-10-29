
@isTest 
public with sharing class RetrieveFlowMetadataTest {

        @isTest
        static void canTransmitRequest() {
    
        HttpRequest req = new HttpRequest();
            HttpResponse response =RetrieveFlowMetadata.transmit(req);
            System.assert(response != null);
        }
    
        @isTest
        static void canPrepareRequest() {
    
            String endpoint = 'https://foo.com';
            String token = 'token';
            String body = 'body';
            HttpResponse curResponse = new HttpResponse();
            curResponse =RetrieveFlowMetadata.Send(endpoint);
            System.assert(curResponse.getBody() == '{"ok":true}');
            }
    
        @isTest
        static  void canExecuteRequest() {

            List<RetrieveFlowMetadata.Request> requestList = new List<RetrieveFlowMetadata.Request>();
            RetrieveFlowMetadata.Request request = new RetrieveFlowMetadata.Request();
            request.flowName='foobar';
            
            requestList.add(request);

            List<RetrieveFlowMetadata.Result> resultsList = RetrieveFlowMetadata.execute(requestList);
            System.debug('resultsList[0].flowMetadata = ' + resultsList[0].flowMetadata );
            System.assert(resultsList[0].flowMetadata ==  RetrieveFlowMetadata.getTestString());
        }

        @isTest
        static  void canPerformInitialParsing() {

            //List<RetrieveFlowMetadata.Request> requestList = new List<RetrieveFlowMetadata.Request>();
           // RetrieveFlowMetadata.Request request = new RetrieveFlowMetadata.Request();
            String rawXMLREsponse=RetrieveFlowMetadata.getTestString();
            
           // requestList.add(request);

           // List<RetrieveFlowMetadata.Result> resultsList = RetrieveFlowMetadata.execute(requestList);
            //System.debug('resultsList[0].flowMetadata = ' + resultsList[0].flowMetadata );

            Dom.XmlNode flowMetadata = RetrieveFlowMetadata.PerformInitialParsingOnQueryResult(rawXMLREsponse);
            System.debug('returning flowmetadata is:' + flowMetadata);
            System.debug('comparison string is:' + getExtractedString());

            System.assert('flowMetadata' == getExtractedString()); //replace 'flowMetadata' with appropriate'
        }

        static String getExtractedString() {
        return  '<?xml version="1.0" encoding="UTF-8"?><Flow xmlns="http://soap.sforce.com/2006/04/metadata"> \n ' +
                ' <actionCalls> \n ' +
                        ' <name>Retrieve_Flow_Metadata</name> \n ' +
                        ' <label>Retrieve Flow Metadata</label> \n ' +
                ' </actionCalls> \n ' +
                '</Flow>';
        }
        


    }