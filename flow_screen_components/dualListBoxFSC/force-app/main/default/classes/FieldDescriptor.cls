public with sharing class FieldDescriptor {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String label;
    @AuraEnabled
    public String type;
    @AuraEnabled
    public Boolean required;

    public FieldDescriptor(String name, String label, String type, Boolean required) {
        this.name = name;
        this.label = label;
        this.type = type;
        this.required = required;

    }
}