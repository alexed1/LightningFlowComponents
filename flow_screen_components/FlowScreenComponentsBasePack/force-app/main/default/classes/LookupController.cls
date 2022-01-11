public with sharing class LookupController {
    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled(Cacheable=true)
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds) {
        String apiSObjectName = '';
        String defaulticon = 'standard:apex';
        List<String> sObjectDetailsList = new List<String>();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        
        Map<String, String> labelMap = new Map<String, String>();
        List<Schema.DescribeFieldResult> fieldResult = new List<Schema.DescribeFieldResult>();
        try {
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            
            for(String key : schemaMap.keySet()){
                labelMap.put(schemaMap.get(key).getDescribe().getLabel().toLowerCase(), String.valueOf(schemaMap.get(key)));
            }

            for(String key : labelMap.keySet()){
                if (key.contains(searchTerm.toLowerCase())) {
                    apiSObjectName = labelMap.get(key);
                    Schema.SObjectType objectSchema = schemaMap.get(apiSObjectName);
                    if (key.startsWith(searchTerm.toLowerCase())){
                        results.add(
                                    new LookupSearchResult(
                                        apiSObjectName,
                                        apiSObjectName,
                                        defaulticon,
                                        apiSObjectName,
                                        apiSObjectName
                                    )
                        );
                    }
                }
            }
        } catch (Exception e){
            System.debug(e);
            return null;
        }
        results.sort();

        return results;
    }

}