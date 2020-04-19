public with sharing class ExecuteSOQL {
    @InvocableMethod
    public static List <Results> getEligibleProducts(List<Requests> requestList) {

        Results results = new Results();
        List<Results> responseWrapper = new List<Results>();
        String soqlQuery = requestList[0].soqlQuery;
        soqlQuery = replaceWithFormattedValues(soqlQuery);
        results.sObjects = Database.query(soqlQuery);


        responseWrapper.add(results);
        return responseWrapper;
    }

    public static String replaceWithFormattedValues(String soqlQuery) {
        soqlQuery = soqlQuery.toLowerCase();
        List<String> clausesToRemove = new List<String>{
                ' order by ', ' limit '
        };
        for (String curClause : clausesToRemove) {
            if (soqlQuery.contains(curClause)) {
                soqlQuery = soqlQuery.substring(0, soqlQuery.indexOf(curClause));
            }
        }

        if (soqlQuery != null && soqlQuery.contains(' from ') && soqlQuery.contains('select ') && soqlQuery.contains(' where ')) {
            Pattern mPattern = pattern.compile('(?<=from )(.*)(?= where)');
            Matcher mMatcher = mPattern.matcher(soqlQuery);
            mMatcher.find();
            String sObjectType = mMatcher.group(0);
            Map<String, String> fieldNameValueMap = new Map<String, String>();
            List<String> fieldNames = new List<String>();

            mPattern = pattern.compile('(?<=where )(.*)');
            mMatcher = mPattern.matcher(soqlQuery);
            while (mMatcher.find()) {
                String whereClause = mMatcher.group(0);
                fieldNames.addAll(whereClause.split('\\(|\\)|>=|<=|!=|=|>|<| in\\(| like | in:| or| and'));
            }

            if (!fieldNames.isEmpty()) {
                for (Integer i = fieldNames.size() - 1; i >= 0; i -= 2) {
                    fieldNames[i - 1] = fieldNames[i - 1].replaceAll(' ', '');
                    fieldNameValueMap.put(fieldNames[i - 1], fieldNames.remove(i));
                }
            }

            Map<String, String> fieldTypes = getFieldTypes(sObjectType, fieldNames);
            soqlQuery = putFormattedValues(soqlQuery, fieldNameValueMap, fieldTypes);
        }

        return soqlQuery;
    }

    public static Map<String, String> getFieldTypes(String sObjectType, List<String> fieldNames) {
        SObjectType r = ((SObject) (Type.forName('Schema.' + sObjectType).newInstance())).getSObjectType();
        Map<String, String> resultMap = new Map<String, String>();
        DescribeSObjectResult d = r.getDescribe();
        Map<String, SObjectField> fieldMap = d.fields.getMap();

        for (String fieldName : fieldNames) {
            if (fieldMap.containsKey(fieldName)) {
                resultMap.put(fieldName, fieldMap.get(fieldName).getDescribe().getType().name());
            }
        }

        return resultMap;
    }

    public static String putFormattedValues(String query, Map<String, String> fieldNameValueMap, Map<String, String> fieldTypes) {

        Set<String> typesWithSpecialFormatting = new Set<String>{
                'DATETIME', 'DATE'
        };
        for (String fieldName : fieldTypes.keySet()) {
            if (typesWithSpecialFormatting.contains(fieldTypes.get(fieldName))) {
                String formattedValue = getFormattedValue(fieldNameValueMap.get(fieldName), fieldTypes.get(fieldName));
                query = query.replaceAll(fieldNameValueMap.get(fieldName).escapeJava(), formattedValue);
            }
        }
        return query;

    }
    private static String getFormattedValue(String fieldValue, String fieldType) {
        if (fieldType == 'DATETIME' || fieldType == 'DATE') {
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

            return Datetime.parse(fieldValue).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
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

    public class Requests {
        @InvocableVariable(required=true)
        public String soqlQuery;
    }

    public class Results {
        public Results() {
            sObjects = new List<SObject>();
        }
        @InvocableVariable
        public List<SObject> sObjects;

    }
}