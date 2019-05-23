global with sharing class FlowListController { 
    
    @AuraEnabled
    public static List<FlowDefinitionView> getFlowNamesApex(Boolean showActivesOnly ) {
        System.debug('entering getFlowNamesApex');
        List<FlowDefinitionView> curFlows;
        
        if (showActivesOnly){
            curFlows = [SELECT Id,ApiName,Label FROM FlowDefinitionView WHERE ActiveVersionId!=NULL];
        } else {
            curFlows = [SELECT Id,ApiName,Label FROM FlowDefinitionView];
        }
        
        System.debug('curFlows is: ' + curFlows);
        return curFlows;
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