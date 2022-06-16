/**
 * Invocable Apex Action for Flow:  GetRecordsIn
 * 
 * Created By:  Eric Smith
 * 
 * Description: This component is designed to be an alternative to the standard Get Records Flow element.
 *              In place of the normal selection and filter attributes, it is designed to return a collection of records
 *              where the value of a field in the record is IN a collection of values passed into the component.
 * 
 * Custom Property Editor:          GetRecordsInCPE
 * 
 * CPE Supporting Components:       Thanks to David Fromstein for wonderful new versions of Combobox and Object and Field selector
 *                                  ObjectFieldSelectorController.cls, ObjectFieldSelectorControllerTest.cls
 *                                  LWCs: df_combobox, dfcomboboxUtils, df_fieldSelector2, df_objectSelector, df_objectFieldSelectorUtils
 * 
 * 06/05/22 -   Eric Smith -    Version 1.0.0   
 * 
 **/

global with sharing class GetRecordsIn {
    
    /* Flow Action */
    @invocableMethod(label='Get Records IN by Eric Smith'
        iconName='slds:standard:record_lookup'
        configurationEditor='c:getRecordsInCPE' 
        description='Perform a Get records WHERE a field value is IN a collection of values')
    global static List<Results> GetRecordsIn(List<Requests> requestList) {

        /* Prepare Response */
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();

        /* Process Inputs */
        for (Requests req : requestList) {  

            /* Get Input Values */
            String targetField = req.targetField;
            String outputObject = req.outputObject;
            String storeFieldsMethod = req.storeFieldsMethod;
            String outputFieldNames = req.outputFieldNames;
            String sourceMethod = req.sourceMethod;
            String sourceValueString = req.sourceValueString;
            String sourceDelimiter = req.sourceDelimiter;
            List<String> sourceValueCollection = req.sourceValueCollection;
            List<SObject> sourceRecordCollection = req.sourceRecordCollection;
            String sourceField = req.sourceField;
            String sourceObject = req.sourceObject;
            // String outputSortOrder = req.outputSortOrder;
            // String sortFieldName = req.sortFieldName;

            /* Perform Action(s) */

            String inValues = '';
            String soqlQuery = '';

            if (sourceMethod == 'String' && sourceValueString != null && sourceValueString != '') {
                sourceValueCollection = sourceValueString?.split(sourceDelimiter);
            }
            if (sourceMethod != 'Object' && sourceValueCollection != null && !sourceValueCollection.isEmpty()) {
                inValues = '\'' + String.join(sourceValueCollection, '\',\'') + '\'';
            } else {
                if (sourceMethod == 'Object' && sourceField != null && sourceObject != null && sourceField != '' && sourceObject != '') {
                    inValues = 'SELECT ' + sourceField + ' FROM ' + sourceObject;
                }
            }
            
            String fieldList = (storeFieldsMethod == 'Auto') ? getAllFields(outputObject) : outputFieldNames;

            if (inValues != '') {
                soqlQuery = 'SELECT ' + fieldList + ' FROM ' + outputObject + ' WHERE ' + targetField + ' IN (' + inValues + ')';
                System.debug('GetRecordsIn SOQL Query --- ' + soqlQuery);
                try {
                    List<SObject> queryResult = Database.query(soqlQuery);
                    if (queryResult.size() > 0) {
                        response.outputCollection = queryResult;
                    }
                } catch (Exception e) {
                    System.debug('GetRecordsIn SOQL Query ERROR --- ' + e);
                }
            }

            /* Process Outputs */
            responseWrapper.add(response);
        }

        /* Return Results */
        return responseWrapper;
    }

    public static String getAllFields(String ObjectName) {
        List<String> fields = new List<String>(Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().keySet());
        return String.join(fields, ',');
    }

    /* Input parameters for the Apex action */
    global class Requests {
        
        @invocableVariable(label='Output Object Name')
        global String outputObject;

        @invocableVariable(label='Target Field Name (Id)')
        global String targetField = 'Id';

        @invocableVariable(label='Store Fields Method')
        global String storeFieldsMethod = 'Auto';

        @invocableVariable(label='Output Field Names')
        global String outputFieldNames = 'Id,Name';

        @invocableVariable(label='Source Method (String, Collection, Object)')
        global String sourceMethod = 'String';

        @invocableVariable(label='Source Value String')
        global String sourceValueString;

        @invocableVariable(label='Source Value String Delimiter (,)')
        global String sourceDelimiter = ',';

        @invocableVariable(label='Source Value Collection')
        global List<String> sourceValueCollection;

        @invocableVariable(label='Source Object Name')
        global String sourceObject;  

        @invocableVariable(label='Source Record Collection')
        global List<SObject> sourceRecordCollection;

        @invocableVariable(label='Source Field Name (Id)')
        global String sourceField = 'Id';

        // TODO: Add Sort Output Records
        // @invocableVariable(label='Output Sort Order')
        // global String outputSortOrder = 'Not Sorted';

        // @invocableVariable(label='Sort By Field Name')
        // global String sortFieldName;

    }

    /* Output parameters of the Apex action */
    global class Results {
        @invocableVariable(label='Output Record Collection')
        global List<SObject> outputCollection;
    }

}
