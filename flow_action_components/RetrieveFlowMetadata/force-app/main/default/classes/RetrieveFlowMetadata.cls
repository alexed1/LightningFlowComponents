global with sharing class RetrieveFlowMetadata {
 
  
        @InvocableMethod(label='Retrieve Flow Metadata' description='Retrieve Flow Metadata')
        global static List<Result> execute (List<Request> requestList) {
            
            System.debug('entering Retrieve Flow Metadata');
            List<Result> results =  new List<Result>();
            
            for (Request curRequest: requestList) {
                String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
                HttpResponse response = new HttpResponse();
                Result curResult = new Result();
                
                String flowName = curRequest.flowName;
                String url = baseUrl + '/services/data/v57.0/tooling/query/?q=Select+id,Metadata+from+Flow+Where+Definition.DeveloperName=\'' + flowName + '\''; 

                if(!Test.isRunningTest()) {
                    response = Send(url);  
                    System.debug('response body string is: ' + response.getBody());            
                    if(response.getStatusCode() != 200) {
                        throw new InvocableActionException(response.getBody());
                    }
                    String flowMetadata  = ExtractFlowMetadata(response.getBody());  
                    System.debug('flow metadata = ' + flowMetadata);
                    curResult.flowMetadata = flowMetadata;
                } else {               
                    String testResponse = getTestString();
                    response.setBody(testResponse);
                    curResult.flowMetadata = testResponse;
                }
                


                results.add(curResult);
            }
            return results;
        }



        //flow xml retrieved via the tooling api looks like this:
  /*           <?xml version="1.0" encoding="UTF-8"?>
            <QueryResult xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:mns="urn:metadata.tooling.soap.sforce.com">
                <done>true</done>
                <entityTypeName>Flow</entityTypeName>
                <queryLocator xsi:nil="true" />
                <records type="Flow">
                    <Id>3018B0000006gETQAY</Id>
                    <sf:Metadata>
                        <mns:actionCalls>
                            <mns:name>Retrieve_Fl */

        // this method plucks the flow metadata out from the QueryResult, and tweaks it so it looks like a normal Flow metadata file that you'd retrieve via the metadata api

        global static String ExtractFlowMetadata(String responseXML) {
            System.debug('beginning extraction on this responseXML: ' + responseXML);
            
            Dom.Document doc = new Dom.Document();
            //as can be seen in the example above, there are some namespaces in the version returned by the tooling api. They seem to cause problems so we remove them here
            responseXML = responseXML.replace('sf:','');
            responseXML = responseXML.replace('mns:','');

            doc.load(responseXML);
            Dom.XMLNode root = doc.getRootElement();

            //drill down throught the 'records' node and the 'Metadata' node to get to the actual good stuff
            List<Dom.XmlNode> recordsList= getChildrenByName(root, 'records');
            Dom.XmlNode metadataNode = recordsList[0];
            recordsList = getChildrenByName(metadataNode, 'Metadata')[0].getChildren();
            System.debug('recordsList is: ' + recordsList[0]);
 
            //to extract the good stuff as a string, it appears to be necessary to create a second XML document, and copy stuff over one at a time. Perhaps there's a better way....
            Dom.Document flowDocument = new Dom.Document();
            Dom.XmlNode rootNode = flowDocument.createRootElement( 'Flow', null, null);
            rootNode.setAttribute('xmlns','http://soap.sforce.com/2006/04/metadata');
            for(Dom.XmlNode curNode : recordsList) {
                rootNode.insertBefore(curNode, null);
            }

            return flowDocument.toXmlString() ;
        }

        public static List<Dom.XmlNode> getChildrenByName(Dom.XmlNode flowXml, String elementName) {
            System.debug ('getting children with the name: ' + elementName);
            List<Dom.XmlNode> allNodes = flowXml.getChildren();
            List<Dom.XMLNode> matchingNodes = new  List<Dom.XMLNode>();
    
            //look across all of the main Flow elements
            for (Dom.xmlNode curNode : allNodes) {
                if (curNode.getName() == elementName)
                       matchingNodes.add(curNode);
                
    
            }
            System.debug ('number of nodes matching target: ' + elementName + ' ' + matchingNodes.size());
            return matchingNodes;
        
    
        }

        public static String getTestString() {
            return '<?xml version="1.0" encoding="UTF-8"?> \n ' +
            '<QueryResult xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" \n ' +
                'xmlns:mns="urn:metadata.tooling.soap.sforce.com"> \n ' +
                '<done>true</done> \n ' +
                '<entityTypeName>Flow</entityTypeName> \n ' +
                '<queryLocator xsi:nil="true" /> \n ' +
                '<records type="Flow"> \n ' +
                    '<Id>3018B0000006gETQAY</Id> \n ' +
                   ' <sf:Metadata> \n ' +
                       ' <mns:actionCalls> \n ' +
                           ' <mns:name>Retrieve_Flow_Metadata</mns:name> \n ' +
                           ' <mns:label>Retrieve Flow Metadata</mns:label> \n ' +
                       ' </mns:actionCalls> \n ' +
                    '</sf:Metadata> \n ' +
                '</records> \n ' +
            '</QueryResult>';
        }
      
 
        global static HttpResponse  Send(String endpoint) {
        
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
            req.setHeader('Accept', 'application/xml');

            HttpResponse res;
            res = transmit(req);
            String body = res.getBody();
            System.debug('back from transmit. body is: ' + body);
            return res;
        }
    
        global static HttpResponse transmit(HttpRequest req) {
            Http http = new Http();
            System.debug('req is: ' + req);
            System.debug('body is: ' + req.getBody());
            if(!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                return res;
            } else {
                HttpResponse res = new HttpResponse();
                res.setStatusCode(200);
                res.setBody('{"ok":true}');
                return res;
            }
        }
    
    
    
        global class Request {
        
            @InvocableVariable(description='Flow Name' )
            global String flowName;

    
        }
        
        global class Result {

    
            @InvocableVariable
            global String errors;

            @InvocableVariable
            global String flowMetadata;
     
        }
        public class InvocableActionException extends Exception{}
    }