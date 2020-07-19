public with sharing class fbc_ExpressionBuilder {

    /*
    Known issues:
    1. Not stable work with some special characters (single/double quotes, backslash/slash); Verification regex: ['"\\\/|&^]
    2. Does not support custom conditions like (1 OR (2 AND 3))
     */
    @AuraEnabled
    public static String assembleFormulaString(String customLogic, String logicType, String expressionLines) {
        List<ExpressionLineWrapper> lines = (List<ExpressionLineWrapper>) JSON.deserialize(expressionLines, List<ExpressionLineWrapper>.class);

        String result = '';
        String resultEnd = '';

        if (logicType == 'AND' || logicType == 'OR') {
            customLogic = simpleFormulaConversion(new List<String>(), logicType, lines.size());
        }

        if (logicType == 'CUSTOM') {

            Map<String, String> items = new Map<String, String>();
            Integer index = 1;
            Boolean needRerun = true;

            while (needRerun) {

                Pattern mPattern = pattern.compile('\\([0-9A-z\\s]*\\)');
                Matcher mMatcher = mPattern.matcher(customLogic);
                needRerun = false;

                while (mMatcher.find()) {
                    needRerun = true;
                    items.put('F' + index, mMatcher.group(0));
                    customLogic = customLogic.replaceAll('\\(' + mMatcher.group(0) + '\\)', 'F' + index);
                    index = index + 1;
                }

            }

            customLogic = customLogic.replaceAll(' ', '');

            for (String key : items.keySet()) {

                String value = items.get(key).replaceAll('[\\(\\)\\s]', '').trim();

                if (value.indexOf('AND') > -1) {
                    List<String> formulaItems = value.split('AND');
                    items.put(key, simpleFormulaConversion(formulaItems, 'AND', formulaItems.size()));
                }

                if (value.indexOf('OR') > -1) {
                    List<String> formulaItems = value.split('OR');
                    items.put(key, simpleFormulaConversion(formulaItems, 'OR', formulaItems.size()));
                }

            }

            for (String key : items.keySet()) {
                String oldValue = items.get(key);
                Pattern mPattern = pattern.compile('F[0-9]{1,}');
                Matcher mMatcher = mPattern.matcher(oldValue);

                while (mMatcher.find()) {
                    String newValue = oldValue.replaceAll(mMatcher.group(0), items.get(mMatcher.group(0)));
                    items.put(key, newValue);
                }
            }

            if (customLogic.indexOf('AND') > -1) {
                List<String> formulaItems = customLogic.split('AND');
                customLogic = simpleFormulaConversion(formulaItems, 'AND', formulaItems.size());
            }

            if (customLogic.indexOf('OR') > -1) {
                List<String> formulaItems = customLogic.split('OR');
                customLogic = simpleFormulaConversion(formulaItems, 'OR', formulaItems.size());
            }

            Pattern mPattern = pattern.compile('F[0-9]{1,}');
            Matcher mMatcher = mPattern.matcher(customLogic);

            while (mMatcher.find()) {
                customLogic = customLogic.replaceAll(mMatcher.group(0), items.get(mMatcher.group(0)));
            }
        }

        Pattern mPattern = pattern.compile('[0-9]{1,}');
        Matcher mMatcher = mPattern.matcher(customLogic);
        Set<String> indexs = new Set<String>();

        while (mMatcher.find()) {
            indexs.add(mMatcher.group(0));
        }

        for (String ind : indexs) {
            customLogic = customLogic.replaceAll(ind, 'F' + ind);
        }

        Integer iterrationSize = lines.size();

        if (lines.size() > 9 && !String.isEmpty(lines[9].dataType) && !String.isEmpty(lines[9].parameter) && !String.isEmpty(lines[9].operator)) {
            customLogic = customLogic.replaceAll('(FF10)', convertExpressionLines(lines[9]));
            iterrationSize = iterrationSize - 1;
        }

        for (Integer i = 0; i < iterrationSize; i++) {
            Integer formulaIndex = i + 1;
            mPattern = pattern.compile('F[' + formulaIndex + ']{1,}');
            mMatcher = mPattern.matcher(customLogic);

            while (mMatcher.find()) {
                if (!String.isEmpty(lines[i].dataType) && !String.isEmpty(lines[i].parameter) && !String.isEmpty(lines[i].operator)) {
                    customLogic = customLogic.replaceAll(mMatcher.group(0), convertExpressionLines(lines[i]));
                }
            }
        }

        return customLogic;
    }
/*
Due to not stable formula disassembly for custom conditions we have excluded this option.
Currently expression builder accepts "AND" or "OR" logic only.
Steps to reproduce some of issues with custom logic:
1. In expression builder add 4 rows and set criterias in each of them, f.e. :
Account.Name contains 1
Account.Name contains 2
Account.Name contains 3
Account.Name contains 4
2. Set complex custom condition (f.e. : (1 AND 2) OR ((4 AND 3) AND (4 AND 2)))
Actual result:
Generated formula will not represent all conditions (missing  CONTAINS($Account.Name, TEXT("3")), extra letter "F" before third "CONTAINS") and will look like this:
OR(AND(CONTAINS($Account.Name, TEXT("1")), CONTAINS($Account.Name, TEXT("2"))), AND(FCONTAINS($Account.Name, TEXT("2")), AND(CONTAINS($Account.Name, TEXT("4")), CONTAINS($Account.Name, TEXT("2")))))
Expected result:
Formula represents all conditions and must look like this:
OR(AND(CONTAINS($Account.Name, TEXT("1")),CONTAINS($Account.Name, TEXT("2"))), AND(CONTAINS($Account.Name, TEXT("1")),CONTAINS($Account.Name, TEXT("2")),CONTAINS($Account.Name, TEXT("3")),CONTAINS($Account.Name, TEXT("4"))))
*/
    private static final String SPACE_SYMBOL = '__nbsp__';
    @AuraEnabled
    public static Map<String, Object> disassemblyFormulaString(String expression, String customVariableDelimiter) {

        //TODO: determine map of special characters and its replacements. Replace all of them here and do the backward operation in convertSetToExpressionLineWrapper
        expression = expression.replaceAll(' (?=[^"]*"[^"]*(?:"[^"]*"[^"]*)*$)', SPACE_SYMBOL);

        if (customVariableDelimiter != null) {
            expression = expression.replaceAll(customVariableDelimiter, '\\$');
        }

        Map<String, Object> result = new Map<String, Object>();

        if (String.isEmpty(expression)) {
            return result;
        }
//        expression = expression.replaceAll('[\\s]', '');
        expression = expression.replaceAll('\\s+(?=(?:[^\\\'"]*[\\\'"][^\\\'"]*[\\\'"])*[^\\\'"]*$)', '');
        String parentCondition = expression.indexOf('AND') == 0 ? ' AND ' : ' OR ';
        Boolean isSingleExpression = expression.indexOf('AND(') != 0 && expression.indexOf('OR(') != 0;
        Boolean isCustomLogic = expression.indexOf('AND(') != -1 && expression.indexOf('OR(') != -1;
//        Pattern mPattern = pattern.compile('[^ANDOR(][\\w-:!=<>.,"()$]{1,}');
        Pattern mPattern = pattern.compile('^(AND\\(|OR\\()[\\w-:!=<>. ,"()$]{1,}');
//        Pattern mPattern = pattern.compile('(?<=OR|AND\\().*');
        Matcher mMatcher = mPattern.matcher(expression);

        while (mMatcher.find()) {
            expression = mMatcher.group(0);
            if (!isSingleExpression) {
                expression.removeEnd(')');
            }
        }

        mPattern = pattern.compile('(LEFT|RIGHT)\\(\\$[\\w,.]{1,}\\)==[\\w()"]{1,}');
        mMatcher = mPattern.matcher(expression);

        while (mMatcher.find()) {
            List<String> values = mMatcher.group(0).split('==');
            values[0] = values[0].replaceAll('LEFT\\(', '').replaceAll('RIGHT\\(', '').split(',')[0];
            String newValue = values[0].replaceAll('\\$', '\\\\\\$') + ' starts_with ' + values[1];
            expression = expression.replaceAll(mMatcher.group(0).replace('(', '\\(').replace(')', '\\)').replaceAll('\\$', '\\\\\\$'), newValue);
        }

        mPattern = pattern.compile('[!]{0,1}(CONTAINS|INCLUDES)\\(\\$[\\w,.]{1,}[\\w("]{1,}[)]{2}');
        mMatcher = mPattern.matcher(expression);

        while (mMatcher.find()) {
            List<String> values = mMatcher.group(0).split(',');
            String operator = '';

            if (mMatcher.group(0).indexOf('CONTAINS') > -1) {
                operator = ' contains ';
                values[0] = values[0].replaceAll('CONTAINS\\(', '');
            }

            if (mMatcher.group(0).indexOf('!CONTAINS') > -1) {
                operator = ' does_not_contain ';
                values[0] = values[0].replaceAll('\\!CONTAINS\\(', '');
            }

            if (mMatcher.group(0).indexOf('INCLUDES') > -1) {
                operator = ' includes ';
                values[0] = values[0].replaceAll('INCLUDES\\(', '');
            }

            if (mMatcher.group(0).indexOf('!INCLUDES') > -1) {
                operator = ' excludes ';
                values[0] = values[0].replaceAll('\\!INCLUDES\\(', '');
            }

            String newValue = values[0].replaceAll('\\$', '\\\\\\$') + operator + values[1].removeEnd(')');
            expression = expression.replaceAll(mMatcher.group(0).replace('(', '\\(').replace(')', '\\)').replaceAll('\\$', '\\\\\\$'), newValue);
        }

        mPattern = pattern.compile('(BOOLEAN|DECIMAL|DATE|DATETIME|INTEGER|TEXT)\\([\\w" .,-:/+]{1,}\\)');
        mMatcher = mPattern.matcher(expression);

        while (mMatcher.find()) {
            String newValue = mMatcher.group(0).replaceAll('[\\w]{1,}\\("', '').replaceAll('"\\)', '');
            expression = expression.replaceAll(mMatcher.group(0).replace('(', '\\(').replace(')', '\\)'), newValue);
        }


        expression = expression.replaceAll('==', ' equals ');
        expression = expression.replaceAll('!=', ' not_equal_to ');
        expression = expression.replaceAll('<', ' less_then ');
        expression = expression.replaceAll('>=', ' greater_or_equal ');
        expression = expression.replaceAll('>', ' greater_then ');
        expression = expression.replaceAll('<=', ' less_or_equal ');

        Set<String> conditions = new Set<String>(expression.replaceAll('OR\\(', '')
                .replaceAll('AND\\(', '')
//                .removeEnd(')')
                .replaceAll('\\)', '')
//                .replaceAll('\\(', '')
                .split(','));

        Integer index = 1;

        for (String condition : conditions) {
            expression = expression.replaceAll(condition.replaceAll('\\$', '\\\\\\$'), String.valueOf(index));
            index++;
        }

        expression = expression.replaceAll(',', ', ');

        Map<String, String> items = new Map<String, String>();
        index = 1;
        Boolean needRerun = true;

        while (needRerun) {

            mPattern = pattern.compile('(OR|AND)\\([\\w\\s,]{1,}\\)');
            mMatcher = mPattern.matcher(expression);
            needRerun = false;

            while (mMatcher.find()) {
                needRerun = true;
                items.put('F' + index, mMatcher.group(0));
                expression = expression.replaceAll(mMatcher.group(0).replace('(', '\\(').replace(')', '\\)'), 'F' + index);
                index = index + 1;
            }

        }

        expression = expression.replaceAll(', ', parentCondition);

        for (String key : items.keySet()) {
            String values = items.get(key);
            String condition = values.indexOf('AND') == 0 ? ' AND ' : ' OR ';

            mPattern = pattern.compile('[^ANDOR(][\\w\\s,]{1,}\\)');
            mMatcher = mPattern.matcher(values);

            while (mMatcher.find()) {
                values = mMatcher.group(0).removeEnd(')');
            }

            values = '(' + values.replaceAll(', ', condition) + ')';
            items.put(key, values);

            mPattern = pattern.compile('F[0-9]{1,}');
            mMatcher = mPattern.matcher(values);

            while (mMatcher.find()) {
                String newValue = values.replaceAll(mMatcher.group(0), items.get(mMatcher.group(0)));
                items.put(key, newValue);
            }
        }

        mPattern = pattern.compile('F[0-9]{1,}');
        mMatcher = mPattern.matcher(expression);

        while (mMatcher.find()) {
            expression = expression.replaceAll(mMatcher.group(0), items.get(mMatcher.group(0)));
        }

        if (!isSingleExpression) {
            if (isCustomLogic) {
                result.put('logicType', 'CUSTOM');
                result.put('customLogic', expression);
            } else {
                if (expression.indexOf('AND') > -1) {
                    result.put('logicType', 'AND');
                } else {
                    result.put('logicType', 'OR');
                }
                result.put('customLogic', '');
            }
        } else {
            result.put('logicType', 'AND');
        }

        result.put('expressionLines', convertSetToExpressionLineWrapper(conditions, customVariableDelimiter));

        return result;
    }

    public static String simpleFormulaConversion(List<String> formulaItems, String logicType, Integer size) {
        if (size == 1) {
            return '1';
        }
        String result = logicType + '(';
        String resultEnd = '';

        for (Integer i = 0; i < size; i++) {
            String itemValue = formulaItems.size() > 0 ? formulaItems[i] : String.valueOf(i + 1);
            if (i != (size - 1)) {
                result = result + itemValue + ', ';
            } else {
                result = result + itemValue + ')';
            }
        }

        return result + resultEnd;
    }

    public static String convertExpressionLines(ExpressionLineWrapper expressionLine) {
        String leftItem = '\\' + expressionLine.fieldName;
        String rightItem = String.escapeSingleQuotes(expressionLine.parameter);
        String dataType = expressionLine.dataType.toUpperCase();
        String result = '';

        if (expressionLine.operator == 'equals') {
            result = leftItem + ' == ' + convertValueType(rightItem, dataType);
        }

        if (expressionLine.operator == 'not_equal_to') {
            result = leftItem + ' != ' + convertValueType(rightItem, dataType);
        }

        if (expressionLine.operator == 'starts_with') {
            result = 'LEFT(' + leftItem + ' , ' + expressionLine.parameter.length() + ') == ' + convertValueType(rightItem, dataType);
        }

        if (expressionLine.operator == 'end_with') {
            result = 'RIGHT(' + leftItem + ' , ' + expressionLine.parameter.length() + ') == ' + convertValueType(rightItem, dataType);
        }

        if (expressionLine.operator == 'contains') {
            result = 'CONTAINS(' + leftItem + ' , ' + convertValueType(rightItem, dataType) + ')';
        }

        if (expressionLine.operator == 'does_not_contain') {
            result = '!CONTAINS(' + leftItem + ' , ' + convertValueType(rightItem, dataType) + ')';
        }

        if (expressionLine.operator == 'greater_or_equal') {
            result = leftItem + ' >= ' + convertValueType(rightItem, dataType);
        }

        if (expressionLine.operator == 'greater_then') {
            result = leftItem + ' > ' + convertValueType(rightItem, dataType);
        }

        if (expressionLine.operator == 'less_then') {
            result = leftItem + ' < ' + convertValueType(rightItem, dataType);
        }

        if (expressionLine.operator == 'less_or_equal') {
            result = leftItem + ' <= ' + convertValueType(rightItem, dataType);
        }

        if (expressionLine.operator == 'includes') {
            result = 'INCLUDES(' + leftItem + ' , ' + convertValueType(rightItem, dataType) + ')';
        }

        if (expressionLine.operator == 'excludes') {
            result = '!INCLUDES(' + leftItem + ' , ' + convertValueType(rightItem, dataType) + ')';
        }

        return result;

    }

    public static List<ExpressionLineWrapper> convertSetToExpressionLineWrapper(Set<String> lines, String customVariableDelimiter) {
        List<ExpressionLineWrapper> result = new List<ExpressionLineWrapper>();

        for (String line : lines) {
            List<String> lineParameters = line.split(' ');
            if (lineParameters.size() == 3) {
                List<String> fieldInfo = lineParameters[0].replaceAll('[$]', '').split('\\.');
                String fieldName = customVariableDelimiter == null ? lineParameters[0] : lineParameters[0].replaceAll('\\$', customVariableDelimiter);
                result.add(new ExpressionLineWrapper(fieldInfo[0], fieldName, '', lineParameters[1], lineParameters[2].replaceAll(SPACE_SYMBOL, ' ')));
            }
        }

        return result;
    }

    public static String convertValueType(String fieldValue, String dataType) {
        if (dataType == 'BOOLEAN') {
            return 'BOOLEAN("' + fieldValue + '")';
        } else if (dataType == 'CURRENCY' || dataType == 'PERCENT' || dataType == 'DOUBLE') {
            return 'DECIMAL("' + fieldValue + '")';
        } else if (dataType == 'DATE') {
            return 'DATE("' + fieldValue + '")';
        } else if (dataType == 'DATETIME') {
            return 'DATETIME("' + fieldValue + '")';
        } else if (dataType == 'INTEGER') {
            return 'INTEGER("' + fieldValue + '")';
        } else {
            return 'TEXT("' + fieldValue + '")';
        }
    }

    public class ExpressionLineWrapper {
        @AuraEnabled
        public String objectType;
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String dataType;
        @AuraEnabled
        public String operator;
        @AuraEnabled
        public String parameter;

        public ExpressionLineWrapper(String objectType, String fieldName, String dataType, String operator, String parameter) {
            this.objectType = objectType;
            this.fieldName = fieldName;
            this.dataType = dataType;
            this.operator = operator;
            this.parameter = parameter;
        }
    }
}
