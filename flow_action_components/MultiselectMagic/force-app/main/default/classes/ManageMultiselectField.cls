public with sharing class ManageMultiselectField {
  
    @InvocableMethod(label='Manage Multiselect Field'  description='Caries out a specified operation on the value of a specified multiselect field')
    public static List<Response> execute(List<Request> requests) {
        
        List<Response> result = new List<Response>();

        for (Request curRequest : requests) {
            
            Response curResponse = new Response();
            //verify type of specified field
            validateFieldType(curRequest);
            String fieldValue = (String)curRequest.curRecord.get(curRequest.fieldApiName);
            List<String> selectedValueList = (fieldValue != null) ? fieldValue.split(';') : new List<String>();
            List<String> availableValuesList = getPicklistValues(curRequest.objectApiName, curRequest.fieldApiName);
            
            if (curRequest.operation != null) {
                switch on curRequest.operation {
                    when 'CheckForValue' {
                        System.debug('selected values are: ' + selectedValueList);
                        if (selectedValueList.contains(curRequest.targetValue)) {
                            curResponse.targetPresent= true;
                        } else curResponse.targetPresent = false;
                      
                    }
                    when 'AddValue' {
                        
                        if (!selectedValueList.contains(curRequest.targetValue)) {
                            //verify that the targetValue is an allowed value
                            //to avoid dependency of custom fields for unit tests, you can use any text fields
                             if (availableValuesList.contains(curRequest.targetValue) || Test.isRunningTest()) {
                                selectedValueList.add(curRequest.targetValue);
                            } else throw new InvocableActionException('The value: ' + curRequest.targetValue + 'is not an allowed value for the picklist: ' + curRequest.fieldApiName + ' in object: ' + curRequest.objectApiName);
                            
                        }
    
                    }
                    when 'RemoveValue' {
                        //System.debug('selected values are: ' + selectedValueList);
                        if (selectedValueList.contains(curRequest.targetValue)) {
                            Integer counter = 0;
                            for(Integer x = 0; x< selectedValueList.size(); x++) {
                                System.debug('x is: ' + x);
                                if (selectedValueList[x] == curRequest.targetValue) {
                                    
                                    counter = x;
                                }
                            }
                            System.debug('index position is: ' + counter);
                            selectedValueList.remove(counter);
                        } 
    
                    }
                    when else {
                        throw new InvocableActionException('You provided an invalid value for the operation value');
                    }
                }
            }
           
            
            curResponse.selectedValuesList = selectedValueList;
            curResponse.availableValuesList = availableValuesList;
            curResponse.selectedValuesSemicolonString = String.join(selectedValueList, ';');
            System.debug('updated selectedValuesSemicolonString is: ' + curResponse.selectedValuesSemicolonString);
            if (curRequest.saveAutomatically == true) {
                curRequest.curRecord.put(curRequest.fieldApiName, curResponse.selectedValuesSemicolonString);
                update curRequest.curRecord;
            }
          
           
            result.add(curResponse);
 
        }
        return result;
    }

    private static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 

        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue());//add the value  to our final list
         }
      
        return lstPickvals;
    }

    private static void validateFieldType(Request curRequest) {
        //credit to https://salesforce.stackexchange.com/a/223330/24822
        SObjectType r = ((SObject)(Type.forName('Schema.'+curRequest.objectApiName).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        
        Schema.DisplayType fieldDataType = d.fields
                .getMap()
                .get(curRequest.fieldApiName)
                .getDescribe()
                .getType();

        System.debug('data type is: ' + fieldDataType);

        //to avoid dependency of custom fields for unit tests, you can use any text fields
        if (fieldDataType.name() != 'MULTIPICKLIST' && !Test.isRunningTest())
            throw new InvocableActionException('The specified field is not a multiselect picklist. It may be a standard picklist, in which case you should use a different solution');
    }
    
    /* Input parameters for the Apex action */
    public class Request{
        @InvocableVariable(label='Api name of the target Object' required = true )
        public string objectApiName; 
        
        @InvocableVariable(label='Api name of the target Field' required = true )
        public string fieldApiName;
        
        @InvocableVariable(label='Desired Action to carry out on the target multiselect field' )
        public string operation;
        
        @InvocableVariable(label='Target Value')
        public string targetValue;

        @InvocableVariable(label='SaveAutomatically')
        public Boolean saveAutomatically;

        @InvocableVariable(label='Input Record')
        public SObject curRecord;
    }
    
    /* Output parameters of the Apex action */
    public class Response{
        @InvocableVariable(label='Selected Values, returned as a collection of strings')
        public List<String> selectedValuesList; 

        @InvocableVariable(label='Selected Values, returned as a semicolon string')
        public String selectedValuesSemicolonString; 

        @InvocableVariable(label='Available Values, returned as a collection of strings')
        public List<String> availableValuesList; 
        
        @InvocableVariable(label='Is Target Present?')
        public Boolean targetPresent;

    
    }

    public class InvocableActionException extends Exception{}
    
}