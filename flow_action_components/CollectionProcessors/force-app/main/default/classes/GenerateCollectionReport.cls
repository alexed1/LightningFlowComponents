global with sharing class GenerateCollectionReport {

    public static String tableStyleString;
    public static String headerStyleString;
    public static String rowStyleString;
    public static Boolean hideHeader;

    @InvocableMethod
    global static List<Results> generateReport(List<Requests> requestList) {
        List<Results> responseWrapper = new List<Results>();
        for (Requests curRequest : requestList) {
            List<SObject> inputCollection = curRequest.inputCollection != null ? curRequest.inputCollection : new List<SObject>();
            SObject inputRecord = curRequest.inputRecord;
            if (inputCollection == null && inputRecord == null)
                throw new InvocableActionException('You must pass in either an inputCollection or an inputRecord to the GenerateCollectionReport Action');
            
            //add the inputRecord to inputCollection so we can just handle inputCollection
            if ( inputRecord != null)
                inputCollection.add(inputRecord);


            String shownFields = curRequest.shownFields;
            String reportString = '';
            String displayMode = curRequest.displayMode != null ? curRequest.displayMode :  'simple';
            tableStyleString = curRequest.tableStyleString != null ? curRequest.tableStyleString :  '';
            headerStyleString = curRequest.headerStyleString != null ? curRequest.headerStyleString :  '';
            rowStyleString = curRequest.rowStyleString != null ? curRequest.rowStyleString :  '';
            hideHeader = curRequest.hideHeader != null ? curRequest.hideHeader :  false;
            if (inputCollection != null && !inputCollection.isEmpty() && shownFields != null) {
                reportString += 'Collection Type: ' + inputCollection[0].getSObjectType().getDescribe().getName() + '\n\n';
                List<String> shownFieldsArray = shownFields.replaceAll('[^a-zA-Z0-9\\,\\_\\.]', '').split(',');

                // Check if there are relationship fields, if so, perform the query for the IDs in the input collection
                // Then use the resulting map to get relationship values in generateCellFromFieldName()
                Boolean hasRelationshipFields = shownFields.contains('.');
                Map<Id, Sobject> relationshipFieldsMap = new Map<Id, Sobject>();
                if(hasRelationshipFields){
                    relationshipFieldsMap.putAll(database.query('SELECT ' + string.escapeSingleQuotes(shownFields) + ' FROM ' + inputCollection[0].getSObjectType() + ' WHERE Id IN :inputCollection'));
                }
                
                System.debug('first value in shownFieldsArray is: ' + shownFieldsArray[0]);
                switch on displayMode {
                    when 'simple' {
                        reportString = generateSimpleMode(reportString, shownFieldsArray, inputCollection, relationshipFieldsMap, hasRelationshipFields);
                    }
                    when 'table' {
                        reportString = generateTableMode(reportString, shownFieldsArray, inputCollection, relationshipFieldsMap, hasRelationshipFields);
                    }

                }

            }
            Results response = new Results();
            response.reportString = reportString;
            responseWrapper.add(response);
        }
        return responseWrapper;
    }

    global static String generateCellFromFieldName(String fieldName, SObject record) {
        String fieldValue;
        
        if (fieldName == '') {
            //user has entered an extra comma. treat this as an indent of four characters
            fieldValue = '    ';
        } else {
            if (fieldName == null){
            //treat nulls as blanks
                fieldValue = '';
            } else {
                if (record != null){
                    if(fieldName.contains('.')){ // Process relationship field
                        List<String> relationshipMap = fieldName.split('\\.');
                        for(integer i = 0; i < relationshipMap.size(); i++){
                            if(i < relationshipMap.size() - 1 && record != null){ 
                                record = record.getSobject(relationshipMap[i]); // Gets related field values
                            } else {
                                if(record == null){ // Handles where the value is blank on the related record
                                    fieldValue = '';
                                } else {
                                    fieldValue = String.valueOf(record.get(relationshipMap[i])); // Get final field value
                                }
                            }
                        }
                    } else { // Get value if not a relationship field
                        fieldValue = String.valueOf(record.get(fieldName));
                    }
                    if (fieldValue == null) fieldValue = '';
                } else fieldValue = fieldName;
            } 
        }
        return fieldValue;
    }

    global static String generateTableMode(String reportString, List<String> shownFieldsArray, List<SObject> inputCollection, Map<Id, Sobject> relationshipFieldsMap, Boolean hasRelationshipField) {
        
        Map<String, fbc_FieldDescriptor> fieldMap = fbc_GetFieldInformation.describeSobjects(String.valueOf(inputCollection[0].getSobjectType()));

        String tableHTML;
        if (!shownFieldsArray.isEmpty()) { 
            tableHTML = '<table style="' + tableStyleString + '">' ;

            if (!hideHeader) {
                // buildheader
                tableHTML += '<tr>';
                //TODO make sure this works when the field is an empty screen
                for (String fieldName : shownFieldsArray) {
                    String label = getFieldLabel(fieldName, fieldMap);
                    tableHTML += '<th style="' + headerStyleString + '">' + label + '</th>';
                    System.debug('tableHTML is currently: ' + tableHTML);
                }
                tableHTML += '</tr>';
            }
           
           // for each record, build row
           for (SObject record : inputCollection) {
             tableHTML += '<tr>';
             for (String fieldName : shownFieldsArray) {
                String fieldValue = '';
                if(!hasRelationshipField){
                	fieldValue = generateCellFromFieldName(fieldName, record);   
                } else {
                	fieldValue = generateCellFromFieldName(fieldName, relationshipFieldsMap.get(record.Id));
                }
                tableHTML += '<td style="' + rowStyleString + '">' + fieldValue + '</td>';
             } 
             tableHTML += '</tr>';
           }
           tableHTML += '</table>';
        }
        return tableHTML;
    }

    global static String generateSimpleMode(String reportString, List<String> shownFieldsArray, List<SObject> inputCollection, Map<Id, Sobject> relationshipFieldsMap, Boolean hasRelationshipField) {
        if (!shownFieldsArray.isEmpty()) {
            for (SObject record: inputCollection) {
                reportString += 'Record: ';

                Map<String, fbc_FieldDescriptor> fieldMap = fbc_GetFieldInformation.describeSobjects(String.valueOf(inputCollection[0].getSobjectType()));

                for (String fieldName : shownFieldsArray) {
                    String fieldValue = '';
                    if(!hasRelationshipField){
                        fieldValue = generateCellFromFieldName(fieldName, record);   
                    } else {
                        fieldValue = generateCellFromFieldName(fieldName, relationshipFieldsMap.get(record.Id));
                    }
                    reportString += getFieldLabel(fieldName, fieldMap) + ' : ' + fieldValue + '\n';
                }
                reportString += '\n\n';
            }
        }
        return reportString;
    }
    
    /* 
    * @description Returns the field label based on the input field API Name
    * @param fieldName API Name of the field to return
    * @param fieldMap map of the field describe results
    * @return string 
    */
    private static string getFieldLabel(String fieldName, Map<String, fbc_FieldDescriptor> fieldMap){
        system.debug(fieldName);
        // If the field contains a '.' then it is a relationship field
        // Otherwise, use the fieldmap to look up the value
        if(fieldName.contains('.')){
            // Process the field API Name to use __c for custom fields or id for standard
            String originalField = fieldName.toLowerCase().left(fieldName.IndexOf('.'));
            if(originalField.contains('__r')){
                originalField = originalField.replace('__r', '__c');
            } else {
                originalField = originalField + 'id';
            }
            String label = fieldMap.get(originalField).label.replace('ID', '');
            // Leading space to append object name to front
            if(fieldName.toLowerCase().contains('casenumber')){ // Handles cases
                return label + ' Number';
            } else if(fieldName.toLowerCase().contains('Subject')){ // Handles task
                return label + ' Subject';
            } else { // All other fields
                return label + ' Name';
            }
        } else {
           return fieldMap.get(fieldName.toLowerCase()).label; 
        }
    }
    
    global class Requests {
        @InvocableVariable 
        global List<SObject> inputCollection;

        @InvocableVariable 
        global SObject inputRecord;

        @InvocableVariable(required=true)
        global String shownFields;

        @InvocableVariable
        global String displayMode;

        @InvocableVariable
        global String tableStyleString;

        @InvocableVariable
        global String headerStyleString;

        @InvocableVariable
        global String rowStyleString;

        @InvocableVariable
        global Boolean hideHeader;
    }

    global class Results {

        @InvocableVariable
        global String reportString;

    }
    
    global class InvocableActionException extends Exception {}
}