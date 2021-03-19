public with sharing class ManagePicklistField {
    final static string CUSTOM_FIELD_POSTFIX = '__c';
    
    @InvocableMethod
    public static List<Results> managePicklistField (List<Requests> requestList) {
        List<Results> resultList = new List<Results>();
        try {
            for(Requests request : requestList) {
                List<usf.FieldPickerController.Member> picklistValueNameList = (List<usf.FieldPickerController.Member>)JSON.deserialize(request.picklistValueNameListJSON, List<usf.FieldPickerController.Member>.class);
                Map<String, String> picklistValueMap = new Map<String,String>();
                for(usf.FieldPickerController.Member item : picklistValueNameList) {
                    picklistValueMap.put(item.value, item.value);
                }
                usf.DeployMetadata.deployPickListValues(request.objectApiName + '.' + request.fieldName, picklistValueMap, request.action);
                resultList.add(new Results(null, true));
            }
        } catch(Exception e) {
            resultList.add(new Results(e.getMessage(), false));
        }
        return resultList;
    }

    public class Requests {

        @InvocableVariable
        public String objectApiName;
  
        @InvocableVariable
        public String fieldName;

        @InvocableVariable
        public String action;

        @InvocableVariable
        public String picklistValueNameListJSON;
    }

    public class Results {

        @InvocableVariable
        public Boolean isSuccess;

        @InvocableVariable
        public String errorMessage;

        public Results(String errorMessage, Boolean isSuccess) {
            this.errorMessage = errorMessage;
            this.isSuccess = isSuccess;
        }
    }
}
