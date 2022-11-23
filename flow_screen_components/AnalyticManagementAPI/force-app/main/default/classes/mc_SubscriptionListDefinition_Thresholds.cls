public with sharing class mc_SubscriptionListDefinition_Thresholds {
    @AuraEnabled
    public List<mc_SubscriptionListDefinition_Actions> actions;
    @AuraEnabled
    public List<mc_SubscriptionListDefinition_Conditions> conditions;
    @AuraEnabled
    public String type;	//always
}