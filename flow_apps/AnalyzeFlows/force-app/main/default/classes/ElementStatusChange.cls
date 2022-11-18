global with sharing class ElementStatusChange {
    @AuraEnabled
    global String name;
    @AuraEnabled
    global String label;
    @AuraEnabled
    global String changeType;
    @AuraEnabled
    global String elementType;
    @AuraEnabled
    global String description;
    @AuraEnabled
    global String notes;
    @AuraEnabled
    global String oldValue;
    @AuraEnabled
    global String newValue;


    global  ElementStatusChange() {

    }

    global  ElementStatusChange(String name, String label, String changeType, String elementType, String description, String notes, String oldValue, String newValue) {
        this.name = name;
        this.label = label;
        this.changeType = changeType;
        this.elementType = elementType;
        this.description = description;
        this.notes = notes;
        this.oldValue = oldValue;
        this.newValue = newValue;
    }

}
