/**
 * @description       : Pairs with ExecuteSOQL or RecordDetailFSC (or other actions) and returns a Text Collection or Comma-Separated String of fields contained in an object's Field Set. Useful
 * For abstracting values out of the Flow so that it can be extended with minimal edits to the Flow.
 * @author            : Adam White
 * @last modified on  : 11-02-2020
 * @last modified by  : Adam White
 * Modifications Log 
 * Ver   Date         Author                               						  Modification
 * 1.0   11-02-2020   Adam White, https://www.linkedin.com/in/declarativeninja/   Initial Version
**/

public with sharing class GetFieldSetValues {
    @InvocableMethod
    public static List <Results> getFieldSetVals(List<Requests> requestList) {
        Results response = new Results();
        List <Results> responseWrapper = new List<Results>();

            
        for (Requests req : requestList) {  
            String objectName = req.objectName;
            String fieldSetName = req.fieldSetName;
            String csvOfFields = '';
            List<String> textCollectionOfFields = new List<String>();

            // Looks up the FieldSetMembers for the supplied object name and field set name
         	List<Schema.FieldSetMember> objFS = Schema.getGlobalDescribe().get(objectName).getDescribe().FieldSets.getmap().get(fieldSetName).getFields();
             
            // We loop over each FieldSetMember and retrieve the field name for each then add it to a text collection
            for (Schema.FieldSetMember field : objFS) {
                If( field.getFieldPath() != null) {
               		textCollectionOfFields.add(field.getFieldPath());
                    }
                }
            //converts the text collection to a comma-separated string that we then output back into flow
           		csvOfFields = string.join(textCollectionOfFields,',');
            
                response.fieldSetValueCSV = csvOfFields;
            	response.fieldSetValueCollection = textCollectionOfFields;
                responseWrapper.add(response);

        }

    return responseWrapper;

    }   

    // wrapper to hold the inputs and outputs from flow
    public class Requests {
        @InvocableVariable(required=true)
        public String objectName;
  
        @InvocableVariable(required=true)
        public String fieldSetName;
          
      }
      
      public class Results {
       
        @InvocableVariable
        public List<String> fieldSetValueCollection;

        @InvocableVariable
        public String fieldSetValueCSV;
      }

}