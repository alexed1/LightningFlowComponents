public with sharing class ExtractJSONValues {
    @InvocableMethod(label='Extract JSON Values' description='Extract JSON Values' configurationEditor='c:extractJSONValuesCPE')
    public static List<Response> Invoke (List<Request> requests) {
        List<response> responseList = new List<Response>();
        for(Request req : requests) {
            Map<String, Object> inputJSONMap = (Map<String, Object>)JSON.deserializeUntyped(req.inputJSONString);
            Map<String, String> responseMap = new Map<String,String>();
            
            List<HeaderKeyValue> keysToExtractList = (List<HeaderKeyValue>)JSON.deserialize(req.keysToExtract, List<HeaderKeyValue>.class);
            for(HeaderKeyValue item : keysToExtractList) {
                if(item.value.contains('.')) {
                    List<String> keyList = item.value.split('\\.');
                    
                    Object result = inputJSONMap.get(keyList[0]);

                    for(Integer i = 1; i < keyList.size(); i++) {
                        if(result != null && result instanceof Map<string, Object>) {
                            Map<string, Object> temp = (Map<string, Object>) result;
                            result = temp.get(keyList[i]);

                        }
                    }

                    responseMap.put(item.key,((result instanceof Map<String, Object>) || (result instanceof List<Object>)) ? JSON.serialize(result) : String.valueOf(result));

                } else {
                    Object result = inputJSONMap.get(item.value);
                    responseMap.put(item.key, ((result instanceof Map<String, Object>) || (result instanceof List<Object>)) ? JSON.serialize(result) : String.valueOf(result));
                }
            }

            Response res = (Response)JSON.deserialize(JSON.serialize(responseMap), Response.class);
            responseList.add(res);
        }

        return responseList;
    }

    public class Request {
        @InvocableVariable
        public String inputJSONString;
        @InvocableVariable
        public String keysToExtract;
    }

    private class HeaderKeyValue{
        private String key;
        private String value;
    }
    
    public class Response {
        @InvocableVariable
        public String value1;
        @InvocableVariable
        public String value2;
        @InvocableVariable
        public String value3;
        @InvocableVariable
        public String value4;
        @InvocableVariable
        public String value5;
        @InvocableVariable
        public String value6;
        @InvocableVariable
        public String value7;
        @InvocableVariable
        public String value8;
        @InvocableVariable
        public String value9;
        @InvocableVariable
        public String value10;
        @InvocableVariable
        public String value11;
        @InvocableVariable
        public String value12;
        @InvocableVariable
        public String value13;
        @InvocableVariable
        public String value14;
        @InvocableVariable
        public String value15;
        @InvocableVariable
        public String value16;
        @InvocableVariable
        public String value17;
        @InvocableVariable
        public String value18;
        @InvocableVariable
        public String value19;
        @InvocableVariable
        public String value20;
    }
}
