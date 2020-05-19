global with sharing class MapCollection {
    @InvocableMethod
    global static List <Results> mapCollection(List<Requests> requestList) {
        List<Results> responseWrapper = new List<Results>();

        for (Requests curRequest : requestList) {
            Results response = new Results();
            List<SObject> inputCollection = curRequest.inputCollection;
            String keyValuePairs = curRequest.keyValuePairs;


            List<SObject> outputCollection = new List<SObject>();

            if (inputCollection != null && !inputCollection.isEmpty() && keyValuePairs != null) {
                for (SObject acc : inputCollection) {
                    outputCollection.add(acc.clone(true));
                }

                Pattern mPattern = pattern.compile('"(?:[^"\\\\]|\\\\.)*"');
                Matcher mMatcher = mPattern.matcher(CollectionProcessorsUtils.replaceConstants(keyValuePairs));

                Map<String, String> fieldNameToValueMap = new Map<String, String>();
                String key;
                while (mMatcher.find()) {

                    if (key == null) {
                        key = mMatcher.group(0);
                    } else {
                        fieldNameToValueMap.put(stripQuotes(key), stripQuotes(mMatcher.group(0)));
                        key = null;
                    }
                }

                Map<String, String> fieldTypesMap = CollectionProcessorsUtils.getFieldTypes(outputCollection[0], new List<String>(fieldNameToValueMap.keySet()));
                for (String curFieldName : fieldNameToValueMap.keySet()) {
                    for (SObject acc : outputCollection) {
                        try {
                            putType(acc, curFieldName, fieldTypesMap.get(curFieldName), fieldNameToValueMap.get(curFieldName));
                        } catch (Exception ex) {
                            response.errors += ex.getMessage();
                        }
                    }
                }
            }

            response.outputCollection = outputCollection;
            responseWrapper.add(response);
        }

        return responseWrapper;
    }


    private static String stripQuotes(String str) {
        if (str != null) {
            return str.removeEnd('"').removeStart('"');
        } else {
            return null;
        }
    }

    private static void putType(SObject obj, String fieldName, String fieldType, String fieldValue) {

        if (fieldType != 'Boolean' && (fieldValue == null || fieldValue == '')) {
            obj.put(fieldName, null);
        } else if (fieldType == 'Date') {
            obj.put(fieldName, Date.valueOf(CollectionProcessorsUtils.getFormattedValue(fieldValue.toLowerCase(), fieldType.toLowerCase())));
        } else if (fieldType == 'Datetime') {
            obj.put(fieldName, Datetime.valueOf(CollectionProcessorsUtils.getFormattedValue(fieldValue.toLowerCase(), fieldType.toLowerCase())));
        } else if (fieldType == 'Boolean') {
            obj.put(fieldName, fieldValue == null ? false : Boolean.valueOf(fieldValue));
        } else if (fieldType == 'Currency') {
            if (fieldValue != null && fieldValue != '') {
                obj.put(fieldName, Decimal.valueOf(fieldValue));
            }
        } else if (fieldType == 'JSON') {
            obj.put(fieldName, JSON.serialize(fieldValue));
        } else {
            obj.put(fieldName, fieldValue);
        }
    }

    global class Requests {
        @InvocableVariable(required=true)
        global List<SObject> inputCollection;

        @InvocableVariable(required=true)
        global String keyValuePairs;

    }

    global class Results {

        public Results() {
            outputCollection = new List<SObject>();
        }
        @InvocableVariable
        global String errors;

        @InvocableVariable
        global List<SObject> outputCollection;
    }
}