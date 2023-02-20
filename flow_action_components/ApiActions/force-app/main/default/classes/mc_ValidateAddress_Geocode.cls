public with sharing class mc_ValidateAddress_Geocode {
    @AuraEnabled
    public mc_ValidateAddress_PlusCode plusCode{get;set;}
    @AuraEnabled
    public mc_ValidateAddress_Bounds bounds{get;set;}
    @AuraEnabled
    public Decimal featureSizeMeters{get;set;}
    @AuraEnabled
    public mc_ValidateAddress_Location location{get;set;}
    @AuraEnabled
    public String placeId{get;set;}
    @AuraEnabled
    public list<String> placeTypes{get;set;}
}