public with sharing class CollectionProcessorsUtils {

    private static final String DEFAULT_DATE_TIME_FORMAT = 'yyyy-MM-dd HH:mm:ss';
    private static final String SOQL_DATE_TIME_FORMAT = 'yyyy-MM-dd\'T\'HH:mm:ss\'Z\'';

    public static Map<String, String> getFieldTypes(SObject acc, List<String> fieldNames) {

        Map<String, String> resultMap = new Map<String, String>();
        DescribeSObjectResult d = acc.getSObjectType().getDescribe();
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

    public static String getFormattedValue(String fieldValue, String fieldType) {
        return getFormattedValue(fieldValue, fieldType, DEFAULT_DATE_TIME_FORMAT);
    }

    public static String getFormattedValue(String fieldValue, String fieldType, String format) {

        if (fieldType == 'datetime' || fieldType == 'date') {
            //Datetime is already formatted
            if (fieldValue.contains('t') && fieldValue.contains('z') && fieldValue.indexOf('t') == 11) {
                return fieldValue;
            }
            Map<String, String> localMonthNumbers = getLocalMonthNumbers();

            Boolean isDate = false;
            for (String monthName : localMonthNumbers.keySet()) {
                if (fieldValue.contains(monthName)) {
                    fieldValue = fieldValue.replaceAll(monthName, localMonthNumbers.get(monthName) + ',');
                    isDate = true;
                }
            }

            if (isDate) {
                fieldValue = fieldValue.replaceAll(', ', '/');
                fieldValue = fieldValue.replaceAll('/ ', '/');
                fieldValue += ', 00:00 AM';
            }
            if (format != null) {
                return Datetime.parse(fieldValue).format(format);
            } else {
                Datetime.parse(fieldValue).format(DEFAULT_DATE_TIME_FORMAT);
            }

        }

        return fieldValue;
    }

    //Workaround to get local month name to month number map
    private static Map<String, String> getLocalMonthNumbers() {
        Datetime dt = Datetime.newInstance(2020, 1, 1);

        Map<String, String> resultMap = new Map<String, String>();
        for (Integer i = 1; i < 12; i++) {
            resultMap.put(dt.format('MMMM').toLowerCase(), String.valueOf(i));
            dt = dt.addMonths(1);
        }
        return resultMap;
    }

}