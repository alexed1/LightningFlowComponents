public with sharing class GetFieldInformation {
    @InvocableMethod
    public static List <Results> getFieldInformation(List<Requests> requestList) {

        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();
        response.fields = describeSObject(requestList[0].objectName);
        responseWrapper.add(response);
        return responseWrapper;

    }


    public static List<FieldDescriptor> describeSObject(String type) {
        return describeSObjects(new List<String>{
                type
        }).get(type);
    }

    public static Map<String, List<FieldDescriptor>> describeSObjects(List<String> types) {

        Map<String, List<FieldDescriptor>> objectToFieldDescribe = new Map<String, List<FieldDescriptor>>();
        if (types == null || types.isEmpty()) {
            return objectToFieldDescribe;
        }

        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);

        for (Schema.DescribeSobjectResult res : results) {
            String objName = res.getName();
            objectToFieldDescribe.put(objName, new List<FieldDescriptor>());
            Map<String, SObjectField> fieldMap = res.fields.getMap();
            for (String fieldApiName : fieldMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldApiName).getDescribe();
                objectToFieldDescribe.get(res.getName()).add(new FieldDescriptor(fieldDescribe.getName(), fieldDescribe.getLabel(), fieldDescribe.getType().name(), !fieldDescribe.isNillable()));
            }
        }

        return objectToFieldDescribe;
    }

    public class Requests {

        @InvocableVariable(required=true)
        public String objectName;
    }

    public class Results {

        @InvocableVariable
        public List<FieldDescriptor> fields;
    }
}