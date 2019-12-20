/* Apex Controller for Lightning Web Component for Flow Screens:    flowPickerFSC
                                                                    FlowListController.cls

Allows the selection of a Flow

12/19/19 - Eric Smith - Added labels for the configuration attributes,
                        added help text for the configuration attributes,
                        added support for changing the default placeholder text,  
                        specifying a search string to filter the list of flows,
                        displaying the list in alphabetical order by Flow Label,
                        and specifying the width of the component

*/

global with sharing class FlowListController {

    @AuraEnabled(cacheable=true)
    public static List<FlowDefinitionView> getFlowNamesApex(String filtersString) {

        String queryString = 'SELECT Id, ApiName, Label FROM FlowDefinitionView ';

        if (filtersString != null) {
            Map<String, List<String>> filters = (Map<String, List<String>>) JSON.deserialize(filtersString, Map<String, List<String>>.class);
            if (!filters.isEmpty()) {
                queryString += ' WHERE ';
                Boolean isFirst = true;
                for (String fieldName : filters.keySet()) {
                    List<String> values = filters.get(fieldName);
                    String negativeClause = fieldName.contains('!') ? (values.size() > 1 ? 'NOT ' : '!') : '';
                    String operator = fieldName.contains('Label') ? 'LIKE ' : (values.size() == 1 ? '= ' : 'IN ');  // Updated to Handle Search String
                    String value = values.size() == 1 ? values[0] : '(\'' + String.join(values, '\',\'') + '\')';
                    queryString += (!isFirst ? ' AND ' : ' ') + fieldName.replace('!', '') + ' ' + negativeClause + operator + value;
                    isFirst = false;
                }
            }
        }
        // Sort the results by the FLow Label
        queryString += 'ORDER BY Label ASC';

        return (List<FlowDefinitionView>) Database.query(queryString);
    }
}
