public with sharing class FilterObjectRepresentation {
    @AuraEnabled
    public String type;
	@AuraEnabled
    public String fieldName;
	@AuraEnabled
    public String label;
    @AuraEnabled
    public String operator;
    @AuraEnabled
    public String value;


    public FilterObjectRepresentation() {

    }

    public FilterObjectRepresentation(String type, String fieldName, String label) {
        this.type = type;
        this.fieldName = fieldName;
        this.label = label;
    }
}