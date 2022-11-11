public with sharing class ElementStatusChange {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String label;
    @AuraEnabled
    public String changeType;
    @AuraEnabled
    public String elementType;
    @AuraEnabled
    public String description;
    @AuraEnabled
    public String notes;
    @AuraEnabled
    public String oldValue;
    @AuraEnabled
    public String newValue;
}
