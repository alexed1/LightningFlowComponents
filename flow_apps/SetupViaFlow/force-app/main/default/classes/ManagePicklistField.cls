public with sharing class ManagePicklistField {
    @InvocableMethod
    public static List<Results> managePicklistField (List<Requests> requestList) {
        List<Results> resultList = new List<Results>();
        try {
            for(Requests request : requestList) {
                List<usf3.FieldPickerController.Member> picklistValueNameList = (List<usf3.FieldPickerController.Member>)JSON.deserialize(request.picklistValueNameListJSON, List<usf3.FieldPickerController.Member>.class);
                Map<String, String> picklistValueMap = new Map<String,String>();
                for(usf3.FieldPickerController.Member item : picklistValueNameList) {
                    picklistValueMap.put(item.value, item.value);
                }
                deployPickListValues(request.objectApiName + '.' + request.fieldName, picklistValueMap, request.action);
                resultList.add(new Results(null, true));
            }
        } catch(Exception e) {
            resultList.add(new Results(e.getMessage(), false));
        }
        return resultList;
    }

    public static void deployPickListValues(String apiName, Map<String, String> selectedPicklistValueMap, String picklistAction) {
        usf3.MetadataService.MetadataPort service = usf3.MetadataService.createService();   
        usf3.MetadataService.CustomField customField = Test.isRunningTest() ? ManagePicklistFieldTest.getCustomField() : (usf3.MetadataService.CustomField) service.readMetadata('CustomField', new String[] { apiName}).getRecords()[0];
        
        Integer activeValuesSize = 0;

        if(String.isNotEmpty(picklistAction)) {
            for(usf3.MetadataService.CustomValue objCustomValue : customField.valueSet.valueSetDefinition.value){
                if(selectedPicklistValueMap.containsKey(objCustomValue.fullName)) {
                    objCustomValue.isActive = picklistAction == label.ACTIVATE_STATUS_LABEL ? true : false;
                }

                if(objCustomValue.isActive==null || objCustomValue.isActive) {
                    activeValuesSize++;
                }
            }
        }

        //check active values size
        if(activeValuesSize == 0) {
            throw new CustomException(Label.LEAVE_ONE_PICLIST_VALUE_MESSAGE);
        }

        // Update picklist values
        List<usf3.MetadataService.SaveResult> lstResults = Test.isRunningTest() ? ManagePicklistFieldTest.getSaveResult() : service.updateMetadata( new usf3.MetadataService.Metadata[] { customField });

        for (usf3.MetadataService.SaveResult objResult : lstResults) {
            if (!objResult.success) {
                throw new CustomException(Label.METADATA_DEPLOY_ERROR);
            }
        }
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

    class CustomException extends Exception {
            
    } 
}
