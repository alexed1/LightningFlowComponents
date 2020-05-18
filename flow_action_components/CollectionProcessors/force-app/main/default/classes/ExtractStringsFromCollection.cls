global with sharing class ExtractStringsFromCollection {
    global class DedupeFieldsException extends Exception {}
  
    @InvocableMethod(label='Extract Strings From Collection' description='Extract and return field values from a list of records using a provided field API name as the unique value' category='Util')
    global static List <Results> extract(List<Requests> requestList) {
        List<String> outputStrings =  new List<String>();
        
        for (FlowRequest request: requestList) {
            if (request.inputRecordCollection == null || request.inputRecordCollection.size() == 0) {
                throw new DedupeFieldsException('Input record list is required, but empty');
            }
            if (request.fieldAPIName == null || request.fieldAPIName.length() == 0) {
                throw new DedupeFieldsException('Field to dedupe on is required, but empty');
            }
            if (request.dedupeValues == null) {
                request.dedupeValues = true;
            }
            Results result = new Results();
            result.fieldValueCollection = getUniqueTextCollection(request);
            result.fieldValueString = String.join(flowResponse.fieldValueCollection, ',');
            result.add(flowResponse);
        }
        return outputStrings;
    }

    private static List<String> getUniqueTextCollection(FlowRequest request) {
        Set<String> stringsSet = new Set<String>();
        List<String> stringsList = new List<String>{};
        for (SObject record : request.inputRecordCollection) {
            String fieldValue = String.valueOf(record.get(request.fieldAPIName));
            if (fieldValue != null) {
                if (request.dedupeValues) {
                    stringsSet.add(fieldValue);
                } else {
                    stringsList.add(fieldValue);
                }
            }
        }
        return request.dedupeValues ? new List<String>(stringsSet): stringsList;
    }

    global class Requests {
        @InvocableVariable(description='List of records to extract field values from' required=true)
        global List<SObject> inputRecordCollection;
        
        @InvocableVariable(description='API name of the field' required=true)
        global String fieldAPIName;

        @InvocableVariable(description='If true only unique values will be returned. The default value is true')
        global Boolean dedupeValues;
    }
    
    global class Results {
        @InvocableVariable(description='List of unique field values for API name provided')
        global List<String> fieldValueCollection;

        @InvocableVariable(description='Comma separated string of unique field values for API name provided')
        global String fieldValueString;
    }

}