public with sharing class UpdateField {

    @InvocableMethod(label='Update Field' configurationEditor='c:updateFieldCPE')
    public static List<Response> execute (List<Request> requests) {
        String objectId = requests[0].objectId;
        String fieldName = requests[0].fieldName;
        String formula = requests[0].formula;

        System.debug('requests is' + requests);
        List<ContextWrapper> contextWrappers = new List<ContextWrapper>();
        contextWrappers.add(new ContextWrapper('$Record',  objectId));

        String fieldValue = fbc_FormulaEvaluator.parseFormula( formula, JSON.serialize(contextWrappers));
        System.debug(fieldValue);
        String objectAPIName;
        String keyPrefix = objectId.substring(0,3);

        for (Schema.SObjectType obj : Schema.getGlobalDescribe().Values()){
            String prefix = obj.getDescribe().getKeyPrefix();
            if (prefix == keyPrefix && prefix.indexOf(keyPrefix) != -1){
                objectAPIName = obj.getDescribe().getName();
                break;
            }
        }

        Schema.DescribeSObjectResult describeObject = Schema.getGlobalDescribe().get(objectAPIName).getDescribe();
        Map<String, Schema.SObjectField> fields = describeObject.fields.getMap();
        String fieldType = String.valueOf(fields.get( fieldName).getDescribe().type);

        sObject currentObject = Schema.getGlobalDescribe().get(objectAPIName).newSObject();
        currentObject.put('Id',  objectId);

        if (fieldType == 'BOOLEAN') {
            currentObject.put( fieldName, Boolean.valueOf(fieldValue));
        } else if (fieldType == 'CURRENCY' || fieldType == 'PERCENT' || fieldType == 'DOUBLE') {
            currentObject.put( fieldName, Decimal.valueOf(fieldValue));
        } else if (fieldType == 'DATE') {
            currentObject.put( fieldName, Date.valueOf(fieldValue));
        } else if (fieldType == 'DATETIME') {
            currentObject.put( fieldName, Datetime.valueOf(fieldValue));
        } else if (fieldType == 'INTEGER') {
            currentObject.put( fieldName, Integer.valueOf(fieldValue));
        } else {
            currentObject.put( fieldName, fieldValue);
        }

        Database.SaveResult updateResult = Database.update(currentObject, true);

        /*    if (!result.isSuccess()) {
            throw new UpdateFieldActionException(result.getErrors()[0].getMessage());
        }  */

        //Create a Results object to hold the return values
        Response response = new Response();

        //add the return values to the Results object
        response.isSuccess = updateResult.isSuccess();
        response.errors = packErrorString(updateResult);
    
        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Response> responseWrapper= new List<Response>();
        responseWrapper.add(response);
        return responseWrapper;


        
        
    }

    public static String packErrorString(Database.SaveResult saveResult) {
        String errorString = '';
        for(Database.Error err : saveResult.getErrors()) {
            errorString = errorString + (' The following error has occurred.');                   
            errorString = errorString + (' ' + err.getStatusCode() + ': ' + err.getMessage());
        }
        return errorString;

    }

    public class Request {
        @InvocableVariable(required=true)
        public String objectId;

        @InvocableVariable(required=true)
        public String fieldName;

        @InvocableVariable(required=true)
        public String formula;
    }

    public class Response {
        @InvocableVariable
        public Boolean isSuccess;

        @InvocableVariable
        public String errors;

    
    }

    public class ContextWrapper {
        public String name;
        public String value;

        public ContextWrapper(String name, String value) {
            this.name = name;
            this.value = value;
        }
    }

    class UpdateFieldActionException extends Exception {}
}
