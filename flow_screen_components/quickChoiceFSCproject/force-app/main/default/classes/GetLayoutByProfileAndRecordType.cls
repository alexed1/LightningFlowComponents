global with sharing class GetLayoutByProfileAndRecordType {


    @InvocableMethod
    global static List <Results> get(List<Requests> requestList) {
        Results response = new Results();
        String profileId = requestList[0].profileId;
        String recordTypeId = requestList[0].recordTypeId;
        String layoutId;
        String baseURL = Url.getOrgDomainUrl().toExternalForm();

        HttpRequest req = new HttpRequest();
        String sessionId;
        //Get content is not supported in test classes, thus setting random text as a session Id
        if(Test.isRunningTest()){
            sessionId = 'sessionId';
        }else{
            sessionId = Page.sessionId.getContent().toString();
        }

        req.setHeader('Authorization', 'Bearer ' + sessionId); //UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        System.debug('UserInfo.getSession is: ' + sessionId); //UserInfo.getSessionID());

        String endpoint = baseUrl + '/services/data/v47.0/tooling/query/?q=SELECT+Layout.Name,Layout.TableEnumOrId,ProfileId,Profile.Name,RecordTypeId+FROM+ProfileLayout+WHERE+profileId=\'' + profileId + '\'' ;
        System.debug('endpoint starts as: ' + endpoint);
        System.debug('recordTypeId is: ' + recordTypeId);
        //When there's no record type, the Master recordTypeId of 012000000000000AAA is used. However, it is not used with ProfileLayout, and so we have to avoid passing it in as a recordTypeId
        if (recordTypeId != '012000000000000AAA') {
            endpoint = endpoint +  '+AND+recordTypeId=\'' + recordTypeId + '\'';
            System.debug('after adding recordTypeId, endpoint is ' + endpoint);
        }


        //req.setEndpoint(baseUrl + '/services/data/v47.0/tooling/query/?q=SELECT+Layout.Name,Layout.TableEnumOrId,ProfileId,Profile.Name,RecordTypeId+FROM+ProfileLayout+WHERE+profileId=\'' + profileId + '\'AND+recordTypeId=\'' + recordTypeId + '\'');
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        system.debug('response body from tooling call to ProfileLayout: ' + res.getBody());

        //the data structure returned in the body of this Tooling API call includes the Layout Id we're looking for
        //but we have to drill down to get it:

            /*    {
        "entityTypeName": "ProfileLayout",
        "records": [
            {
            "attributes": {
                "type": "ProfileLayout",
                "url": "/services/data/v47.0/tooling/sobjects/ProfileLayout/01G1F00000pf0cZUAQ"
            },
            "Layout": {
                "attributes": {
                "type": "Layout",
                "url": "/services/data/v47.0/tooling/sobjects/Layout/00h1F000001mbtuQAA"
                },
                "Name": "Account Layout",
                "TableEnumOrId": "Account"
            }, */



        Map<String,Object> responseProfileLayout = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
        List<Object> objList = (List<Object>)responseProfileLayout.get('records');

        Map<String,Object> objMap = (Map<String,Object>)objList[0];
        Map<String,Object> layout = (Map<String,Object>)objMap.get('Layout');
        Map<String,Object> responseAttributes = (Map<String, Object>)layout.get('attributes');
        String layoutURL = (String)responseAttributes.get('url');
        String layoutName = (String)layout.get('Name');
        String objectName = (String)layout.get('TableEnumOrId');
        System.debug ('responseAttributes ' + responseAttributes);
        System.debug ('layoutName ' + layoutName);



        response.layoutId = layoutURL.substringAfterLast('/');
        response.layoutName = layoutName;
        response.objectName = objectName;
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;


    }
    global class Requests {

        @InvocableVariable(required=true)
        global String profileId;

        @InvocableVariable(required=true)
        global String recordTypeId;

    }

    global class Results {


        @InvocableVariable
        global String layoutId;

        @InvocableVariable
        global String layoutName;

        @InvocableVariable
        global String objectName;
    }
}