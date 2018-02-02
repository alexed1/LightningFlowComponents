public with sharing class DependentPicklistController {
    public DependentPicklistController() {

    }

    //from http://sfdcmonkey.com/2016/12/05/how-to-fetch-picklist-value-from-sobject-and-set-in-uiinputselect/
    @AuraEnabled
	public static List<String> getSelectOptions(sObject objObject, string fld) {
	  system.debug('objObject --->' + objObject);
	  system.debug('fld --->' + fld);

	  List <String> allOpts = new list <String>();
	  // Get the object type of the SObject.
	  Schema.sObjectType objType = objObject.getSObjectType();
	 
	  // Describe the SObject using its object type.
	  Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
	 
	  // Get a map of fields for the SObject
	  map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
	 
	  // Get the list of picklist values for this field.
	  list < Schema.PicklistEntry > values =
	   fieldMap.get(fld).getDescribe().getPickListValues();
	 
	  // Add these values to the selectoption list.
	  for (Schema.PicklistEntry a: values) {
	   allOpts.add(a.getValue());
	  }
	  system.debug('allOpts ---->' + allOpts);
	  allOpts.sort();
	  return allOpts;
	 }
}
