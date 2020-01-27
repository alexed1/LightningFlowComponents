global with sharing class MapCollection {
    @InvocableMethod
    global static List <Results> mapCollection(List<Requests> requestList) {
        Results response = new Results();
        List<SObject> inputCollection = requestList[0].inputCollection;
        List<SObject> outputCollection = new List<SObject>();
        String keyValuePairs = requestList[0].keyValuePairs;
        if (inputCollection != null && !inputCollection.isEmpty() && keyValuePairs != null) {
            for (SObject acc : inputCollection) {
                outputCollection.add(acc.clone(true));
            }

            Pattern mPattern = pattern.compile('([^,:"\\s*]+)');
            Matcher mMatcher = mPattern.matcher(keyValuePairs);
            Map<String, String> keyValue = new Map<String, String>();
            String key;
            while (mMatcher.find()) {
                if (key == null) {
                    key = mMatcher.group(0);
                } else {
                    keyValue.put(key, mMatcher.group(0));
                    key = null;
                }
            }

            for (String curKey : keyValue.keySet()) {
                for (SObject acc : outputCollection) {
                    try{
                        acc.put(curKey, keyValue.get(curKey));
                    }catch (Exception ex){
                        response.errors+=ex.getMessage();
                    }
                }
            }
        }

        response.outputCollection = outputCollection;
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;


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