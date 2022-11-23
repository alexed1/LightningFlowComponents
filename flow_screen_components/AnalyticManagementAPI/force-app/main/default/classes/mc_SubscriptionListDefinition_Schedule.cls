public with sharing class mc_SubscriptionListDefinition_Schedule {
    @AuraEnabled
    public mc_SubscriptionListdefinition_Details details;
    @AuraEnabled
    public String frequency;	//weekly
    @AuraEnabled
    public String frequencyType;
}