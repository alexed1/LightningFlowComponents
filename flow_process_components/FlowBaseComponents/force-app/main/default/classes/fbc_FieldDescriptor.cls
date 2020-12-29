public with sharing class fbc_FieldDescriptor {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String label;
    @AuraEnabled
    public String type;
    @AuraEnabled
    public Boolean required;
    @AuraEnabled
    public List<String> referenceTo;
    
    public fbc_FieldDescriptor(Schema.DescribeFieldResult field) {
        this.name = field.getName();
        this.label = field.getLabel();
        this.type = field.getType().name();
        this.required = !field.isNillable();
        
        if(!field.getReferenceTo().isEmpty()){
            this.referenceTo = new List<String>();
            for(Schema.SObjectType ref : field.getReferenceTo()){
                this.referenceTo.add(ref.getDescribe().getName());
            }
        }
    }
}