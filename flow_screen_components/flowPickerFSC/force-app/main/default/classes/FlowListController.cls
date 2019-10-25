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
                    String operator = values.size() == 1 ? '= ' : 'IN ';
                    String value = values.size() == 1 ? values[0] : '(\'' + String.join(values, '\',\'') + '\')';
                    queryString += (!isFirst ? ' AND ' : ' ') + fieldName.replace('!', '') + ' ' + negativeClause + operator + value;
                    isFirst = false;
                }
            }
        }

        return (List<FlowDefinitionView>) Database.query(queryString);
    }
}