public with sharing class RetrievePicklistValues {
    final static string CUSTOM_FIELD_POSTFIX = '__c';
    @InvocableMethod
    public static List<Results> getPicklistValues (List<Requests> requestList) {
        System.debug('Result:' + requestList);
        List<Results> resultList = new List<Results>();
        for(Requests request : requestList) {
             resultList.add(new Results(JSON.serialize(ufs.FieldPickerController.getPicklistValues(request.objectApiName, request.fieldName)), request.fieldName.endsWith(CUSTOM_FIELD_POSTFIX)));
        }// add ufs name space
        return resultList;
    }

    public class Requests {

        @InvocableVariable
        public String objectApiName;
  
        @InvocableVariable
        public String fieldName;
    }

    public class Results {

        @InvocableVariable
        public String memberListJSON;
        @InvocableVariable
        public Boolean isCustomField;

        public Results(String memberListJSON, Boolean isCustomField) {
            this.memberListJSON = memberListJSON;
            this.isCustomField = isCustomField;
        }
    }
}
