public with sharing class flowDMC_ProfileCategoryGroupVisibility {
    @AuraEnabled
    public String application ;
    @AuraEnabled
    public Boolean Xdefault; //default is not allowed in Apex so will need to transform
    @AuraEnabled
    public Boolean visible;
}
