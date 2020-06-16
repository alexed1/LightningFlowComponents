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
                List<String> shownFieldsArray = shownFields.replaceAll('[^a-zA-Z0-9\\,]', '').split(',');
                System.debug('first value in shownFieldsArray is: ' + shownFieldsArray[0]);
                //System.debug('second value in shownFieldsArray is: ' + shownFieldsArray[1]);
                switch on displayMode {
                    when 'simple' {
                        reportString = generateSimpleMode(reportString, shownFieldsArray, inputCollection);
                    }
                    when 'table' {
                        reportString = generateTableMode(reportString, shownFieldsArray, inputCollection);
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
                    fieldValue = (String)record.get(fieldName);
                    if (fieldValue == null) fieldValue = '';
                } else fieldValue = fieldName;
                
            } 

        }
        return fieldValue;

    }

    global static String generateTableMode(String reportString, List<String> shownFieldsArray, List<SObject> inputCollection) {
       
        String tableHTML;
        if (!shownFieldsArray.isEmpty()) { 
            tableHTML = '<table style="' + tableStyleString + '">' ;

            if (!hideHeader) {
                // buildheader
                tableHTML += '<tr>';
                //TODO make sure this works when the field is an empty screen
                for (String fieldName : shownFieldsArray) {
                    String fieldValue = generateCellFromFieldName(fieldName, null);   
                    tableHTML += '<th style="' + headerStyleString + '">' + fieldValue + '</th>';
                    System.debug('tableHTML is currently: ' + tableHTML);
                }
                tableHTML += '</tr>';
            }
           

           // for each record, build row

           for (SObject record : inputCollection) {
             tableHTML += '<tr>';
             for (String fieldName : shownFieldsArray) {
                String fieldValue = generateCellFromFieldName(fieldName, record);   
                tableHTML += '<td style="' + rowStyleString + '">' + fieldValue + '</td>';
             } 
             tableHTML += '</tr>';
           }

           tableHTML += '</table>';

        }
        return tableHTML;
     

    }

    global static String generateSimpleMode(String reportString, List<String> shownFieldsArray, List<SObject> inputCollection ) {
        if (!shownFieldsArray.isEmpty()) {
            for (SObject acc : inputCollection) {
                reportString += 'Record: ';
                try {
                    reportString += acc.get('Name');
                } catch (Exception ex) {
                    reportString += acc.get('Id');
                }
                reportString += '\n';

                for (String fieldName : shownFieldsArray) {
                    reportString += fieldName + ' : ' + acc.get(fieldName) + '\n';
                }
                reportString += '\n\n';
            }
        }
        return reportString;
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