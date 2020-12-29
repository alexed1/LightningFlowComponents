public with sharing class fbc_FieldDescriptor {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String label;
    @AuraEnabled
    public String type;
    @AuraEnabled
    public Boolean required;
    
    public fbc_FieldDescriptor(Schema.DescribeFieldResult field) {
        this.name = field.getName();
        this.label = field.getLabel();
        this.type = field.getType().name();
        this.required = !field.isNillable();
    }
}