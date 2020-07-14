public with sharing class ObjectLookupController {

    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled(Cacheable=true)
    public static List<LookupSearchResult> search(String objectName, String displayWhichField, String outputWhichValue, String searchTerm, List<String> objectIdList, Integer newRecordCounter) {
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        Set<String> fieldsToQuerySet = new Set<String>{
                displayWhichField, outputWhichValue
        };
        String fieldsToQuery = String.join(new List<String>(fieldsToQuerySet), ',');
        if ((objectName != null && displayWhichField != null && displayWhichField != null && outputWhichValue != null && searchTerm != null) || objectIdList != null) {
            String myQuery;
            if (objectIdList == null || objectIdList.size() == 0) {
                myQuery = 'SELECT ' + String.escapeSingleQuotes(fieldsToQuery) +
                        ' FROM ' + String.escapeSingleQuotes(objectName) +
                        ' WHERE ' + String.escapeSingleQuotes(displayWhichField) + ' LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\' LIMIT ' + MAX_RESULTS;
            } else {
                myQuery = 'SELECT ' + String.escapeSingleQuotes(fieldsToQuery) +
                        ' FROM ' + String.escapeSingleQuotes(objectName) +
                        ' WHERE Id IN :objectIdList';
            }
            List<SObject> allRecords = Database.query(myQuery);
            for (SObject curObject : allRecords) {
                results.add(new LookupSearchResult((String) curObject.get(outputWhichValue), objectName, 'standard:' + (objectName.contains('__') ? 'default' : objectName.toLowerCase()), (String) curObject.get(displayWhichField), ''));
            }
        }

        return results;
    }
}
