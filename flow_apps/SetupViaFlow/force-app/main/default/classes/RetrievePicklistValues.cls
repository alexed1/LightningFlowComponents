public with sharing class RetrievePicklistValues {
    @InvocableMethod
    public static List<Results> getPicklistValues (List<Requests> requestList) {
        List<Results> resultList = new List<Results>();
        for(Requests request : requestList) {
            List<Object> picklistValuesList = new List<Object>();
            if(request.fieldName.endsWith(Label.CUSTOM_FIELD_POSTFIX_LABEL)) {
                picklistValuesList = getPickListValuesForCustomField(request.objectApiName + '.' + request.fieldName);
            } else {
                picklistValuesList = usf.FieldPickerController.getPicklistValues(request.objectApiName, request.fieldName);
            }
            resultList.add(new Results(
                JSON.serialize(picklistValuesList), 
                request.fieldName.endsWith(Label.CUSTOM_FIELD_POSTFIX_LABEL),
                picklistValuesList.size()

            ));
        }
        return resultList;
    }

    public static List<usf.FieldPickerController.Member> getPickListValuesForCustomField(String apiName) {
        usf.MetadataService.MetadataPort service = usf.MetadataService.createService();
        List<usf.FieldPickerController.Member> picklistValueList = new List<usf.FieldPickerController.Member>();
        usf.MetadataService.CustomField customField = (usf.MetadataService.CustomField) service.readMetadata('CustomField', new String[] { apiName}).getRecords()[0];
        for(usf.MetadataService.CustomValue item : customField.valueSet.valueSetDefinition.value) {
            picklistValueList.add(new usf.FieldPickerController.Member(item.FullName, item.label, (item.isActive == null ? true : item.isActive), item.default_x));
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
