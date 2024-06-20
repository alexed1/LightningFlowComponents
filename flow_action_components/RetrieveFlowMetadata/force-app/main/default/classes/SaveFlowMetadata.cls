public with sharing class SaveFlowMetadata {
 
  
    @InvocableMethod(label='Save Flow Metadata' description='Save Flow Metadata')
    public static List<Result> execute (List<Request> requestList) {
        
        System.debug('entering Save Flow Metadata');
        List<Result> results =  new List<Result>();
        
        for (Request curRequest: requestList) {
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            HttpResponse response = new HttpResponse();
            Result curResult = new Result();
            
            String flowName = curRequest.flowName;
            //String url = baseUrl +                                   '/services/data/v58.0/tooling/query?q=Select+Id,+LatestVersion.metadata,+LatestVersionId+FROM+FlowDefinition+WHERE+developerName=\'' + flowName + '\''; 
            String url = 'callout:' + curRequest.namedCredential + '/services/data/v58.0/tooling/sobjects/flow/'; 
            //String url = 'callout:' + curRequest.namedCredential + '/services/data/v58.0/tooling/query?q=Select+Id,+LatestVersion.metadata,+LatestVersionId+FROM+FlowDefinition+WHERE+developerName=\'' + flowName + '\''; 
        

            if(!Test.isRunningTest()) {
                response = Send(url );  
                String responseBody = response.getBody();
                System.debug('response is: ' + response); 
                System.debug('location header is: ' + response.getHeader('Location')); 
                System.debug('response body string is: ' + responseBody);            
                if(response.getStatusCode() != 200) {
                    throw new InvocableActionException(responseBody);
                }
               // Dom.XmlNode recordsNode = PerformInitialParsingOnQueryResult(responseBody);


            } else {               
                String testResponse = getTestString();
                response.setBody(testResponse);

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

    public static string getFlowString() {
        String flowXML = '<?xml version="1.0" encoding="UTF-8"?><Flow xmlns="http://soap.sforce.com/2006/04/metadata"><apiVersion>58.0</apiVersion><description>Create a draft contract for any opportunity that is Closed-Won and has a dollar amount greater than $50,000</description><environments>Default</environments><interviewLabel>create contract from closed won opportunity {!$Flow.CurrentDateTime}</interviewLabel><label>create contract from closed won opportunity</label><processMetadataValues><name>BuilderType</name><value><stringValue>LightningFlowBuilder</stringValue></value></processMetadataValues><processMetadataValues><name>CanvasMode</name><value><stringValue>AUTO_LAYOUT_CANVAS</stringValue></value></processMetadataValues><processMetadataValues><name>OriginBuilderType</name><value><stringValue>LightningFlowBuilder</stringValue></value></processMetadataValues><processType>AutoLaunchedFlow</processType><recordCreates><description>create a draft contract for opportunities greater than 50000</description><name>create_draft_contract</name><label>create draft contract</label><locationX>176</locationX><locationY>323</locationY><inputAssignments><field>AccountId</field><value><elementReference>$Record.Account.Id</elementReference></value></inputAssignments><inputAssignments><field>Status</field><value><stringValue>Draft</stringValue></value></inputAssignments><object>Contract</object><storeOutputAutomatically>true</storeOutputAutomatically></recordCreates><start><locationX>50</locationX><locationY>0</locationY><connector><targetReference>create_draft_contract</targetReference></connector><doesRequireRecordChangedToMeetCriteria>true</doesRequireRecordChangedToMeetCriteria><filterLogic>and</filterLogic><filters><field>StageName</field><operator>EqualTo</operator><value><stringValue>Closed Won</stringValue></value></filters><filters><field>Amount</field><operator>GreaterThanOrEqualTo</operator><value><numberValue>50000.0</numberValue></value></filters><object>Opportunity</object><recordTriggerType>CreateAndUpdate</recordTriggerType><triggerType>RecordAfterSave</triggerType></start><status>Draft</status></Flow>';
        return flowXML;
    }
  

    public static HttpResponse  Send(String endpoint) {
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        //req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/xml');
        req.setBody(getFlowString());

        HttpResponse res;
        res = transmit(req);
        String body = res.getBody();
        System.debug('back from transmit. body is: ' + body);
        return res;
    }

    public static HttpResponse transmit(HttpRequest req) {
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



    public class Request {
    
        @InvocableVariable(required=true description='Flow Name' )
        public String flowName;

        @InvocableVariable(required=true description='Flow XML' )
        public String flowXML;

        @InvocableVariable(required=true description='Named Credential' )
        public String namedCredential;
    }
    
    public class Result {


        @InvocableVariable
        public String errors;

        @InvocableVariable
        public String flowDefinitionId; //the id of the Flow Definition

        @InvocableVariable
        public String flowLatestVersionid;  
    }
    public class InvocableActionException extends Exception{}
}