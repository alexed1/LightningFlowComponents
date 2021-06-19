public with sharing class MapJSONArray {
    @InvocableMethod(label='Map JSON Array' description='Map JSON Array' configurationEditor='c:mapJSONArrayCPE')
    public static List<Response> Invoke (List<Request> requests) {
        List<response> responseList = new List<Response>();
        for(Request req : requests) {
            try{
                List<SObject> sobjectList = new List<SObject>();
                List<Object> entityList = (List<Object>)JSON.deserializeUntyped(req.inputJSONString);
                List<ObjectKeyValue> keysToExtractList = (List<ObjectKeyValue>)JSON.deserialize(req.keysToExtract, List<ObjectKeyValue>.class);
                for(Object item : entityList) {
                    SObject sobj = Schema.getGlobalDescribe().get(req.sobjectType).newSObject();
                    Map<String,Object> entityMap = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(item));
                    for(ObjectKeyValue objectKey : keysToExtractList) {
                        Schema.DisplayType FldType = getFieldType(req.sobjectType, objectKey.key);
                        if(FldType == Schema.DisplayType.DATETIME) {
                            sobj.put(objectKey.key, Datetime.parse(String.valueOf(entityMap.get(objectKey.value))));
                        } else if(FldType == Schema.DisplayType.DATE) {
                            sobj.put(objectKey.key, Date.parse(String.valueOf(entityMap.get(objectKey.value))));
                        } else {
                            sobj.put(objectKey.key, entityMap.get(objectKey.value));
                        }
                        
                    }

                    sobjectList.add(sobj);
                }

                Response resp = new Response();
                resp.sobjectList = sobjectList;
                responseList.add(resp);
            } catch(Exception e) {
                //throw new InvocableActionException(e.getMessage());
                Response resp = new Response();
                resp.errors = e.getMessage(); //Label.JSON_ARRAY_EXCEPTION;
                responseList.add(resp);
            } 
        }

        return responseList;
    }

    public class InvocableActionException extends Exception {}

    private static Schema.DisplayType getFieldType(String objectName, String fieldName) {
        Map<String, Schema.SObjectField> M = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        Schema.SObjectField field = M.get(fieldName);
        Schema.DisplayType FldType = field.getDescribe().getType();

        return FldType;
    } 

    public class Request {
        @InvocableVariable
        public String inputJSONString;
        @InvocableVariable
        public String keysToExtract;
        @InvocableVariable
        public String sobjectType;
    }

    private class ObjectKeyValue{
        private String key;
        private String value;
    }
    
    public class Response {
        @InvocableVariable
        public List<SObject> sobjectList;

        @InvocableVariable
        public String errors;
        
    }
}
