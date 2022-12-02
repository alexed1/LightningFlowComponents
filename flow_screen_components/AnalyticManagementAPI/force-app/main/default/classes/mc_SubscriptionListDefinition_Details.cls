public with sharing class mc_SubscriptionListDefinition_Details {
    @AuraEnabled
    public string[] daysOfWeek;
    @AuraEnabled
    public Integer timeOfDay;	//20
    @AuraEnabled
    public String weekInMonth;	//first
    @AuraEnabled
    public Integer[] daysOfMonth;
}