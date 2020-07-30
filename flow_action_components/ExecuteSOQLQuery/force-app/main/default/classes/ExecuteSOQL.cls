public without sharing class ExecuteSOQL {
    private static Set<String> DATE_LITERAL_FORMATS = new Set<String>{'YESTERDAY','TODAY','TOMORROW','LAST_WEEK','THIS_WEEK','NEXT_WEEK','LAST_MONTH','THIS_MONTH','NEXT_MONTH','LAST_90_DAYS','NEXT_90_DAYS','LAST_N_DAYS','NEXT_N_DAYS','NEXT_N_WEEKS','LAST_N_WEEKS','NEXT_N_MONTHS','LAST_N_MONTHS','THIS_QUARTER','LAST_QUARTER','NEXT_QUARTER','NEXT_N_QUARTERS','LAST_N_QUARTERS','THIS_YEAR','LAST_YEAR','NEXT_YEAR','NEXT_N_YEARS','LAST_N_YEARS','THIS_FISCAL_QUARTER','LAST_FISCAL_QUARTER','NEXT_FISCAL_QUARTER','NEXT_N_FISCAL_QUARTERS','LAST_N_FISCAL_QUARTERS','THIS_FISCAL_YEAR','LAST_FISCAL_YEAR','NEXT_FISCAL_YEAR','NEXT_N_FISCAL_YEARS','LAST_N_FISCAL_YEARS'};
    public class ExecuteSOQLException extends Exception {}
    // Legacy entry point
    public static List <Results> getEligibleProducts(List<Requests> requestList) {
        return execute(requestList);
    }
    @InvocableMethod(label='Execute SOQL Query' description='Executes an SOQL query and returns a list of sObjects of the specified type' category='Util')
    public static List <Results> execute(List<Requests> requestList) {
        List<Results> responseWrapper = new List<Results>();
        for(Requests curRequest : requestList) {
            Results results = new Results();
            String soqlQuery = curRequest.soqlQuery;
            soqlQuery = replaceWithFormattedValues(soqlQuery);
            List<SObject> queryResult = Database.query(soqlQuery);
            if (queryResult.size() > 0) {
                results.sObjects = queryResult;
            }
            responseWrapper.add(results);
        }
        return responseWrapper;
    }
    public static String replaceWithFormattedValues(String soqlQuery) {
        String endingClause = '';
        soqlQuery = soqlQuery.replaceAll('\r\n|\n|\r|\t',' ');
        List<String> clausesToRemove = new List<String>{' order by ', ' limit ', ' group by ', ' offset ' };
        for (String curClause : clausesToRemove) {
            if (soqlQuery.containsIgnoreCase(curClause)) {
                endingClause = curClause + soqlQuery.toLowerCase().substringAfter(curClause.toLowerCase());
                soqlQuery = soqlQuery.removeEndIgnoreCase(endingClause);
                break;
            }
        }
        if (soqlQuery != null && soqlQuery.containsIgnoreCase(' from ') && soqlQuery.containsIgnoreCase('select ') && soqlQuery.containsIgnoreCase(' where ')) {
            Pattern mPattern = pattern.compile('(?i)(?<=from )(.*)(?= where .+(\\(select .+\\)))');
            Matcher mMatcher = mPattern.matcher(soqlQuery);
            Boolean found = mMatcher.find();
            String sObjectType = '';
            if (found) {
                sObjectType = mMatcher.group(0);
                // Recurse through sub-queries
                Pattern subPattern = pattern.compile('(?i)\\(select .+\\)');
                Matcher subMatcher = subPattern.matcher(soqlQuery);
                while (subMatcher.find()) {
                    String subQuery = subMatcher.group(0).removeStart('(').removeEnd(')');
                    String formattedSubQuery = replaceWithFormattedValues(subQuery);
                   	soqlQuery = soqlQuery.replace(subQuery, formattedSubQuery);
                }
            } else {
                mPattern = pattern.compile('(?i)(?<=from )(.*)(?= where)');            
                mMatcher = mPattern.matcher(soqlQuery);
                if (mMatcher.find()) {
                    sObjectType = mMatcher.group(0);
                    System.debug('Logs: match found: sobject: ' + sObjectType);
                } else {
                    throw new ExecuteSOQLException('Unable to parse query string: ' + soqlQuery);
                }
            }
            Map<String, String> fieldNameValueMap = new Map<String, String>();
            List<String> fieldNames = new List<String>();
            mPattern = pattern.compile('(?i)(?<=where )(.*)');
            mMatcher = mPattern.matcher(soqlQuery);
            while (mMatcher.find()) {
                String statement = mMatcher.group(0);
                                    System.debug('Logs: match found: fields: ' + statement);

                String whereClause = statement.replaceAll('(?i)\\(select .+\\)', '(SUBQUERY)');
                fieldNames.addAll(whereClause.split('\\(|\\)|>=|<=|!=|=|>|<| in\\(| not in\\(| like | in:| or| and'));
            }
            if (!fieldNames.isEmpty()) {
               for (Integer i = fieldNames.size() - 1; i >= 1; i -= 2) {
                    fieldNames[i - 1] = fieldNames[i - 1].replaceAll(' ', '');
                    fieldNameValueMap.put(fieldNames[i - 1], fieldNames.remove(i));
                }
            }
            Map<String, String> fieldTypes = getFieldTypes(sObjectType, fieldNames);
            soqlQuery = putFormattedValues(soqlQuery, fieldNameValueMap, fieldTypes);
        }
        return soqlQuery + endingClause;
    }
    public static Map<String, String> getFieldTypes(String sObjectTypeName, List<String> fieldNames) {
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(sObjectTypeName.replace(' ', ''));
        if (objectType != null) {
            Map<String, String> resultMap = new Map<String, String>();
        	DescribeSObjectResult d = objectType.getDescribe();
        	Map<String, SObjectField> fieldMap = d.fields.getMap();
        	for (String fieldName : fieldNames) {
            	if (fieldMap.containsKey(fieldName)) {
                	resultMap.put(fieldName, fieldMap.get(fieldName).getDescribe().getType().name());
            	}
        	}
            return resultMap; 
        } else {
            throw new ExecuteSOQLException('Unable to get sObject Type for name: '+ sObjectTypeName);
        }
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
    @TestVisible
    private static String getFormattedValue(String fieldValue, String fieldType) {		
        if (fieldType == 'DATETIME' || fieldType == 'DATE') {
            //Datetime is already formatted
            for (String literal: DATE_LITERAL_FORMATS) {
                if (fieldValue.containsIgnoreCase(literal)) {
                    return fieldValue;
                }
            }
            if (fieldValue.containsIgnoreCase('t') && fieldValue.containsIgnoreCase('z') && fieldValue.indexOfIgnoreCase('t') == 11) {
                return fieldValue;
            }
            Map<String, String> localMonthNumbers = getLocalMonthNumbers();
            Boolean isDate = false;
            for (String monthName : localMonthNumbers.keySet()) {
                if (fieldValue.containsIgnoreCase(monthName)) {
                    fieldValue = fieldValue.replaceAll('(?i)' + monthName, localMonthNumbers.get(monthName) + ',');
                    isDate = true;
                }
            }
            if (isDate) {
                fieldValue = fieldValue.replaceAll(', ', '/');
                fieldValue = fieldValue.replaceAll('/ ', '/');
                fieldValue += ', 12:00 am';
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
            String month = String.valueOf(i);
            if (month.length() == 1) {
                month = '0' + month;
            }
            resultMap.put(dt.format('MMMM'), month);
            dt = dt.addMonths(1);
        }
        return resultMap;
    }
    public class Requests {
        @InvocableVariable(description='Valid SOQL query string' required=true)
        public String soqlQuery;
    }
    public class Results {
        @InvocableVariable(description='List of sObjects returned from query. If no objects are returned this variable will be null.')
        public List<SObject> sObjects;
    }
}
