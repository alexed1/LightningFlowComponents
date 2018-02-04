public with sharing class DependentPicklistController {
    public DependentPicklistController() {

    }

    //all credit to http://sfdcmonkey.com/2016/12/05/how-to-fetch-picklist-value-from-sobject-and-set-in-uiinputselect/
    @AuraEnabled
	public static List<String> getSelectOptions(string objectName, string fld) {
	  system.debug('object Name --->' + objectName);
	  system.debug('fld --->' + fld);

	  List <String> allOpts = new list <String>();
	  // Get the object type 
	  Schema.sObjectType objType = Schema.getGlobalDescribe().get(objectName);
	 
	  // Describe the SObject using its object type.
	  Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
	  system.debug('objDescribe --->' + objDescribe);
	  // Get a map of fields for the SObject
	  map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
	  system.debug('fldmap get fld --->' + fieldMap.get(fld));
	  system.debug('fldmap get fld getdescribe--->' + fieldMap.get(fld).getDescribe());
	  // Get the list of picklist values for this field.
	  list < Schema.PicklistEntry > values =
	   fieldMap.get(fld).getDescribe().getPickListValues();
	 
	  // Add these values to the selectoption list.
	  for (Schema.PicklistEntry a: values) {
	   allOpts.add(a.getValue());
	  }
	  system.debug('allOpts ---->' + allOpts);
	  //allOpts.sort();
	  return allOpts;
	 }
}
