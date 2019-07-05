//invocable action that, when provided with the name of an object and a picklist field, returns the vales of the picklist
//see https://unofficialsf.com/flow-action-get-picklist-values/

public with sharing class GetPicklistValues {
  
    @InvocableMethod
    public static List <Results> getPicklistVals(List<Requests> requestList) {
        System.debug('entering getPicklistVals');
        String objectName = requestList[0].objectName;
        String fieldName = requestList[0].fieldName;
        System.debug('object and field are  :' + objectName + 'and ' + fieldName );

        SObjectType objectType = ((SObject) Type.forName(objectName).newInstance())
                                  .getSObjectType();  //courtesy of cropredy and sfdcfox https://salesforce.stackexchange.com/a/250041/24822

        //General code below courtesy of sfdcmonkey http://sfdcmonkey.com/2016/12/05/how-to-fetch-picklist-value-from-sobject-and-set-in-uiinputselect/

        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objectType.getDescribe();
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
        fieldMap.get(fieldName).getDescribe().getPickListValues();

        List<String> picklistStringVals = new List<String>();

        //assemble the values into a List of strings
        for (Schema.PicklistEntry a: values) {
            picklistStringVals.add(a.getValue());
        }
        
        Results response = new Results();
        List<Results> responseWrapper= new List<Results>();

        response.picklistValues = picklistStringVals;
        responseWrapper.add(response);
        return responseWrapper;
    
    }

    public class Requests {
      @InvocableVariable(required=true)
      public String objectName;

      @InvocableVariable(required=true)
      public String fieldName;
        
    }
    
    public class Results {
     
      @InvocableVariable
      public List<String> picklistValues;
    }
}


