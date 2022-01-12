public with sharing class ParseFilterJSONToApexObject {
    
    public static List<FilterObjectRepresentation> parseStringToApexObj(String quickRecordFilter) {
        List<FilterObjectRepresentation> result = new List<FilterObjectRepresentation>();

        if (quickRecordFilter != null){
            result = (List<FilterObjectRepresentation>)System.JSON.deserialize(quickRecordFilter, List<FilterObjectRepresentation>.class);
            for(FilterObjectRepresentation qwe : result){
            }
            return result;
        }
        return result;
    }
}