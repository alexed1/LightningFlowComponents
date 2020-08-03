public with sharing class ListViewDescriptor {
    @AuraEnabled
    public String developerName;
    @AuraEnabled
    public String label;
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String filterScope;
    @AuraEnabled
    public String filterLogic;
    @AuraEnabled
    public String language;
    @AuraEnabled
    public String queue;
    @AuraEnabled
    public String division;
   // @AuraEnabled
   // public List<ListViewFilter> filters;
    @AuraEnabled
    public List<String> column;

    
}