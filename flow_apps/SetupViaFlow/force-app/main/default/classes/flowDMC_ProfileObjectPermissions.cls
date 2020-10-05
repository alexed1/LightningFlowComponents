public with sharing class flowDMC_ProfileObjectPermissions {
    @AuraEnabled
    public Boolean allowCreate ;
    @AuraEnabled
    public Boolean allowDelete;
    @AuraEnabled
    public Boolean allowEdit;
    @AuraEnabled
    public Boolean allowRead;
    @AuraEnabled
    public Boolean modifyAllRecords;
    @AuraEnabled
    public String xobject; //the metadata uses 'object' but that's not allowed in apex. will need a workaround
    @AuraEnabled
    public Boolean viewAllRecords;
 
}
