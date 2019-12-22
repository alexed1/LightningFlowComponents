public with sharing class GetLayoutByProfileAndRecordType {
 

    @InvocableMethod
    public static List <Results> get(List<Requests> requestList) {
        Results response = new Results();
        String profileId = requestList[0].profileId;
        String recordTypeId = requestList[0].recordTypeId;
        String layoutId;
        String baseURL = Url.getOrgDomainUrl().toExternalForm();

        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(baseUrl + '/services/data/v47.0/tooling/query/?q=SELECT+Layout.Name,Layout.TableEnumOrId,ProfileId,Profile.Name,RecordTypeId+FROM+ProfileLayout+WHERE+recordTypeId=\'' + recordTypeId + '\'AND+profileId=\'' + profileId + '\'');
        req.setMethod('GET'); 
        Http h = new Http();
        HttpResponse res = h.send(req);
        system.debug(res.getBody()); 

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
        System.debug ('responseAttributes ' + responseAttributes);
        System.debug ('layoutName ' + layoutName);

        
        
        response.layoutId = layoutURL.substringAfterLast('/'); 
        response.layoutName = layoutName;
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;


    }
    public class Requests {
       
        @InvocableVariable 
        public String profileId;

        @InvocableVariable 
        public String recordTypeId;

    }

    public class Results {

       
        @InvocableVariable
        public String layoutId;

        @InvocableVariable
        public String layoutName;
    }
}