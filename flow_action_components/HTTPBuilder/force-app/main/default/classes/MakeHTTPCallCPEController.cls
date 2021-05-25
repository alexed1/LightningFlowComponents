public with sharing class MakeHTTPCallCPEController {
    @AuraEnabled
    public static String makeTestHTTPCallout(String requestJSON){
        try {
            MakeHTTPCall.Request request = (MakeHTTPCall.Request)JSON.deserialize(requestJSON, MakeHTTPCall.Request.class);
            List<MakeHTTPCall.Response> responseList = MakeHTTPCall.Invoke(new List<MakeHTTPCall.Request>{request});
            return JSON.serialize(responseList[0]);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
