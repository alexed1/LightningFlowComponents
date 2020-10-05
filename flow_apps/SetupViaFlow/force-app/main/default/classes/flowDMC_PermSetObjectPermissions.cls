public with sharing class flowDMC_PermSetObjectPermissions {
    @AuraEnabled
    public Boolean allowCreate;
    @AuraEnabled
    public Boolean allowDelete;
    @AuraEnabled
    public Boolean allowEdit;
    @AuraEnabled
    public Boolean allowRead;
    @AuraEnabled
    public Boolean modifyAllRecords;
    @AuraEnabled
    public String object_x;
    @AuraEnabled
    public Boolean viewAllRecords;
}
