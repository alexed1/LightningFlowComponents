@JsonAccess(serializable='always' deserializable='always')
global with sharing class FormulaEvaluator {

    global static String parseFormula(String formula, String context) {
        List<ContextWrapper> contextResult = (List<ContextWrapper>) JSON.deserialize(context, List<ContextWrapper>.class);
        Map<String, String> mapParameters = new Map<String, String>();

        for (ContextWrapper cont : contextResult) {
            if (!String.isEmpty(cont.value) && cont.name == '$Record') {
                //TODO: replace Schema.getGlobalDescribe() code with recordId.getSObjectType();
                String keyPrefix = cont.value.substring(0, 3);
                for (Schema.SObjectType obj : Schema.getGlobalDescribe().Values()) {
                    String prefix = obj.getDescribe().getKeyPrefix();
                    if (prefix == keyPrefix && prefix.indexOf(keyPrefix) != -1) {
                        String objectAPIName = obj.getDescribe().getName();
                        formula = formula.replaceAll('[$]Record', '\\$' + objectAPIName);
                        formula = formula.replaceAll('[!]Record', '\\!' + objectAPIName);
                        cont.name = objectAPIName;
                        mapParameters.put(cont.name, cont.value);
                        break;
                    }
                }
            } else if (!String.isEmpty(cont.value)) {
                formula = formula.replaceAll(cont.name, cont.value);
            }
        }

        Pattern mPattern = pattern.compile('(?<!")[$!{]{1,2}[A-z_.]*[}]{0,}');
        Matcher mMatcher = mPattern.matcher(formula);
        List<String> variables = new List<String>();

        while (mMatcher.find()) {
            variables.add(mMatcher.group(0));
        }

        Map<String, Set<String>> objectWithFields = new Map<String, Set<String>>();

        for (String variable : variables) {
            List<String> splitedValue = variable.replace('$', '').replace('{!', '').replace('}', '').split('[.]', 2);
            String contectVariableName = splitedValue[0];

            if (splitedValue.size() > 1) {
                if (objectWithFields.containsKey(contectVariableName)) {
                    Set<String> fields = objectWithFields.get(contectVariableName);
                    fields.add(splitedValue[1]);
                    objectWithFields.put(contectVariableName, fields);
                } else {
                    Set<String> fields = new Set<String>();
                    fields.add(splitedValue[1]);
                    objectWithFields.put(contectVariableName, fields);
                }
            }
        }

        if (objectWithFields.containsKey('User')) {
            formula = updateFormulaFields('User', UserInfo.getUserId(), formula, objectWithFields.get('User'));
        }

        if (objectWithFields.containsKey('Organization')) {
            formula = updateFormulaFields('Organization', UserInfo.getOrganizationId(), formula, objectWithFields.get('Organization'));
        }

        if (objectWithFields.containsKey('Profile')) {
            formula = updateFormulaFields('Profile', UserInfo.getProfileId(), formula, objectWithFields.get('Profile'));
        }
        if (objectWithFields.containsKey('Setup')) {
            Set<String> dataSet = objectWithFields.get('Setup');
            Map<String, Set<String>> objectAndField = new Map<String, Set<String>>();
            for (String variable : dataSet) {
                List<String> data = variable.split('[.]', 2);
                String objectName = data[0];
                if (objectAndField.containsKey(objectName)) {
                    Set<String> fields = objectAndField.get(objectName);
                    fields.add(data[1]);
                    objectAndField.put(objectName, fields);
                } else {
                    Set<String> fields = new Set<String>();
                    fields.add(data[1]);
                    objectAndField.put(objectName, fields);
                }
            }

            for (String objectName : objectAndField.keySet()) {
                formula = updateFormulaFields(objectName, '', formula, objectAndField.get(objectName));
            }
        }

        for (String contextVariableName : mapParameters.keySet()) {
            if (objectWithFields.containsKey(contextVariableName)) {
                formula = updateFormulaFields(contextVariableName, mapParameters.get(contextVariableName), formula, objectWithFields.get(contextVariableName));
            }
        }

        Set<String> resultTypes = new Set<String>{
                'BOOLEAN', 'NUMBER', 'DATETIME', 'DATE', 'STRING'
        };

        for (String resultType : resultTypes) {
            String result = evaluateFormula(formula, resultType);
            if (!String.isEmpty(result)) {
                return result;
            }
        }

        formula = formula.replaceAll('["]', '');
        mPattern = pattern.compile('[A-z0-9 ]{1,}');
        mMatcher = mPattern.matcher(formula);

        while (mMatcher.find()) {
            String item = '"' + mMatcher.group(0).trim() + '"';
            formula = formula.replaceFirst(mMatcher.group(0), item);
        }
        return evaluateFormula(formula, 'STRING');

    }

    global static String updateFormulaFields(String objectName, String objectId, String formula, Set<String> fields) {
        Map<String, Schema.DisplayType> fieldNameToType = getFieldTypes(objectName, fields);

        String queryString = 'SELECT ';

        for (String field : fields) {
            queryString = queryString + field + ', ';
        }

        queryString = queryString.removeEnd(', ');

        if (String.isEmpty(objectId)) {
            queryString = queryString + ' FROM ' + objectName + ' LIMIT 1';
        } else {
            queryString = queryString + ' FROM ' + objectName + ' WHERE Id =\'' + objectId + '\' LIMIT 1';
        }

        List<sObject> objectInfo = Database.query(queryString);

        if (objectInfo.size() > 0) {
            for (String field : fields) {
                String replaceValue = '(?<!")[$!{]{1,2}';
                if (String.isEmpty(objectId)) {
                    replaceValue = replaceValue + 'Setup.' + objectName + '.' + field + '[}]{0,}';
                } else {
                    replaceValue = replaceValue + objectName + '.' + field + '[}]{0,}';
                }

                formula = formula.replaceAll(replaceValue, handleFieldByType(String.valueOf(objectInfo[0].get(field)), fieldNameToType.get(field)));
            }
        }
        return formula;
    }

    private static String handleFieldByType(String fieldValue, Schema.DisplayType fieldType) {
        Set<Schema.DisplayType> enquoteTypes = new Set<DisplayType>{
                Schema.DisplayType.STRING,
                Schema.DisplayType.ID,
                Schema.DisplayType.STRING,
                Schema.DisplayType.PICKLIST,
                Schema.DisplayType.EMAIL,
                Schema.DisplayType.PHONE,
                Schema.DisplayType.URL,
                Schema.DisplayType.TIME,
                Schema.DisplayType.MULTIPICKLIST
        };

        Set<Schema.DisplayType> dateTypes = new Set<DisplayType>{
                Schema.DisplayType.DATE, Schema.DisplayType.DATETIME
        };

        if (enquoteTypes.contains(fieldType)) {
            return '"' + fieldValue + '"';
        } else if (dateTypes.contains(fieldType)) {
            Datetime dt = Datetime.valueOf(fieldValue);
            return 'DATETIME(' + dt.year() + ',' + dt.month() + ',' + dt.day() + ',' + dt.hour() + ',' + dt.minute() + ',' + dt.second() + ')';
        }

        return fieldValue;
    }
    private static Map<String, Schema.DisplayType> getFieldTypes(String objectName, Set<String> fieldNames) {
        SObjectType r = ((SObject) (Type.forName('Schema.' + objectName).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        Map<String, Schema.DisplayType> fieldNameToType = new Map<String, Schema.DisplayType>();
        for (String fieldName : fieldNames) {
            if (d.fields.getMap().containsKey(fieldName)) {
                fieldNameToType.put(fieldName, d.fields.getMap().get(fieldName).getDescribe().getType());
            }
        }
        return fieldNameToType;
    }

    global static String evaluateFormula(String formula, String resultType) {
        Pattern mPattern = pattern.compile('[0-9.]{3,}');
        Matcher mMatcher = mPattern.matcher(formula);
        //TODO: add scale as an input param for Numeric values
        Integer scale = 0;

        while (mMatcher.find()) {
            List<String> items = mMatcher.group(0).split('[.]');
            if (items.size() > 1 && items[1].length() > scale) {
                scale = items[1].length();
            }
        }

        RegExps.ParserContext parserContext = evaluate(formula, resultType, scale);
        return String.valueOf(parserContext.result);
    }

    global static RegExps.ParserContext evaluate(String formula, String outputType, Integer scale) {

        RegExps.ParserContext context = new RegExps.ParserContext(formula, outputType, scale);

        try {

            String outputFormula = null;
            Boolean parenthesisAdded = false;
            Integer iteration = 0;

            replaceExpressionValues(context);

            while (true) {
                if (outputFormula == context.outputString) {
                    if (parenthesisAdded) {
                        break;
                    } else {
                        parenthesisAdded = true;
                        RegExps.wrapParentesis(context, 'NUMBER');
                    }
                }

                outputFormula = context.outputString;

                RegExps.evaluateMathExpressions(context);
                if (outputFormula != context.outputString) {
                    RegExps.clearParentesis(context, 'NUMBER');
                    parenthesisAdded = false;
                    continue;
                }

                RegExps.evaluateMathFunctions(context);
                if (outputFormula != context.outputString) {
                    parenthesisAdded = false;
                    continue;
                }

                RegExps.evaluateStringOperations(context);
                if (outputFormula != context.outputString) {
                    parenthesisAdded = false;
                    continue;
                }

                RegExps.evaluateStringFunctions(context);
                if (outputFormula != context.outputString) {
                    parenthesisAdded = false;
                    continue;
                }

                RegExps.evaluateCompareExpressions(context);
                if (outputFormula != context.outputString) {
                    parenthesisAdded = false;
                    continue;
                }

                RegExps.evaluateBooleanExpressions(context);
                if (outputFormula != context.outputString) {
                    parenthesisAdded = false;
                    continue;
                }


                RegExps.evaluateFlowExpressions(context);
                if (outputFormula != context.outputString) {
                    parenthesisAdded = false;
                    continue;
                }

                RegExps.evaluateFlowExpressionsCASE(context);
                if (outputFormula != context.outputString) {
                    parenthesisAdded = false;
                    continue;
                }

                RegExps.evaluateTypeConversionFunctions(context);
                if (outputFormula != context.outputString) {
                    parenthesisAdded = false;
                    continue;
                }

                RegExps.evaluateDateTimeFunctions(context);

                if (outputFormula != context.outputString) {
                    parenthesisAdded = false;
                    continue;
                }

                RegExps.clearParentesis(context, 'ALL');
            }
            context.result = RegExps.evaluateResult(context);

        } catch (Exception e) {
            context.isError = true;
            context.stackTrace = e.getStackTraceString() + ' ' + e.getMEssage();
            context.errorMessage = e.getMessage();
            System.debug(context);
        }
        return context;
    }

    global static void replaceExpressionValues(RegExps.ParserContext context) {

        context.outputString = ' ' + context.outputString + ' ';
        context.outputString = context.outputString.replaceAll(RegExps.EXP_MULTILINE_COMMENT, '');

        Pattern myPattern = pattern.compile(RegExps.EXP_STRING);
        Matcher m = myPattern.matcher(context.outputString);
        Set<String> stringList = new Set<String>();

        while (m.find()) {
            stringList.add(m.group(0));
        }

        for (String str : stringList) {
            context.outputString = context.outputString.replace(str, ' _S' + context.referencesString.size() + 'S_ ');
            context.referencesString.put('_S' + context.referencesString.size() + 'S_', str.substring(1, str.length() - 1));
        }

        context.outputString = context.outputString.replaceAll('\\s*\\(\\s*', ' ( ');
        context.outputString = context.outputString.replaceAll('\\s*\\)\\s*', ' ) ');
        context.outputString = context.outputString.replaceAll('\\s*,\\s*', ' , ');
        context.outputString = context.outputString.replaceAll('\\s*\\*\\s*', ' * ');
        context.outputString = context.outputString.replaceAll('\\s*/\\s*', ' / ');
        context.outputString = context.outputString.replaceAll('\\s*!=\\s*', ' <> ');
        context.outputString = context.outputString.replaceAll('\\s*!', ' ! ');
        context.outputString = context.outputString.replaceAll('\\s*&&\\s*', ' && ');
        context.outputString = context.outputString.replaceAll('\\s*\\|\\|\\s*', ' || ');
        context.outputString = context.outputString.replaceAll('\\s*\\^\\^\\s*', ' ^^ ');

        for (String op : RegExps.COMPARE_OPERATORS.keyset()) {
            context.outputString = context.outputString.replaceAll('\\s*' + op + '\\s*', ' ' + RegExps.COMPARE_OPERATORS.get(op) + ' ');
        }

        List<String> vList = new List<String>();
        myPattern = pattern.compile(RegExps.EXP_DATETIME);
        m = myPattern.matcher(context.outputString);

        while (m.find()) {
            vList.add(m.group(0));
        }

        for (String str : vList) {

            DateTime vdt = null;

            if (!Pattern.matches(RegExps.EXP_DATETIME, str)) {
                throw new ExpressionParsingException('Invalid date/time value "' + str + '". Expected: YYYY-MM-DDTHH:MM:SS');
            }

            List<String> datePart = str.split('T')[0].split('\\-');
            List<String> timePart = new List<String>{
                    '0', '0', '0'
            };

            if (str.split('T').size() > 1) {
                timePart = str.split('T')[1].split(':');
            }

            vdt = DateTime.newInstanceGmt(Integer.valueOf(datePart[0]), Integer.valueOf(datePart[1]), Integer.valueOf(datePart[2]),
                    Integer.valueOf(timePart[0]), Integer.valueOf(timePart[1]), Integer.valueOf(timePart[2]));

            context.replace(str, vdt);
        }

        context.outputString = context.outputString.replaceAll('\\s*\\+\\s*', ' + ');
        context.outputString = context.outputString.replaceAll('\\s*\\-\\s*', ' - ');
        context.outputString = context.outputString.replaceAll('\\s*\\+\\s*', ' + ');
        context.outputString = context.outputString.replaceAll('\\s*\\-\\s*', ' - ');
        context.outputString = context.outputString.toUpperCase();

        Map<Integer, List<String>> fieldNamesByLength = new Map<Integer, List<String>>();

        for (String k : context.fieldValues.keyset()) {
            List<String> fls = fieldNamesByLength.get(k.length());

            if (fls == null) {
                fls = new List<String>();
                fieldNamesByLength.put(k.length(), fls);
            }

            fls.add(k);
        }

        List<List<String>> sortedKeys = fieldNamesByLength.values();

        for (Integer i = sortedKeys.size() - 1; i >= 0; i--) {
            List<String> fls = sortedKeys[i];

            for (String k : fls) {

                Object vObj = context.fieldValues.get(k);
                String fieldType = context.fieldTypes.get(k);

                if (fieldType == 'BOOLEAN') {
                    if (vObj == null) {
                        vObj = false;
                    }
                    context.replace(k, (Boolean) vObj);
                } else if (fieldType == 'INTEGER' || fieldType == 'DOUBLE') {
                    if (vObj == null) {
                        vObj = 0;
                    }
                    context.replace(k, (Decimal) vObj);
                } else if (fieldType == 'STRING' || fieldType == 'ID') {
                    if (vObj == null) {
                        vObj = '';
                    }
                    context.replace(k, (String) vObj);
                } else if (fieldType == 'DATE' || fieldType == 'DATETIME') {
                    context.replace(k, (DateTime) vObj);
                }
            }
        }

        String EXP_VALUES_NO_STRING = '(' + RegExps.EXP_NULL + '|' + RegExps.EXP_NUMBER_NEGATIVE_FUNCTION + '|' + RegExps.EXP_NUMBER + '|' + RegExps.EXP_BOOLEAN + ')';

        vList = new List<String>();
        myPattern = pattern.compile(EXP_VALUES_NO_STRING);
        m = myPattern.matcher(context.outputString);

        while (m.find()) {
            vList.add(m.group(0));
        }

        for (String str : vList) {
            if (Pattern.matches(RegExps.EXP_NULL, str)) {
                context.replace(str);
            } else if (Pattern.matches(RegExps.EXP_NUMBER_NEGATIVE, str)) {
                context.replace(str, Decimal.valueOf(str.replace(' ', '')));
            } else if (Pattern.matches(RegExps.EXP_NUMBER, str)) {
                context.replace(str, Decimal.valueOf(str));
            } else if (Pattern.matches(RegExps.EXP_BOOLEAN, str)) {
                context.replace(str, Boolean.valueOf(str));
            }
        }

        myPattern = pattern.compile('(\\$PI|\\$E|\\$TODAY|\\$NOW|\\$RANDOM)');
        m = myPattern.matcher(context.outputString);

        while (m.find()) {
            if (m.group(0) == '$PI') {
                Decimal pi = Math.PI;
                context.replace(m.group(0), pi);
            } else if (m.group(0) == '$E') {
                Decimal e = Math.E;
                context.replace(m.group(0), e);
            } else if (m.group(0) == '$RANDOM') {
                Decimal rnd = Math.random();
                rnd *= rnd;
                context.replace(m.group(0), rnd);
            } else if (m.group(0) == '$TODAY') {
                DateTime today = System.today();
                context.replace(m.group(0), today);
            } else if (m.group(0) == '$NOW') {
                DateTime now = System.now();
                context.replace(m.group(0), now);
            }
        }

        context.outputString = context.outputString.replaceAll('\\s+', ' ');
    }
    
    @JsonAccess(serializable='always' deserializable='always')
    global class ContextWrapper {
        global String name;
        global String value;

        global ContextWrapper(String name, String value) {
            this.name = name;
            this.value = value;
        }
    }

    global class ExpressionParsingException extends Exception {
    }
}
