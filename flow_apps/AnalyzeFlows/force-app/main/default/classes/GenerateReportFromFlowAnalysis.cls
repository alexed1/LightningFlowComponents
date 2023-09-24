global with sharing class GenerateReportFromFlowAnalysis {
    public static String tableStyleString;
    public static String headerStyleString;
    public static String rowStyleString;
    public static Boolean hideHeader;
    static List<String> columnLabelList = new List<String> {
        'Name',
        'Label',
        'Old Value',
        'New Value',
        'Change Type',
        'Element Type',
        'Description',
        'Notes'
    };

    @InvocableMethod
    global static List<Results> generateReport(List<Requests> requestList) {
        List<Results> responseWrapper = new List<Results>();
        for (Requests curRequest : requestList) {
            List<FlowAnalysis> inputCollection = curRequest.inputCollection != null ? curRequest.inputCollection : new List<FlowAnalysis>();
            FlowAnalysis inputRecord = curRequest.inputRecord;
            if (inputCollection == null && inputRecord == null)
                throw new InvocableActionException('You must pass in either an inputCollection or an inputRecord to the GenerateReportFromFlowAnalysis Action');
            
            //add the inputRecord to inputCollection so we can just handle inputCollection
            if ( inputRecord != null)
                inputCollection.add(inputRecord);


            String reportString = '';
            tableStyleString = curRequest.tableStyleString != null ? curRequest.tableStyleString :  '';
            headerStyleString = curRequest.headerStyleString != null ? curRequest.headerStyleString :  '';
            rowStyleString = curRequest.rowStyleString != null ? curRequest.rowStyleString :  '';
            hideHeader = curRequest.hideHeader != null ? curRequest.hideHeader :  false;
            List<ElementStatusChange> elementChangeList = new List<ElementStatusChange>();
            for(FlowAnalysis item : inputCollection) {
                elementChangeList.addAll(item.elementChanges);
            }
            if (inputCollection != null && !inputCollection.isEmpty()) {
                
                reportString = generateHeaderInfo(reportString, inputCollection[0]);
                reportString = generateTable(reportString,elementChangeList);


            }
            Results response = new Results();
            response.reportString = reportString;
            responseWrapper.add(response);
        }
        return responseWrapper;
    }

    global static String generateHeaderInfo(String reportString, FlowAnalysis flwAnalysis) {

        
        String flowInfoTableHTML = '<table>' ; 
        flowInfoTableHTML += '<tr>';
        flowInfoTableHTML += '<th>' + 'Flow Comparison Report' + '</th>';
        flowInfoTableHTML += '</tr>';

        flowInfoTableHTML += '<tr>';
        flowInfoTableHTML += '<th>' + 'Analysis Time' + '</th>';
        flowInfoTableHTML += '<td>' + flwAnalysis.analysisTime + '</td>';
        flowInfoTableHTML += '</tr>';

        flowInfoTableHTML += '<tr>';
        flowInfoTableHTML += '<th>' + 'Base Flow Name' + '</th>';
        flowInfoTableHTML += '<td>' + flwAnalysis.baseFlowName + '</td>';
        flowInfoTableHTML += '<th>' + 'Second Flow Name' + '</th>';
        flowInfoTableHTML += '<td>' + flwAnalysis.comparisonFlowName + '</td>';
        flowInfoTableHTML += '</tr>';

        flowInfoTableHTML += '<tr>';
        flowInfoTableHTML += '<th>' + 'Base Flow Version' + '</th>';
        flowInfoTableHTML += '<td>' + flwAnalysis.baseFlowVersion + '</td>';
        flowInfoTableHTML += '<th>' + 'Second Flow Version' + '</th>';
        flowInfoTableHTML += '<td>' + flwAnalysis.comparisonFlowVersion + '</td>';
        flowInfoTableHTML += '</tr>';

        flowInfoTableHTML += '<tr>';
        flowInfoTableHTML += '<th>' + 'Base Flow Status' + '</th>';
        flowInfoTableHTML += '<td>' + flwAnalysis.baseFlowStatus + '</td>';
        flowInfoTableHTML += '<th>' + 'Second Flow Status' + '</th>';
        flowInfoTableHTML += '<td>' + flwAnalysis.comparisonFlowStatus + '</td>';
        flowInfoTableHTML += '</tr>';
        flowInfoTableHTML += '</table> \n\n';
                
        reportString += flowInfoTableHTML;
        return reportString;
    }

    global static String generateTable(String reportString, List<ElementStatusChange> elementChangeList) {
                
        String tableHTML;
        tableHTML = '<table style="' + tableStyleString + '">' ;

        if (!hideHeader) {
            tableHTML += '<tr>';
            for (String fieldName : columnLabelList) {
                tableHTML += '<th style="' + headerStyleString + '">' + fieldName + '</th>';
                System.debug('tableHTML is currently: ' + tableHTML);
            }
            tableHTML += '</tr>';
        }
           
           // for each record, build row
        for (ElementStatusChange record : elementChangeList) {
            tableHTML += '<tr>';
            tableHTML += '<td style="' + rowStyleString + '">' + (record.name == null ? '' : record.name) + '</td>';
            tableHTML += '<td style="' + rowStyleString + '">' + (record.label == null ? '' : record.label) + '</td>';
            tableHTML += '<td style="' + rowStyleString + '">' + (record.oldValue == null ? 'N/A' : record.oldValue) + '</td>';
            tableHTML += '<td style="' + rowStyleString + '">' + (record.newValue == null ? 'N/A' : record.newValue) + '</td>';
            tableHTML += '<td style="' + rowStyleString + '">' + (record.changeType == null ? '' : record.changeType) + '</td>';
            tableHTML += '<td style="' + rowStyleString + '">' + (record.elementType == null ? '' : record.elementType) + '</td>';
            tableHTML += '<td style="' + rowStyleString + '">' + (record.description == null ? '' : record.description) + '</td>';
            tableHTML += '<td style="' + rowStyleString + '">' + (record.notes == null ? '' : record.notes) + '</td>';

             tableHTML += '</tr>';
           }
           tableHTML += '</table>';
           reportString += tableHTML;
        return reportString;
    }

    
    /* 
    * @description Returns the field label based on the input field API Name
    * @param fieldName API Name of the field to return
    * @param fieldMap map of the field describe results
    * @return string 
    */
    
    global class Requests {
        @InvocableVariable 
        global List<FlowAnalysis> inputCollection;

        @InvocableVariable 
        global FlowAnalysis inputRecord;

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
