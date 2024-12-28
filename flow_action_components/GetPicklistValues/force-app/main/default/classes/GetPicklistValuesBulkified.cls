//invocable action that, when provided with the name of an object and a picklist field, returns the vales of the picklist
//see https://unofficialsf.com/flow-action-get-picklist-values/

public with sharing class GetPicklistValuesBulkified {
	private static final String SOBJECTNOTFOUNDERROR = 'No SObject found with name "{0}". Did you mean "{1}"';
	private static final String FIELDNOTFOUNDERROR = 'No Field found with name "{0}" on SObject "{1}({2})". Did you mean "{3}"';

	@InvocableMethod(
		label='Get Picklist Values'
		description='Batchable version of GetPicklistValues'
		iconName='slds:standard:picklist_type'
	)
	public static List<Result> getPicklistValues(List<Request> reqs) {
		List<Result> response = new List<Result>();

		for (Request req : reqs) {
			response.add(getPicklistValues(req));
		}
		return response;
	}

	private static Result getPicklistValues(Request req) {
		System.debug('entering getPicklistVals');

		// this generates a special map that is case insensitive
		Map<String, Schema.SObjectType> globalDesc = Schema.getGlobalDescribe();

		Schema.SObjectType sObjType = globalDesc.get(req.objectName);
		if (sObjType == null) {
			throw new PicklistInvocableException(
				String.format(
					SOBJECTNOTFOUNDERROR,
					new List<String>{ req.objectName, getBestLevMatch(globalDesc.keySet(), req.objectName) }
				)
			);
		}

		// Describe the SObject using its object type.
		Schema.DescribeSObjectResult objDescribe = sObjType.getDescribe();
		// Get a map of fields for the SObject
		map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();

		Schema.SObjectField sObjField = fieldMap.get(req.fieldName);
		// check if Field exists on SObject, else provide usefull feedback
		if (sObjField == null) {
			throw new PicklistInvocableException(
				String.format(
					FIELDNOTFOUNDERROR,
					new List<String>{
						req.fieldName,
						objDescribe.getLabel(),
						objDescribe.getLocalName(),
						getBestLevMatch(fieldMap.keySet(), req.fieldName)
					}
				)
			);
		}

		return new Result(sObjField);
	}

	public class PicklistInvocableException extends Exception {
	}

	public class Request {
		@InvocableVariable(
			label='Object Name'
			description='The API name of the object to retrieve picklist values for'
			required=true
		)
		public String objectName;

		@InvocableVariable(
			label='Field Name'
			description='The API name of the field to retrieve picklist values for'
			required=true
		)
		public String fieldName;
	}

	public class Result {
		@InvocableVariable(label='Picklist Values' description='A list of API values for the picklist field')
		public List<String> picklistValues;

		@InvocableVariable(label='Picklist Labels' description='A list of labels corresponding to the picklist values')
		public List<String> picklistLabels;

		public Result(Schema.SObjectField sObjField) {
			List<Schema.PicklistEntry> values = sObjField.getDescribe().getPickListValues();

			this.picklistValues = new List<String>();
			this.picklistLabels = new List<String>();

			// Assemble the values into lists of strings
			for (Schema.PicklistEntry ple : values) {
				picklistValues.add(ple.getValue());
				picklistLabels.add(ple.getLabel());
			}
		}
	}

	// function to get the closest match based on Levenshtein Distance calculation
	public static string getBestLevMatch(set<string> possibilities, string value) {
		return getBestLevMatch(new List<string>(possibilities), value);
	}
	public static string getBestLevMatch(list<string> possibilities, string value) {
		if (possibilities.isempty()) {
			return null;
		}
		string closestMatch = null;
		Integer lowestLev = null;
		for (string pos : possibilities) {
			Integer levDistance = value.getLevenshteinDistance(pos);
			if (lowestLev == null || levDistance < lowestLev) {
				lowestLev = levDistance;
				closestMatch = pos;
				if (lowestLev == 0) {
					return closestMatch;
				}
			}
		}
		return closestMatch;
	}
}
