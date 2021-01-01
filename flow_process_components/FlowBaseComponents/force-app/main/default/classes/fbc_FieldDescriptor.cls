public with sharing class fbc_FieldDescriptor {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String label;
    @AuraEnabled
    public String type;
    @AuraEnabled
    public Boolean required;

    public fbc_FieldDescriptor(String name, String label, String type, Boolean required) {
        this.name = name;
        this.label = label;
        this.type = type;
        this.required = required;

    }
}