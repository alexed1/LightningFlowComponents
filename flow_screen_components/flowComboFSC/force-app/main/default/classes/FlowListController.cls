global with sharing class FlowListController { 
  
   @AuraEnabled
   public static String getFlowData(String orgURL, String endpoint )
       {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
           
            String sessionId = getSessionIdFromVFPage();
                       
            System.debug('url is: ' + orgURL + endpoint);
            request.setEndpoint(orgURL + endpoint );
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + sessionId);
           
            HttpResponse response = http.send(request);
            System.debug('#### Response Status '+response.getStatus());
            System.debug('#### Response Status Code '+response.getStatusCOde());
            
            String res = response.getBody();       
            System.debug('response is: ' + res);
            
            return res;
       }
    
   public static String getSessionIdFromVFPage() {
       if(Test.isRunningTest()) {
           return 'SESSION_ID';
       } else {
           String SESSION_ID_START = 'SESSION_ID_START';
           String SESSION_ID_END = 'SESSION_ID_END';
           String pageContent = Page.SessionId.getContent().toString();
           Integer startIndex = pageContent.indexOf(SESSION_ID_START) + SESSION_ID_START.length();
           Integer endIndex = pageContent.indexOf(SESSION_ID_END);
           return pageContent.substring(startIndex, endIndex);
       }
    }
    
    
}