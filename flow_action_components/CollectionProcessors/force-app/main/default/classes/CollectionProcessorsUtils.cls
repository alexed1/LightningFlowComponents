public with sharing class CollectionProcessorsUtils {
    public static Map<String, String> getFieldTypes(SObject acc, List<String> fieldNames) {

        Schema.SObjectType r = acc.Id.getSObjectType();
        Map<String, String> resultMap = new Map<String, String>();
        DescribeSObjectResult d = r.getDescribe();
        for (String fieldName : fieldNames) {
           resultMap.put(fieldName, d.fields.getMap().get(fieldName).getDescribe().getType().name());
        }

        return resultMap;
    }

    public static String replaceConstants(String sourceString) {
        final Map<String, String> constantMap = new Map<String, String>{
                '\\$GlobalConstant.True' => '"true"',
                '\\$GlobalConstant.False' => '"false"'
        };

        String resultString = sourceString;
        for (String curKey : constantMap.keySet()) {
            resultString = resultString.replaceAll(curKey, constantMap.get(curKey));
        }

        return resultString;
    }
}