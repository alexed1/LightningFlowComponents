public with sharing class mc_SubscriptionListDef_Config {
    @AuraEnabled
    public boolean excludeSnapshot;
    @AuraEnabled
    public List<mc_SubscriptionListDefinition_Recipients> recipients;
}