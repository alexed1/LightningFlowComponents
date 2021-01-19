public with sharing class ManageMultiselectField {
  
    @InvocableMethod(label='Manage Multiselect Field' description='Caries out a specified operation on the value of a specified multiselect field')
    public static List<Response> getNrecords(List<Request> requests) {
        
        List<Response> result = new List<Response>();

        for (Request curRequest : requests) {
            
            Response curResponse = new Response();
            //verify type of specified field
            validateFieldType(curRequest);
            String fieldValue = (String)curRequest.curRecord.get(curRequest.fieldApiName);
            List<String> selectedValues = fieldValue.split(';');

            switch on curRequest.operation {
                when 'CheckForValue' {
                    System.debug('selected values are: ' + selectedValues);
                    if (selectedValues.contains(curRequest.value)) {
                        curResponse.targetPresent= true;
                    } else curResponse.targetPresent = false;

                }
                when else {
                    throw new InvocableActionException('You didn\'t provide an opearation value that is currently supported');
                }
            }


            List<String> valueCollection = new List<String>();
            curResponse.fieldValues = selectedValues;
            result.add(curResponse);
 
        }
        return result;
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

        if (fieldDataType.name() != 'MULTIPICKLIST')
            throw new InvocableActionException('The specified field is not a multiselect picklist. It may be a standard picklist, in which case you should use a different solution');
    }
    
    /* Input parameters for the Apex action */
    public class Request{
        @InvocableVariable(label='Api name of the target Object' required = true )
        public string objectApiName; 
        
        @InvocableVariable(label='Api name of the target Field' required = true )
        public string fieldApiName;
        
        @InvocableVariable(label='Desired Action to carry out on the target multiselect field' required = true)
        public string operation;
        
        @InvocableVariable(label='Target Value')
        public string value;

        @InvocableVariable(label='SaveAutomatically')
        public string saveAutomatically;

        @InvocableVariable(label='Input Record')
        public SObject curRecord;
    }
    
    /* Output parameters of the Apex action */
    public class Response{
        @InvocableVariable(label='Values of the Multiselect Field, returned as a collection of strings')
        public List<String> fieldValues; 
        
        @InvocableVariable(label='Boolean result of a check for whether the provided value is present')
        public Boolean targetPresent;
    }

    public class InvocableActionException extends Exception{}
    
}
