global with sharing class GetSelectedFieldInformation {
    @InvocableMethod
    global static List<Results> getFieldInformation(List<Requests> requestList) {

        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();
        if((requestList[0].fieldList == null || requestList[0].fieldList.isEmpty()) && String.isNotEmpty(requestList[0].fieldListString)) {
            requestList[0].fieldList =  requestList[0].fieldListString.split(',');
        }

        List<usf3.FieldDescriptor> fields = usf3.GetFieldInformation.describeSObject(requestList[0].objectName);
        response.fields = new List<usf3.FieldDescriptor>();

        for(String fieldName : requestList[0].fieldList) {
            for(usf3.FieldDescriptor field : fields) {
                if(field.name == fieldName) {
                    response.fields.add(field);
                }
            }
        }
        responseWrapper.add(response);
        return responseWrapper;

    }

    global class Requests {

        @InvocableVariable(required=true)
        global String objectName;
        @InvocableVariable
        global String fieldListString;
        @InvocableVariable
        global List<String> fieldList;

    }

    global class Results {

        @InvocableVariable
        global List<usf3.FieldDescriptor> fields;
    }
}
