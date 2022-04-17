global with sharing class GetFieldInformation {
    @InvocableMethod
    global static List <Results> getFieldInformation(List<Requests> requestList) {

        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();
        response.fields = describeSObject(requestList[0].objectName);
        responseWrapper.add(response);
        return responseWrapper;

    }


    global static List<FieldDescriptor> describeSObject(String type) {
        return describeSObjects(new List<String>{
                type
        }).get(type);
    }

    global static Map<String, List<FieldDescriptor>> describeSObjects(List<String> types) {

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
                objectToFieldDescribe.get(res.getName()).add(new FieldDescriptor(fieldDescribe)); 
           }
        }

        return objectToFieldDescribe;
    }


    global static Map<String, FieldDescriptor> describeSObjects(String obj) {

        Map<String, FieldDescriptor> objectToFieldDescribe = new Map<String, FieldDescriptor>();

        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(new List<String>{obj});

        for (Schema.DescribeSobjectResult res : results) {
            Map<String, SObjectField> fieldMap = res.fields.getMap();
            for (String fieldApiName : fieldMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldApiName).getDescribe();
                objectToFieldDescribe.put(fieldApiName, new FieldDescriptor(fieldDescribe));
            }
        }

        return objectToFieldDescribe;
    }

    global class Requests {

        @InvocableVariable(required=true)
        global String objectName;
    }

    global class Results {

        @InvocableVariable
        global List<FieldDescriptor> fields;
    }
}