
public with sharing class AssembleInputParams {
    private static final Integer NUMBER_OF_PARAMS = 4;

    @InvocableMethod
    public static List <Results> execute(List<Requests> requestList) {
        System.debug('entering AssembleInputParams');
        Map<String, String> requestListMap = (Map<String, String>) JSON.deserialize(JSON.serialize(requestList[0]), Map<String, String>.class);

        //Create a Results object to hold the return values
        Results response = new Results();
        List<ContextWrapper> params = new List<ContextWrapper>();
        for (Integer i = 1; i <= NUMBER_OF_PARAMS; i++) {
            String paramKey = (String) requestListMap.get('param' + i + 'Key');
            String paramValue = (String) requestListMap.get('param' + i + 'Value');
            if ((paramKey != null && paramValue == null) || (paramKey == null && paramValue != null))
                throw new InvocableActionException('You need to provide both a param1Key and a param1Value. Currently you are only providing 1 of those');
            if (paramKey != null && paramValue != null) {
                params.add(new ContextWrapper(paramKey, paramValue));
            }
        }

        response.jsonParams = JSON.serialize(params);

        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);
        System.debug('response is: ' + response);
        System.debug('responseWrapper is: ' + responseWrapper);

        return responseWrapper;

    }

    public class InvocableActionException extends Exception {
    }


    public class Requests {

        @InvocableVariable
        public String param1Key;

        @InvocableVariable
        public String param1Value;

        @InvocableVariable
        public String param2Key;

        @InvocableVariable
        public String param2Value;

        @InvocableVariable
        public String param3Key;

        @InvocableVariable
        public String param3Value;

        @InvocableVariable
        public String param4Key;

        @InvocableVariable
        public String param4Value;

    }

    public class Results {

        @InvocableVariable
        public String jsonParams;

    }

    public class ContextWrapper {
        public String name;
        public String value;

        public ContextWrapper(String name, String value) {
            this.name = name;
            this.value = value;
        }
    }
}
