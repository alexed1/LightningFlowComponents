//so far this has been tested with Email fields and Picklist fields.
public with sharing class ExtractTextFromNonTextField {

   
    @InvocableMethod
    public static List <Results> extract (List<Requests> requestList) {
        System.debug('entering ExtractTextFromNonTextField');
        
        String recordId = requestList[0].recordId;
        String fieldName = requestList[0].fieldName;

        //Create a Results object to hold the return values
        Results response = new Results();

        //get the name of the object type
        Schema.SObjectType sobjectType = Id.valueOf(recordId).getSObjectType();
        System.debug('object type is: ' + sobjectType); 
        String sObjectName = sobjectType.getDescribe().getName();
        System.debug('object Name is: ' + sObjectName);   
        //load the record
        SObject record = Database.query('Select Id, ' + fieldName + ' From ' + sobjectName + ' Where Id = :recordId');
        System.debug('record is: ' + record);   

        String textValue = (String)record.get(fieldName);
        System.debug('text value is: ' + textValue);

        response.textValue = textValue;
        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);
         System.debug('response is: '+ response);
        System.debug('responseWrapper is: '+ responseWrapper);

        return responseWrapper;
    
    }



    public  class Requests {
      @InvocableVariable(required=true)
      public String recordId;

      @InvocableVariable
      public String fieldName;

        
    }
    
    public class Results {
     
      @InvocableVariable
      public String textValue;

    }
}
