public with sharing class ManagePicklistField {
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
                deployPickListValues(request.objectApiName + '.' + request.fieldName, picklistValueMap, request.action);
                resultList.add(new Results(null, true));
            }
        } catch(Exception e) {
            resultList.add(new Results(e.getMessage(), false));
        }
        return resultList;
    }

    public static void deployPickListValues(String apiName, Map<String, String> selectedPicklistValueMap, String picklistAction) {
        usf.MetadataService.MetadataPort service = usf.MetadataService.createService();   
        usf.MetadataService.CustomField customField = Test.isRunningTest() ? ManagePicklistFieldTest.getCustomField() : (usf.MetadataService.CustomField) service.readMetadata('CustomField', new String[] { apiName}).getRecords()[0];
        
        Integer activeValuesSize = 0;

        if(String.isNotEmpty(picklistAction)) {
            for(usf.MetadataService.CustomValue objCustomValue : customField.valueSet.valueSetDefinition.value){
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
        List<usf.MetadataService.SaveResult> lstResults = Test.isRunningTest() ? ManagePicklistFieldTest.getSaveResult() : service.updateMetadata( new usf.MetadataService.Metadata[] { customField });

        for (usf.MetadataService.SaveResult objResult : lstResults) {
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
