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
                Set<String> relationshipFields = new Set<String>();
                Map<String, Map<String, usf.FieldDescriptor>> relationshipObjectDescribe = new Map<String, Map<String, usf.FieldDescriptor>>();
                if(hasRelationshipFields){
                    relationshipFieldsMap.putAll(database.query('SELECT ' + string.escapeSingleQuotes(shownFields) + ' FROM ' + inputCollection[0].getSObjectType() + ' WHERE Id IN :inputCollection'));
                    for(string s : shownFieldsArray){
                        if(s.contains('.')){
                            relationshipFields.add(s);
                        }
                    }
                    Map<String, usf.FieldDescriptor> originalObjectfieldMap = usf.GetFieldInformation.describeSobjects(String.valueOf(inputCollection[0].getSobjectType()));
                    
                    relationshipObjectDescribe = getRelatedObjectInformation(relationshipFields, originalObjectfieldMap);
                }
                System.debug('first value in shownFieldsArray is: ' + shownFieldsArray[0]);
                switch on displayMode {
                    when 'simple' {
                        reportString = generateSimpleMode(reportString, shownFieldsArray, inputCollection, relationshipFieldsMap, relationshipObjectDescribe);
                    }
                    when 'table' {
                        reportString = generateTableMode(reportString, shownFieldsArray, inputCollection, relationshipFieldsMap, relationshipObjectDescribe);
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

    global static String generateTableMode(String reportString, List<String> shownFieldsArray, List<SObject> inputCollection, Map<Id, Sobject> relationshipFieldsMap,  Map<String, Map<String, usf.FieldDescriptor>> relationshipObjectDescribe) {
        
        Map<String, usf.FieldDescriptor> fieldMap = usf.GetFieldInformation.describeSobjects(String.valueOf(inputCollection[0].getSobjectType()));
        
        String tableHTML;
        if (!shownFieldsArray.isEmpty()) { 
            tableHTML = '<table style="' + tableStyleString + '">' ;

            if (!hideHeader) {
                // buildheader
                tableHTML += '<tr>';
                //TODO make sure this works when the field is an empty screen
                for (String fieldName : shownFieldsArray) {
                    String label = getFieldLabel(fieldName, fieldMap, relationshipObjectDescribe);
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
                if(relationshipObjectDescribe != null && !relationshipObjectDescribe.isEmpty()){
                	fieldValue = generateCellFromFieldName(fieldName, relationshipFieldsMap.get(record.Id));   
                } else {
                	fieldValue = generateCellFromFieldName(fieldName, record);
                }
                tableHTML += '<td style="' + rowStyleString + '">' + fieldValue + '</td>';
             } 
             tableHTML += '</tr>';
           }
           tableHTML += '</table>';
        }
        return tableHTML;
    }

    global static String generateSimpleMode(String reportString, List<String> shownFieldsArray, List<SObject> inputCollection, Map<Id, Sobject> relationshipFieldsMap, Map<String, Map<String, usf.FieldDescriptor>> relationshipObjectDescribe) {
        if (!shownFieldsArray.isEmpty()) {
            for (SObject record: inputCollection) {
                reportString += 'Record: ';

                Map<String, usf.FieldDescriptor> fieldMap = usf.GetFieldInformation.describeSobjects(String.valueOf(inputCollection[0].getSobjectType()));

                for (String fieldName : shownFieldsArray) {
                    String fieldValue = '';
                    if(relationshipObjectDescribe != null && !relationshipObjectDescribe.isEmpty()){
                        fieldValue = generateCellFromFieldName(fieldName, relationshipFieldsMap.get(record.Id));   
                    } else {
                        fieldValue = generateCellFromFieldName(fieldName, record);
                    }
                    reportString += getFieldLabel(fieldName, fieldMap, relationshipObjectDescribe) + ' : ' + fieldValue + '\n';
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
    private static string getFieldLabel(String fieldName, Map<String, usf.FieldDescriptor> fieldMap, Map<String, Map<String, usf.FieldDescriptor>> relationshipObjectDescribe){
        // If the field contains a '.' then it is a relationship field
        // Otherwise, use the fieldmap to look up the value
        if(fieldName.contains('.')){
            // Process the field API Name to use __c for custom fields or id for standard
            String originalField = getOriginalField(fieldName);
            string relationshipToRetrieve = fieldMap.get(originalfield).referenceTo[0];
            // Leading space to append object name to front
            return getRelationshipFieldName(fieldName.toLowerCase().right(fieldName.length() - fieldName.IndexOf('.') - 1), '', relationshipToRetrieve, relationshipObjectDescribe);
        } else {
           return fieldMap.get(fieldName.toLowerCase()).label; 
        }
    }
    
    /*
     * @description returns original field api name in relationship query
     * @param fieldName current field name
     * @return string
     */
    private static string getOriginalField(string fieldName){
        String originalField = fieldName.toLowerCase().left(fieldName.IndexOf('.'));
        if(originalField.contains('__r')){
            originalField = originalField.replace('__r', '__c');
        } else {
            originalField = originalField + 'id';
        }
        return originalField;
    }
    
    /*
     * @description Retrieve related object details for constructing appropriate labels
     * @param
     * @return Map<String, List<usf.FieldDescriptor>>
     */
    private static Map<String, Map<String, usf.FieldDescriptor>> getRelatedObjectInformation(Set<String> relationshipFields, Map<String, usf.FieldDescriptor> originalObjectfieldMap){
        Map<String, Map<String, usf.FieldDescriptor>> relationshipObjectDescribe = new Map<String, Map<String, usf.FieldDescriptor>>();

        for(string s : relationshipFields){
            string originalField = getOriginalField(s);
            if(originalObjectfieldMap.containsKey(originalfield)){
                string relationshipToRetrieve = originalObjectfieldMap.get(originalfield).referenceTo[0];
                if(relationshipObjectDescribe != null){
                    Map<String, usf.FieldDescriptor> fieldMap = usf.GetFieldInformation.describeSobjects(relationshipToRetrieve);
                    system.debug('>>> relationshipToRetrieve: ' + relationshipToRetrieve);
                    if(!relationshipObjectDescribe.containsKey(relationshipToRetrieve)){
                        relationshipObjectDescribe.put(relationshipToRetrieve, fieldMap);
                    }
                    
                    // Begin processing multiple relationship fields
                    string newRelationshipField = s.toLowerCase().right(s.length() - s.IndexOf('.') - 1); // Used if there is more than one relationship
                    system.debug('>>> newRelationshipField: ' + newRelationshipField);
                    if(newRelationshipField.contains('.')){ // If there isn't another relationship, nothing else to retrieve
                        Set<String> relationshipsToRetrieve = new Set<String>();
                        relationshipFields.add(newRelationshipField);
                        Map<String, Map<String, usf.FieldDescriptor>> newRelationshipObjectDescribe = getRelatedObjectInformation(relationshipFields, fieldMap);
                        for(String key : newRelationshipObjectDescribe.keySet()){
                            if(!relationshipObjectDescribe.containsKey(key)){
                                relationshipObjectDescribe.put(key, newRelationshipObjectDescribe.get(key));
                            }
                        }
                    }
                    // End processing if there are multiple relationship fields 
                }
            }
        }
        system.debug('>>> relationshipObjectDescribe: ' + relationshipObjectDescribe.keyset());
        return relationshipObjectDescribe;
    }
    
    /*
     * @description Gets relationship field name recursively to construct the label
     * @param fieldName current field API name being processed
     * @param processedName output label of the field
     * @param relationshipToRetrieve relationship that will be described
     * @param relationshipObjectDescribe All the object descriptions that will be needed to construct the label
     * @return string
     */
    private static String getRelationshipFieldName(string fieldName, string processedName, string relationshipToRetrieve, Map<String, Map<String, usf.FieldDescriptor>> relationshipObjectDescribe){
        
        Map<String, usf.FieldDescriptor> fieldMap = relationshipObjectDescribe.get(relationshipToRetrieve);

        if(fieldName.contains('.')){
            String originalField = getOriginalField(fieldName);
            String label = fieldMap.get(originalField).label.replace('ID', '');
            processedName += ' ' + label;
            string newRelationshipToRetrieve = fieldMap.get(originalfield).referenceTo[0];
            processedName = getRelationshipFieldName(fieldName.toLowerCase().right(fieldName.length() - fieldName.IndexOf('.') - 1), label, newRelationshipToRetrieve, relationshipObjectDescribe);
        } else {
            String label = fieldMap.get(fieldName).label;
            processedName += ' ' + label;
        }
        
        return processedName;
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