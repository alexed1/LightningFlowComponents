public with sharing class GetGoogleSheetData {
    public GetGoogleSheetData() {

    }
    
    public string GetGoogleData() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:flow_action_components_gsheets/1A7Td7yl6wbxGhlsjouwO-N3sRyTDq-M5p579awuYTQo?includeGridData=true');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res.getBody();
    }
}
