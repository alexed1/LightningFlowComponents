global with sharing class PopulatePicklist {
@AuraEnabled
global static list<Map<string, string> > getPicklistValues(string obj, String fld){
  checkAccess(obj, new string[]{fld}, 'read');
  
	list<Map<string, string> > options = new list<Map<string, string> >();
	Schema.SObjectType objType = Schema.getGlobalDescribe().get(obj);
	Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
	map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
	list<Schema.PicklistEntry> values =
		fieldMap.get(fld).getDescribe().getPickListValues();
	for (Schema.PicklistEntry a : values)
	{
		Map<string, string> newOptions = new Map<string, string>{};
		newOptions.put('value', a.getValue());
		newOptions.put('label', a.getLabel());
		options.add(newOptions);
	}

	return options;
}

private static void checkAccess(string sobjectName, String[] fields, string accessType){

	SObjectType sobj = Schema.getGlobalDescribe().get(sobjectName);
	Map<String,Schema.SObjectField> sobjectfields = sobj.getDescribe().fields.getMap();
	String[] systemFields = new String[] {
		'Id',
		'IsDeleted',
		'CreatedBy',
		'CreatedById',
		'CreatedDate',
		'LastModifiedBy',
		'LastModifiedById',
		'LastModifiedDate',
		'SystemModstamp'
	};
	if(accessType == 'create') {
		for (String field : fields) {
			// Check if the user has access to field
			if(systemFields.indexOf(field) > -1 || sobjectfields.get(field).getDescribe().isCalculated() || sobjectfields.get(field).getDescribe().isAutoNumber()) continue;
			if (!sobjectfields.get(field).getDescribe().isCreateable()) {
				// Pass error to client
				// Due to a quirk with AuraHandledException, the message is only passed to the client when the message is set in both ways
				// as it is below.
				AuraHandledException e = new AuraHandledException('Access to one or more necessary fields is restricted for the current user. ' + field);
				e.setMessage('Access to one or more necessary fields is restricted for the current user. ' + field);
				throw e;
			}
		}
	} else if(accessType == 'read') {
		for (String field : fields) {
			if (!sobjectfields.get(field).getDescribe().isAccessible()) {
				AuraHandledException e = new AuraHandledException('Access to one or more necessary fields is restricted for the current user.');
				e.setMessage('Access to one or more necessary fields is restricted for the current user.');
				throw e;

			}
		}
	} else if(accessType == 'update') {
		for (String field : fields) {
			if(systemFields.indexOf(field) > -1 || sobjectfields.get(field).getDescribe().isCalculated() || sobjectfields.get(field).getDescribe().isAutoNumber()) continue;
			if (!sobjectfields.get(field).getDescribe().isUpdateable()) {
				AuraHandledException e = new AuraHandledException('Access to one or more necessary fields is restricted for the current user.');
				e.setMessage('Access to one or more necessary fields is restricted for the current user.');
				throw e;
			}
		}
	} else if(accessType == 'delete') {
		if (!sobj.getDescribe().isDeletable()) {
			AuraHandledException e = new AuraHandledException('Access to one or more necessary objects is restricted for the current user.');
			e.setMessage('Access to one or more necessary objects is restricted for the current user.');
			throw e;
		}
	}
}
}
