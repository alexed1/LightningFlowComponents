public with sharing class RetrievePicklistValues {
    @InvocableMethod
    public static List<Results> getPicklistValues (List<Requests> requestList) {
        List<Results> resultList = new List<Results>();
        for(Requests request : requestList) {
            List<Object> picklistValuesList = new List<Object>();
            if(request.fieldName.endsWith(Label.CUSTOM_FIELD_POSTFIX_LABEL)) {
                picklistValuesList = getPickListValuesForCustomField(request.objectApiName + '.' + request.fieldName);
            } else {
                picklistValuesList = usf3.FieldPickerController.getPicklistValues(request.objectApiName, request.fieldName);
            }
            resultList.add(new Results(
                JSON.serialize(picklistValuesList), 
                request.fieldName.endsWith(Label.CUSTOM_FIELD_POSTFIX_LABEL),
                picklistValuesList.size()

            ));
        }
        return resultList;
    }

    public static List<usf3.FieldPickerController.Member> getPickListValuesForCustomField(String apiName) {
        usf3.MetadataService.MetadataPort service = usf3.MetadataService.createService();
        List<usf3.FieldPickerController.Member> picklistValueList = new List<usf3.FieldPickerController.Member>();
        usf3.MetadataService.CustomField customField = Test.isRunningTest() ? ManagePicklistFieldTest.getCustomField() : (usf3.MetadataService.CustomField) service.readMetadata('CustomField', new String[] { apiName}).getRecords()[0];
        for(usf3.MetadataService.CustomValue item : customField.valueSet.valueSetDefinition.value) {
            picklistValueList.add(new usf3.FieldPickerController.Member(item.FullName, item.label, (item.isActive == null ? true : item.isActive), item.default_x));
        }
		return picklistValueList;
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
        @InvocableVariable
        public Integer listSize;

        public Results(String memberListJSON, Boolean isCustomField, Integer listSize) {
            this.memberListJSON = memberListJSON;
            this.isCustomField = isCustomField;
            this.listSize = listSize;
        }
    }
}
