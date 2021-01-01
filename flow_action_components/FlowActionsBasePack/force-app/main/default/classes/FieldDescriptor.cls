global with sharing class FieldDescriptor {
    @AuraEnabled
    global String name;
    @AuraEnabled
    global String label;
    @AuraEnabled
    global String type;
    @AuraEnabled
    global Boolean required;
    @AuraEnabled
    global List<String> referenceTo;

    global FieldDescriptor(String name, String label, String type, Boolean required) {
        this.name = name;
        this.label = label;
        this.type = type;
        this.required = required;

    }
    global FieldDescriptor(Schema.DescribeFieldResult field) {
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
    
    global FieldDescriptor() {
   

    }
}