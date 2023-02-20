public with sharing class mc_ValidateAddress_StandardizedAddress {
    @AuraEnabled
    public String state{get;set;}
    @AuraEnabled
    public String city{get;set;}
    @AuraEnabled
    public String cityStateZipAddressLine{get;set;}
    @AuraEnabled
    public String zipCode{get;set;}
    @AuraEnabled
    public String firstAddressLine{get;set;}
}