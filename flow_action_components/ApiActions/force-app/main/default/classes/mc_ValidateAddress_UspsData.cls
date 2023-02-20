public with sharing class mc_ValidateAddress_UspsData {
    @AuraEnabled
    public mc_ValidateAddress_StandardizedAddress standardizedAddress{get;set;}
    @AuraEnabled
    public String postOfficeCity{get;set;}
    @AuraEnabled
    public String postOfficeState{get;set;}
    @AuraEnabled
    public String carrierRoute{get;set;}
    @AuraEnabled
    public Boolean cassProcessed{get;set;}
    @AuraEnabled
    public String dpvFootnote{get;set;}
}