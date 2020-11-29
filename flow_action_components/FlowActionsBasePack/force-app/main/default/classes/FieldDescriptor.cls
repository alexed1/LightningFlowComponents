global with sharing class FieldDescriptor {
    @AuraEnabled
    global String name;
    @AuraEnabled
    global String label;
    @AuraEnabled
    global String type;
    @AuraEnabled
    global Boolean required;

    global FieldDescriptor(String name, String label, String type, Boolean required) {
        this.name = name;
        this.label = label;
        this.type = type;
        this.required = required;

    }

<<<<<<< HEAD
    global FieldDescriptor() {}
=======
    global FieldDescriptor() {
   

    }
>>>>>>> datatableCPE
}