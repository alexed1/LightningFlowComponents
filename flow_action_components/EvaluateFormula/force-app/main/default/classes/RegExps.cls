global class RegExps {

    public static final String EXP_NULL = '(?i:NULL)'; 
    public static final String EXP_BOOLEAN = '(?i:TRUE|FALSE)'; 
    public static final String EXP_STRING =  '"([^"|\"])*"';
    public static final String EXP_NUMBER = '[0-9]*\\.?[0-9]+';
    public static final String EXP_DATE = '[0-9]{4}\\-[0-9]{2}\\-[0-9]{2}'; 
    public static final String EXP_DATETIME = EXP_DATE + '(T[0-9]{2}:[0-9]{2}:[0-9]{2})?'; 
    public static final String EXP_VALUE = '(' + EXP_NULL + '|' + EXP_STRING + '|' + EXP_NUMBER + '|' + EXP_DATE + '|' + EXP_DATETIME + '|' + EXP_BOOLEAN + ')';
    public static final String EXP_OPERAND = '(_[S|N|D|B|T][0-9]+[S|N|D|B|T]_)';
    public static final String EXP_NUMBER_TOKEN = '(_D[0-9]+D_)';
    public static final String EXP_MATH_EXPRESSION_COMPONENT = EXP_NUMBER_TOKEN+'|\\+|\\-|\\*|/';
    public static final String EXP_MULTILINE_COMMENT = '/\\*.+?(?=\\*/)\\*/';
    public static final String EXP_BOOLEAN_TOKEN = '(_B[0-9]+B_)';
    public static final String EXP_DATETIME_TOKEN = '(_T[0-9]+T_)';
    public static final String EXP_NULL_TOKEN = '(_N[0-9]+N_)';
    public static final String EXP_STRING_TOKEN = '(_S[0-9]+S_)';
    public static final String EXP_CUSTOM_SETTING_POLISH = '(\\$SETUP\\.[A-Z][A-Z_0-9]{2,40}__C(\\[\\s*' + EXP_STRING + '\\s*\\])?\\.[A-Z][A-Z_0-9]{2,40}__C)';
    public static final String EXP_MATH_EXPRESSION_TOKEN_DELIMITER = '_@_';
    public static final String EXP_COMPARE_EXPRESSION = '('+EXP_OPERAND+' (_O[0-9]O_) '+EXP_OPERAND+')';
    
    public static final Map<String,String> COMPARE_OPERATORS =  new Map<String,String>{
        '<=' => '_O0O_',
        '>=' => '_O1O_',
        '==' => '_O2O_',
        '<>' => '_O5O_',
        '<' => '_O3O_',
        '>' => '_O4O_',
        '=' => '_O2O_'};

    public static final String EXP_BINARY_MATH_OPERATOR_HIGH = '('+EXP_NUMBER_TOKEN+'((\\s*([*/])\\s*'+EXP_NUMBER_TOKEN+')+))';
    public static final String EXP_BINARY_MATH_OPERATOR_LOW = '('+EXP_NUMBER_TOKEN+'((\\s*([+-])\\s*'+EXP_NUMBER_TOKEN+')+))';
    public static final String EXP_BINARY_MATH_OPERATOR_HIGH_INNER = '\\s*([*/])\\s*' + EXP_NUMBER_TOKEN;
    public static final String EXP_BINARY_MATH_OPERATOR_LOW_INNER = '\\s*([+-])\\s*' + EXP_NUMBER_TOKEN;
    public static final String EXP_IF = 'IF\\s*\\(\\s*'+EXP_BOOLEAN_TOKEN+'\\s*,\\s*'+EXP_OPERAND+'\\s*,\\s*'+EXP_OPERAND+'\\s*\\)';
    public static final String EXP_CASE = 'CASE\\s*\\(\\s*'+EXP_OPERAND+'\\s*(,\\s*'+EXP_OPERAND+'\\s*)*\\)';
    
    global class ParserContext{

        public ParserContext(String formula, String outputType, Integer scale){
            this.formula = formula;
            this.outputString = formula.replace('\n',' ').replace('\r','');
            this.outputType = outputType;
            this.referencesString= new Map<String,String>();
            this.referencesDecimal= new Map<String,Decimal>();
            this.referencesNULL= new Set<String>();
            this.referencesBoolean= new Map<String,Boolean>();
            this.referencesDateTime = new Map<String,DateTime>();
            this.replacements = new Map<String,String>();
            this.fieldsPlaceholders = new Map<String,String>();
            this.fields = new Set<String>();
            this.fieldValues = new Map<String, Object>();
            this.fieldTypes = new Map<String,String>(); 
            this.result = null;
            this.isError = false;
            this.errorMessage = null;
            this.scale = scale;

            if (this.scale != null) {
                this.scale = Math.abs(this.scale);
            }
        }

        public String formula;
        public String outputString;
        public Map<String,String> referencesString;
        public Map<String,Decimal> referencesDecimal;
        public Map<String,DateTime> referencesDateTime;
        public Set<String> referencesNULL;
        public Map<String,Boolean> referencesBoolean;
        public Map<String,String> replacements;
        public Map<String,String> fieldsPlaceholders;
        public Set<String> fields;
        public Map<String,Object> fieldValues;
        public Map<String,String> fieldTypes;
        public String outputType;
        global Object result{get;set;}
        global Boolean isError{get;set;}
        global String errorMessage{get;set;}
        public String stackTrace{get;set;}
        public Integer scale{get;set;}
        
        public void replace(String origin, String value){
            this.outputString = this.outputString.replace(' ' + origin + ' ',' _S' + this.referencesString.size() + 'S_ ');
            this.replacements.put('_S' + this.referencesString.size() + 'S_', origin);
            this.referencesString.put('_S' + this.referencesString.size() + 'S_', value);     
        }
        public void replace(String origin, Boolean value){
            this.outputString = this.outputString.replace(' ' + origin + ' ',' _B' + this.referencesBoolean.size() + 'B_ ');
            this.replacements.put('_B' + this.referencesBoolean.size() + 'B_', origin);
            this.referencesBoolean.put('_B' + this.referencesBoolean.size() + 'B_', value);     
        }
        public void replace(String origin, Decimal value){
            this.outputString = this.outputString.replace(' ' + origin + ' ',' _D' + this.referencesDecimal.size() + 'D_ ');
            this.replacements.put('_D' + this.referencesDecimal.size() + 'D_', origin);
            this.referencesDecimal.put('_D' + this.referencesDecimal.size() + 'D_', value);     
        }
        public void replace(String origin, DateTime value){
            this.outputString = this.outputString.replace(' ' + origin + ' ',' _T' + this.referencesDateTime.size() + 'T_ ');
            this.replacements.put('_T' + this.referencesDateTime.size() + 'T_', origin);
            this.referencesDateTime.put('_T' + this.referencesDateTime.size() + 'T_', value);     
        }
        public void replace(String origin){
            this.outputString = this.outputString.replace(origin,'_N' + this.referencesNull.size() + 'N_');
            this.replacements.put('_N' + this.referencesNull.size() + 'N_', origin);
            this.referencesNull.add('_N' + this.referencesNull.size() + 'N_');
        }
    }
    
    public static void evaluateMathExpressions (ParserContext context) {

        String[] formulaSplit = context.outputString.trim().split('\\s+');
        String pieceOfExpression = null;
        String prevToken = null;
        String firstToken = null;
        String token = null;
        List<String> evaluableExpressions = new List<String>();
        
        for (Integer i = 0; i < formulaSplit.size(); i++) {

            token = formulaSplit[i];
            
            if (String.isBlank(token)) {
                continue;
            }
            
            if (Pattern.matches(EXP_MATH_EXPRESSION_COMPONENT,token)) {
                if (pieceOfExpression == null) {
                    pieceOfExpression = '';
                }

                if (String.isBlank(pieceOfExpression) && Pattern.matches('^[+-]$', token) && (i != 0 && !Pattern.matches('^(\\(|,|(_O[0-9]+O_))$',formulaSplit[i-1]))) {
                    pieceOfExpression = null;
                    prevToken = null;
                    firstToken = token;
                    continue;
                }

                pieceOfExpression += ' '+token;
                prevToken = token;

                if (i == formulaSplit.size() - 1) {
                    prevToken = '';
                }
            } else {
                if (prevToken!=null && Pattern.matches(EXP_NUMBER_TOKEN, prevToken)) {
                    if (firstToken == null) {
                        firstToken = '';
                    }
                    evaluableExpressions.add(firstToken + ' ' + EXP_MATH_EXPRESSION_TOKEN_DELIMITER + pieceOfExpression.trim() + EXP_MATH_EXPRESSION_TOKEN_DELIMITER + ' ' + token);
                }
                pieceOfExpression = null;
                prevToken = null;
                firstToken = token;
            }
        }

        if (token != null && Pattern.matches(EXP_NUMBER_TOKEN, token)) {
            if (firstToken == null) {
                firstToken = '';
            }
            if (token == null) {
                token = '';
            }
            evaluableExpressions.add(firstToken + ' ' + EXP_MATH_EXPRESSION_TOKEN_DELIMITER + pieceOfExpression.trim() + EXP_MATH_EXPRESSION_TOKEN_DELIMITER + ' ' + prevtoken);
        }

        Map<Integer,List<String>> expressionsByLength = new Map<Integer,List<String>>();

        for (String k : evaluableExpressions) {
            List<String> fls = expressionsByLength.get(k.length());
            if (fls == null) {
                fls = new List<String>();
                expressionsByLength.put(k.length(), fls);
            }
            fls.add(k);
        }
        
        List<List<String>> sortedExpressions = expressionsByLength.values();
        String tmpOutput = context.outputString;

        for (Integer i = sortedExpressions.size() - 1; i >= 0; i--) {
            List<String> fls = sortedExpressions[i];
            for (String exp : fls) {

                String tmp = exp.split(EXP_MATH_EXPRESSION_TOKEN_DELIMITER)[1].trim();

                if (Pattern.matches('^([+-])?\\s*' + EXP_NUMBER_TOKEN + '(\\s*[\\+\\-\\*/]\\s*([+-])?\\s*' + EXP_NUMBER_TOKEN + ')*', tmp)) {
                    
                    Pattern myPattern = pattern.compile('^([+-])\\s*' + EXP_NUMBER_TOKEN + '(\\s*(\\+\\-\\*/)\\s*([+-])?\\s*' + EXP_NUMBER_TOKEN + ')*');
                    Matcher m = myPattern.matcher(tmp);

                    while (m.find()) { 
                        decimal val = context.referencesDecimal.get(m.group(2));
                        String sign = m.group(1);
                        if (sign == '-') {
                            val = -1 * val;
                        }
                        exp = exp.replace(sign + ' ' + m.group(2), ' _D' + context.referencesDecimal.size() + 'D_ ');
                        context.outputString = context.outputString.replace(tmp,exp.split(EXP_MATH_EXPRESSION_TOKEN_DELIMITER)[1]);
                        context.replacements.put('_D' + context.referencesDecimal.size() + 'D_', sign + ' ' + m.group(2));
                        context.referencesDecimal.put('_D' + context.referencesDecimal.size() + 'D_', val);
                        break;
                    }
                }
                
                while (true) {
                    context.outputString = context.outputString.replaceAll('\\s+',' ');
                    tmp = context.outputString;
                    evaluateBinaryOperations(context, exp, EXP_BINARY_MATH_OPERATOR_HIGH, EXP_BINARY_MATH_OPERATOR_HIGH_INNER);
                    if (tmp != context.outputString) {
                        break;
                    }
                    evaluateBinaryOperations(context, exp, EXP_BINARY_MATH_OPERATOR_LOW, EXP_BINARY_MATH_OPERATOR_LOW_INNER);
                    if (tmp == context.outputString) {
                        break;
                    }
                }
            }
        }
        clearMinusAndPlus(context);
    }
    
    public static void clearParentesis(ParserContext context){
        clearParentesis(context,'ALL');
    }

    public static void clearParentesis (ParserContext context, String type) {

        if (String.isBlank(type)) {
            type = 'ALL';
        }

        Pattern myPattern = pattern.compile('\\(\\s*(' + EXP_OPERAND + ')\\s*\\)');
        Matcher m = myPattern.matcher(context.outputString);

        while (m.find()) {

            String placeholder = m.group(1);
            String name = null;

            if (placeholder.contains('N') && (type == 'NULL' || type == 'ALL')) {
                name = placeholder;
            } else if (placeholder.contains('D') && (type == 'NUMBER' || type == 'ALL')) {
                name = placeholder;
            } else if (placeholder.contains('B') && (type == 'BOOLEAN' || type == 'ALL')) {
                name = placeholder;
            } else if (placeholder.contains('T') && (type == 'DATETIME' || type == 'ALL')) {
                name = placeholder;
            } else if (placeholder.contains('S') && (type == 'STRING' || type == 'ALL')) {
                name = placeholder;
            }

            if (String.isBlank(name)) {
                continue;
            }

            context.outputString = context.outputString.replace(m.group(0),name);
            context.replacements.put(name, m.group(0));
        }
    }

    public static void wrapParentesis (ParserContext context, String type) {

        if(String.isBlank(type)) {
            type = 'ALL';
        } 

        Pattern myPattern = pattern.compile(EXP_OPERAND);
        Matcher m = myPattern.matcher(context.outputString);

        while (m.find()) {   
            String placeholder = m.group(0);
            String name = null;

            if (placeholder.contains('N') && (type == 'NULL' || type == 'ALL')) {
                name = placeholder;
            } else if (placeholder.contains('D') && (type == 'NUMBER' || type == 'ALL')) {
                name = placeholder;
            } else if (placeholder.contains('B') && (type == 'BOOLEAN' || type == 'ALL')) {
                name = placeholder;
            } else if (placeholder.contains('T') && (type == 'DATETIME' || type == 'ALL')) {
                name = placeholder;
            } else if (placeholder.contains('S') && (type == 'STRING' || type == 'ALL')) {
                name = placeholder;
            }

            if (String.isBlank(name)) {
                continue;
            }

            context.outputString = context.outputString.replace(m.group(0),'( ' + name + ' )');
            context.replacements.put('( ' + name + ' )', m.group(0));
        }
    }
    
    public static void clearMinusAndPlus(ParserContext context){
        Pattern myPattern = pattern.compile('([+-/*])\\s*([+-])\\s*' + EXP_NUMBER_TOKEN);
        Matcher m = myPattern.matcher(context.outputString);
        while (m.find()) {   
            String firstSign = m.group(1);
            String secondSign = m.group(2);
            String numberToken = m.group(3);
            decimal val = context.referencesDecimal.get(numberToken);
            if (secondSign == '-') {
                val = -1*val;
            }
            context.outputString = context.outputString.replace(' ' + m.group(0) + ' ', ' ' + firstSign + ' _D' + context.referencesDecimal.size() + 'D_ ');
            context.replacements.put('_D' + context.referencesDecimal.size() + 'D_', m.group(0));
            context.referencesDecimal.put('_D' + context.referencesDecimal.size() + 'D_', val);
        }
    }

    public static void evaluateBinaryOperations (ParserContext context, String actualExpression, String regexp, String innerRegExp) {

        actualExpression = actualExpression.trim();
        String[] tmpSplit = actualExpression.split(EXP_MATH_EXPRESSION_TOKEN_DELIMITER);
        String expression = tmpSplit[1];
        String endingToken = (tmpSplit.size()==3) ? actualExpression.split(EXP_MATH_EXPRESSION_TOKEN_DELIMITER)[2] : '';
        String startingToken = actualExpression.split(EXP_MATH_EXPRESSION_TOKEN_DELIMITER)[0];
        String toBeReplaced = actualExpression.replace(EXP_MATH_EXPRESSION_TOKEN_DELIMITER, '');
        Pattern myPattern = pattern.compile('()\\s*' + regexp);

        Pattern innerPattern = pattern.compile(innerRegExp);
        Matcher m = myPattern.matcher(expression.trim());
        
        while (m.find()) {
            
            String sign = m.group(1).trim();
            String leftOperand = m.group(3);
            Decimal lValue = context.referencesDecimal.get(leftOperand);

            if (sign == '-') {
                lValue = -1 * lValue;
            }

            Decimal val = lValue;
            Matcher innerMatcher = innerPattern.matcher(m.group(4));

            while (innerMatcher.find()) {

                String operator = innerMatcher.group(1);
                String rightOperand = innerMatcher.group(2);
                
                Decimal rValue = rightOperand == null ? 0 : context.referencesDecimal.get(rightOperand);
                if (operator == '+') {
                    val = val + rValue;
                } else if (operator == '-') {
                    val = val - rValue;
                } else if (operator == '/') {
                    val = val / rValue;
                } else if (operator == '*') {
                    val = val * rValue;
                }

            }
            
            expression = expression.replace(' ' + m.group(0) + ' ', ' _D' + context.referencesDecimal.size() + 'D_ ');
            expression = expression.replace(m.group(0), ' _D'+context.referencesDecimal.size() + 'D_ ');
            context.replacements.put('_D' + context.referencesDecimal.size() + 'D_', m.group(0));
            context.referencesDecimal.put('_D' + context.referencesDecimal.size() + 'D_', val);
        }

       
        if (expression.trim() == tmpSplit[1].trim()) {
            return;
        }
        
        context.outputString = context.outputString.replace(toBeReplaced, startingToken + ' ' + expression.trim() + ' ' + endingToken);
    }
    
    public static void evaluateStringOperations(ParserContext context){
        
        Pattern myPattern = pattern.compile('(' + EXP_NULL_TOKEN + '|' + EXP_STRING_TOKEN + ')(\\s+\\+\\s+(' + EXP_NULL_TOKEN + '|' + EXP_STRING_TOKEN + '))+');
        Pattern tmpPattern = pattern.compile(EXP_STRING_TOKEN);
        Matcher m = myPattern.matcher(context.outputString);

        while (m.find()) {
            Matcher tmpMatcher = tmpPattern.matcher(m.group(0));
            String val = '';

            while (tmpMatcher.find()) {
                String v = context.referencesString.get(tmpMatcher.group(1));
                if (v == null) {
                    v = '';
                }
                val += v;
            }
            
            context.replace(m.group(0), val);
        }
    }
    
    public static void evaluateMathFunctions (ParserContext context) {

        Pattern myPattern = pattern.compile('(ABS|ROUND|CEIL|FLOOR|SQRT|ACOS|ASIN|ATAN|COS|SIN|TAN|COSH|SINH|TANH|EXP|LOG|LOG10|RINT|SIGNUM|INTEGER)\\s*\\(\\s*' + EXP_OPERAND + '\\s*\\)');
        Matcher m = myPattern.matcher(context.outputString);

        while (m.find()) {
        	String func = m.group(1);
        	String valueRef = m.group(2);

        	if(!valueRef.contains('N') && !valueRef.contains('D')){
        		throw new ExpressionParsingException('Unsupported parameter type on function ' + func + '(): expected Number but received "' + getValueReferenceType(valueRef) + '".');
        	}

            Decimal val = context.referencesDecimal.get(valueRef);

            if (val== null) {
                val = 0;
            }
            
            if (func == 'ABS') {
            	val = Math.abs(val);
            } else if (func == 'ROUND') {
            	val = Math.round(val);
            } else if (func == 'CEIL') {
            	val = Math.ceil(val);
            } else if (func == 'FLOOR') {
            	val = Math.floor(val);
            } else if (func == 'SQRT') {
            	val = Math.sqrt(val);
            } else if (func == 'ACOS') {
            	val = Math.ACOS(val);
            } else if (func == 'ASIN') {
            	val = Math.ASIN(val);
            } else if (func == 'ATAN') {
            	val = Math.ATAN(val);
            } else if (func == 'COS') {
            	val = Math.COS(val);
            } else if (func == 'SIN') {
            	val = Math.SIN(val);
            } else if (func == 'TAN') {
            	val = Math.TAN(val);
            } else if (func == 'COSH') {
            	val = Math.COSH(val);
            } else if (func == 'SINH') {
            	val = Math.SINH(val);
            } else if (func == 'TANH') {
            	val = Math.TANH(val);
            } else if (func == 'EXP') {
            	val = Math.exp(val);
            } else if (func == 'LOG') {
            	val = Math.LOG(val);
            } else if (func == 'LOG10') {
            	val = Math.LOG10(val);
            } else if (func == 'LOG10') {
            	val = Math.LOG10(val);
            } else if (func == 'SIGNUM') {
            	val = Math.SIGNUM(val);
            } else if (func == 'RINT') {
            	val = Math.RINT(val);
            } else if(func == 'INTEGER') {
            	val = val.intValue();
            }

            context.replace(m.group(0), val);
        }
        
        myPattern = pattern.compile('(POW|MAX|MIN|MOD)\\s*\\(\\s*' + EXP_OPERAND+'\\s*\\,\\s*' + EXP_OPERAND + '\\s*\\)');
        m = myPattern.matcher(context.outputString);

        while (m.find()) {
        	String func = m.group(1);
        	String valueRef1 = m.group(2);
        	String valueRef2 = m.group(3);
            
        	if (!valueRef1.contains('N') && !valueRef1.contains('D')) {
        		throw new ExpressionParsingException('Unsupported parameter type on function ' + func + '(): expected Number but received "' + getValueReferenceType(valueRef1) + '".');
        	}
        	if (!valueRef2.contains('N') && !valueRef2.contains('D')) {
        		throw new ExpressionParsingException('Unsupported parameter type on function ' + func + '(): expected Number but received "' + getValueReferenceType(valueRef2) + '".');
        	}
        	
            Decimal val1 = context.referencesDecimal.get(valueRef1);
            Decimal val2 = context.referencesDecimal.get(valueRef2);

            if(val1 == null) {
                val1 = 0;
            }

            if (val2 == null) {
                val2 = 0;
            }
            
            if (func == 'POW') {
            	val1 = (Decimal)Math.pow((Double)val1, (Double)val2);
            } else if (func == 'MAX') {
            	val1 = Math.max(val1,val2);
            } else if (func == 'MIN') {
            	val1 = Math.min(val1,val2);
            } else if (func == 'MOD') {
            	val1 = Math.mod(val1.intValue(), val2.intValue());
            }
            
            context.replace(m.group(0), val1);
        }
    }

    public static void evaluateTypeConversionFunctions (ParserContext context) {
		
		Pattern myPattern = pattern.compile('(TEXT|DATETIME|INTEGER|DECIMAL|BOOLEAN|DATE)\\s*\\(\\s*' + EXP_OPERAND + '\\s*\\)');
        Matcher m = myPattern.matcher(context.outputString);

        while (m.find()) {
        	
            String valueRef = m.group(2);
            String func = m.group(1);

            if (func == 'TEXT') {

            	String val = '';

            	if (valueRef.contains('N')) {
                    val = null;
                } else if (valueRef.contains('D')) {
                    val = String.valueOf(context.referencesDecimal.get(valueRef));
                } else if (valueRef.contains('B')) {
                    val = String.valueOf(context.referencesBoolean.get(valueRef));
                } else if (valueRef.contains('S')) {
                    val = String.valueOf(context.referencesString.get(valueRef));
                } else if (valueRef.contains('T')) {
                    val = context.referencesDatetime.get(valueRef).format('yyyy-MM-dd\'T\'HH:mm:ss');
                }
            	
            	if (val != null) {
                    context.replace(m.group(0), val);
            	} else {
                    context.replace(m.group(0));
            	}

            } else if (func == 'DATETIME' || func == 'DATE') {

            	DateTime vdt = null;

            	if (valueRef.contains('N')) {
                    vdt = null;
                } else if (valueRef.contains('S')) { 

            		String val = String.valueOf(context.referencesString.get(valueRef));

            		if (!Pattern.matches(RegExps.EXP_DATETIME, val)) {
		                throw new ExpressionParsingException('Cannot apply DATETIME() function: Invalid date/time value "' + val + '". Expected: YYYY-MM-DDTHH:MM:SS');
		            }

		            List<String> datePart = val.split('T')[0].split('\\-');
		            List<String> timePart= new List<String>{'0','0','0'};

		            if (val.split('T').size() > 1) {
						timePart= val.split('T')[1].split(':');
		            }

		            vdt = DateTime.newInstanceGmt(Integer.valueOf(datePart[0]), Integer.valueOf(datePart[1]), Integer.valueOf(datePart[2]), 
		                                            Integer.valueOf(timePart[0]), Integer.valueOf(timePart[1]), Integer.valueOf(timePart[2]));

            	} else if (valueRef.contains('T')) {
                    vdt = (context.referencesDatetime.get(valueRef));
                } else {
            		throw new ExpressionParsingException('Unsupported parameter type on function DATETIME(): expected String or DateTime but received "' + getValueReferenceType(valueRef) + '".');
            	}

            	if (vdt != null) {
            		if (func == 'DATE') {
                        vdt = vdt.date();
                    }
                    context.replace(m.group(0), vdt);
            	} else {
					context.replace(m.group(0));
            	}    
            } else if (func == 'INTEGER' || func == 'DECIMAL') {
                
            	Decimal val = null;

            	if (valueRef.contains('N')) {
                    val = 0;
                } else if (valueRef.contains('S')) { 
            		String strVal = context.referencesString.get(valueRef);
            		try {
            			val = Decimal.valueOf(strVal);
            		} catch (Exception e) {
            			throw new ExpressionParsingException('Cannot apply ' + func + '() function: Invalid numeric value "' + strVal + '".');
            		}
            	} else if (valueRef.contains('D')) { 
            		val = context.referencesDecimal.get(valueRef);
            	}

                if (val == null) {
                    val = 0;
                }

            	if (func == 'INTEGER' && val != null) {
                    val = val.intValue();
                }

                context.replace(m.group(0), val);

            } else if (func == 'BOOLEAN') {

            	Boolean val = false;

            	if(valueRef.contains('N')) {
                    val = false;
                } else if (valueRef.contains('S')) { 
            		String strVal = context.referencesString.get(valueRef);
            		if (strVal.toLowerCase()=='true') {
            			val = true;
            		} else if (strVal.toLowerCase()=='false') {
            			val = false;
            		} else {
            			throw new ExpressionParsingException('Cannot apply BOOLEAN() function: Invalid boolean value "' + strVal + '".');
            		}
            	} else if (valueRef.contains('B')) { 
            		val = context.referencesBoolean.get(valueRef);
            	}
                
                context.replace(m.group(0), val);

            }
        }
    }
    
    
    private static String getValueReferenceType (String token) {
    	if (token.contains('N')) {
            return 'NULL';
        } else if (token.contains('D')) {
            return 'NUMBER';
        } else if (token.contains('B')) {
            return 'BOOLEAN';
        } else if (token.contains('S')) {
            return 'STRING';
        } else if (token.contains('T')) {
            return 'DATETIME';
        }
    	return 'NONE';
    }
    
    public static void evaluateDateTimeFunctions (ParserContext context) {
        
        Pattern myPattern = pattern.compile('(DATE)\\s*\\(\\s*' + EXP_OPERAND + '\\s*,\\s*' + EXP_OPERAND + '\\s*,\\s*' + EXP_OPERAND + '\\s*\\)');
        Matcher m = myPattern.matcher(context.outputString);

        while (m.find()) {
        	String yearRef = m.group(2);
            if (!yearRef.contains('N') && !yearRef.contains('D')) {
        		throw new ExpressionParsingException('Cannot apply DATE("YEAR",month,day) function: Expected Numeric year parameters, parameters but received "'
                                                     +getValueReferenceType(yearRef) + '".');
        	}
            String monthRef = m.group(3);
            if (!monthRef.contains('N') && !monthRef.contains('D')) {
        		throw new ExpressionParsingException('Cannot apply DATE(year,"MONTH",day) function: Expected Numeric year parameters, parameters but received "'
                                                     +getValueReferenceType(monthRef) + '".');
        	}
            String dayRef = m.group(4);
            if (!dayRef.contains('N') && !dayRef.contains('D')) {
        		throw new ExpressionParsingException('Cannot apply DATE(year,month,"DAY") function: Expected Numeric year parameters, parameters but received "'
                                                      + getValueReferenceType(dayRef) + '".');
        	}
            Decimal year = context.referencesDecimal.get(yearRef);
            if (year == null) {
                year = 1900;
            }
            Decimal month = context.referencesDecimal.get(monthRef);
            if (month == null) {
                month = 1;
            }
            Decimal day = context.referencesDecimal.get(dayRef);
            if (day == null) {
                day = 1;
            }
            Date dateVal = Date.newInstance(year.intValue(),month.intValue(),day.intValue());
            context.replace(m.group(0), dateVal);
        }
        
        myPattern = pattern.compile('(DATETIME)\\s*\\(\\s*' + EXP_OPERAND + '\\s*,\\s*' + EXP_OPERAND + '\\s*,\\s*' + EXP_OPERAND + '\\s*,\\s*' + EXP_OPERAND + '\\s*,\\s*' + EXP_OPERAND + '\\s*,\\s*' + EXP_OPERAND + '\\s*\\)');
        m = myPattern.matcher(context.outputString);

        while (m.find()) {
        	String yearRef = m.group(2);
            if (!yearRef.contains('N') && !yearRef.contains('D')) {
        		throw new ExpressionParsingException('Cannot apply DATETIME("YEAR",month,day,hours,minutes,seconds) function: Expected Numeric year parameters, parameters but received "'
                                                     + getValueReferenceType(yearRef) + '".');
        	}
            String monthRef = m.group(3);
            if (!monthRef.contains('N') && !monthRef.contains('D')) {
        		throw new ExpressionParsingException('Cannot apply DATE(year,"MONTH",day,hours,minutes,seconds) function: Expected Numeric year parameters, parameters but received "'
                                                     + getValueReferenceType(monthRef) + '".');
        	}
            String dayRef = m.group(4);
            if (!dayRef.contains('N') && !dayRef.contains('D')) {
        		throw new ExpressionParsingException('Cannot apply DATE(year,month,day,hours,minutes,seconds) function: Expected Numeric year parameters, parameters but received "'
                                                     + getValueReferenceType(dayRef) + '".');
        	}
            String hoursRef = m.group(5);
            if (!dayRef.contains('N') && !dayRef.contains('D')) {
        		throw new ExpressionParsingException('Cannot apply DATE(year,month,day,"HOURS",minutes,seconds) function: Expected Numeric year parameters, parameters but received "'
                                                     + getValueReferenceType(hoursRef) + '".');
        	}
            String minutesRef = m.group(6);
            if (!dayRef.contains('N') && !dayRef.contains('D')) {
        		throw new ExpressionParsingException('Cannot apply DATE(year,month,day,hours,"MINUTES",seconds) function: Expected Numeric year parameters, parameters but received "'
                                                     +getValueReferenceType(minutesRef) + '".');
        	}
            String secondsRef = m.group(7);
            if (!dayRef.contains('N') && !dayRef.contains('D')) {
        		throw new ExpressionParsingException('Cannot apply DATE(year,month,day,hours,minutes,"SECONDS") function: Expected Numeric year parameters, parameters but received "'
                                                     + getValueReferenceType(secondsRef) + '".');
        	}
            Decimal year = context.referencesDecimal.get(yearRef);
            if (year == null) {
                year = 1900;
            }
            Decimal month = context.referencesDecimal.get(monthRef);
            if (month == null) {
                month = 1;
            }
            Decimal day = context.referencesDecimal.get(dayRef);
            if (day == null) {
                day = 1;
            }
            Decimal hours = context.referencesDecimal.get(hoursRef);
            if (hours == null) {
                hours = 0;
            }
            Decimal minutes = context.referencesDecimal.get(minutesRef);
            if (minutes == null) {
                minutes = 0;
            }
            Decimal seconds = context.referencesDecimal.get(secondsRef);
            if (seconds == null) {
                seconds = 0;
            }
            DateTime datetimeVal = DateTime.newInstanceGMT(year.intValue(),month.intValue(),day.intValue(), hours.intValue(), minutes.intValue(), seconds.intValue());
            context.replace(m.group(0), datetimeVal);
        }
        
        myPattern = pattern.compile('(DAY|MONTH|YEAR|HOURS|MINUTES|SECONDS)\\s*\\(\\s*' + EXP_OPERAND + '\\s*\\)');
        m = myPattern.matcher(context.outputString);

        while (m.find()) {
        	Decimal val = null;
        	String func = m.group(1);
        	String valueRef = m.group(2);
        	if (!valueRef.contains('N') && !valueRef.contains('T')) {
        		throw new ExpressionParsingException('Cannot apply '+func+'() function: Expected DateTime but received "' + getValueReferenceType(valueRef) + '".');
        	}
        	DateTime valDT = context.referencesDateTime.get(valueRef);
        	if (func == 'DAY') {
        		if (valueRef.contains('N')) {
        			val = 0;
        		} else {
        			val = valDT.day();
        		}
        	} else if (func == 'MONTH') {
        		if (valueRef.contains('N')) {
        			val = 0;
        		} else {
        			val = valDT.month();
        		}
        	} else if (func == 'YEAR') {
        		if (valueRef.contains('N')) {
        			val = 0;
        		} else {
        			val = valDT.year();
        		}
        	} else if (func == 'HOURS') {
        		if (valueRef.contains('N')) {
        			val = 0;
        		} else {
        			val = valDT.hour();
        		}
        	} else if (func == 'MINUTES') {
        		if (valueRef.contains('N')) {
        			val = 0;
        		} else {
        			val = valDT.minute();
        		}
        	} else if (func == 'SECONDS') {
        		if (valueRef.contains('N')) {
        			val = 0;
        		} else {
        			val = valDT.second();
        		}
        	}

            context.replace(m.group(0), val);
        }

        myPattern = pattern.compile('(ADDDAYS|ADDMONTHS|ADDYEARS|ADDHOURS|ADDMINUTES|ADDSECONDS)\\s*\\(\\s*' + EXP_OPERAND+'\\s*\\,\\s*' + EXP_OPERAND + '\\s*\\)');
        m = myPattern.matcher(context.outputString);

        while (m.find()) {

        	String func = m.group(1);
        	String valueRef1 = m.group(2);
        	String valueRef2 = m.group(3);
        	
        	if (!valueRef1.contains('N') && !valueRef1.contains('T')) {
        		throw new ExpressionParsingException('Cannot apply ' + func + '() function: Expected DateTime but received "' + getValueReferenceType(valueRef1) + '".');
        	}
        	if (!valueRef2.contains('N') && !valueRef2.contains('D')) {
        		throw new ExpressionParsingException('Cannot apply ' + func + '() function: Expected Number but received "' + getValueReferenceType(valueRef2) + '".');
        	}
        	
        	DateTime val = null;
        	DateTime valDT = context.referencesDateTime.get(valueRef1);
        	Decimal valNum = context.referencesDecimal.get(valueRef2);

        	if (valNum == null) {
                valNum = 0;
            }
        	
        	if (func == 'ADDDAYS') {
        		if (valueRef1.contains('N')) {
        			val = null;
        		} else {
        			val = valDT.adddays(valNum.intValue());
        		}
        	} else if (func == 'ADDMONTHS') {
        		if (valueRef1.contains('N')) {
        			val = null;
        		} else {
        			val = valDT.addmonths(valNum.intValue());
        		}
        	}else if(func == 'ADDYEARS'){
        		if(valueRef1.contains('N')){
        			val = null;
        		}else{
        			val = valDT.addyears(valNum.intValue());
        		}
        	} else if (func == 'ADDHOURS') {
        		if (valueRef1.contains('N')) {
        			val = null;
        		} else {
        			val = valDT.addhours(valNum.intValue());
        		}
        	} else if (func == 'ADDMINUTES') {
        		if (valueRef1.contains('N')) {
        			val = null;
        		} else {
        			val = valDT.addminutes(valNum.intValue());
        		}
        	} else if (func == 'ADDSECONDS') {
        		if (valueRef1.contains('N')) {
        			val = null;
        		} else {
        			val = valDT.addseconds(valNum.intValue());
        		}
        	}

            context.replace(m.group(0), val);

        }
    }

    public static void evaluateStringFunctions (ParserContext context) {

        final String LEN_FN = '((LEN|ISBLANK)\\s*\\(\\s*(' + EXP_OPERAND + ')\\s*\\))';
        final String SUBSTRING_FN = '(SUBSTRING\\s+\\(\\s+' + EXP_OPERAND + '\\s+,\\s+' + EXP_OPERAND + '\\s+,\\s+' + EXP_OPERAND + '\\s+\\))';
        final String LEFT_RIGHT_FN = '((LEFT|RIGHT)\\s+\\(\\s+' + EXP_OPERAND + '\\s+,\\s+' + EXP_OPERAND + '\\s+\\))';
        final String ISPICKVAL_FN = '((ISPICKVAL)\\s+\\(\\s+' + EXP_OPERAND + '\\s+,\\s+' + EXP_OPERAND + '\\s+\\))';
        final String CONVERTID_FN = '((CONVERTID)\\s*\\(\\s*(' + EXP_OPERAND + ')\\s*\\))';

        Pattern myPattern = pattern.compile(LEN_FN + '|' + SUBSTRING_FN + '|' + LEFT_RIGHT_FN + '|' + ISPICKVAL_FN + '|' + CONVERTID_FN);
        Matcher m = myPattern.matcher(context.outputString);

        while (m.find()) {
            if (m.group().startsWith('CONVERTID')) {

                String ref = m.group(19);

                if (!ref.contains('N') && !ref.contains('S')) {
                    throw new ExpressionParsingException('Cannot apply CONVERTID() function: Expected String parameters but received "' + getValueReferenceType(ref) + '".');
                }

                String val = context.referencesString.get(ref);

                if (String.isBlank(val)) {
                    val = null;
                } else {
                    try{
                        val = String.valueOf(ID.valueOf(val));
                    } catch (Exception e) {
                        throw new ExpressionParsingException('Cannot apply CONVERTID() function: Expected ID String parameters but received "' + getValueReferenceType(ref) + '".');
                    }
                }

                context.replace(m.group(0), val);

            } else if (m.group().startsWith('LEN')) {

                String ref = m.group(3);

                if (!ref.contains('N') && !ref.contains('S')) {
                    throw new ExpressionParsingException('Cannot apply LEN() function: Expected String parameters but received "' + getValueReferenceType(ref) + '".');
                }

                String val = context.referencesString.get(ref);
                
                decimal len = 0;

                if (!String.isBlank(val)) {
                    len = val.length();
                }

                context.replace(m.group(0), len);

            } else if (m.group().startsWith('ISBLANK')) {
                
                String ref = m.group(3);

                if (!ref.contains('N') && !ref.contains('S')) {
                    throw new ExpressionParsingException('Cannot apply ISBLANK() function: Expected String parameters but received "' + getValueReferenceType(ref) + '".');
                }
                
                String val = context.referencesString.get(ref);
                Boolean isBlank = String.isBlank(val);

                context.replace(m.group(0), isBlank);
                
            } else if (m.group().startsWith('SUBSTRING')) {

                String ref1 = m.group(6);
                String ref2 = m.group(7);
                String ref3 = m.group(8);

                if (!ref1.contains('N') && !ref1.contains('S') && !ref2.contains('N') && !ref2.contains('D') && !ref3.contains('N') && !ref3.contains('D')) {
                    throw new ExpressionParsingException('Cannot apply SUBSTRING(str, num, num) function: Expected String, Number and Number parameters but received "'
                                                         + getValueReferenceType(ref1) + '","' + getValueReferenceType(ref2) + '","' + getValueReferenceType(ref3) + '".');
                }
                
                String val = context.referencesString.get(ref1);
                decimal fromIndexD = context.referencesDecimal.get(ref2);
                decimal toIndexD = context.referencesDecimal.get(ref3);

                if (fromIndexD == null) {
                    fromIndexD = 0;
                }

                if (toIndexD == null) {
                    toIndexD = 0;
                }

                Integer fromIndex = Integer.valueOf(fromIndexD);
                Integer toIndex = Integer.valueOf(toIndexD);

                if (val == null) {
                    val = '';
                }

                String substr = val;

                if (String.isBlank(val) || fromIndex < 0 || toIndex < 0 || fromIndex > val.length() || toIndex <= fromIndex ) {
                    val = '';
                } else {
                    substr = substr.substring(fromIndex, toIndex);
                }

                context.replace(m.group(0), substr);

            } else if (m.group().startsWith('LEFT') || m.group().startsWith('RIGHT')) {

                Boolean isLeft = m.group().startsWith('LEFT');
                String ref1 = m.group(11);
                String ref2 = m.group(12);

                if (!ref1.contains('N') && !ref1.contains('S') && !ref2.contains('N') && !ref2.contains('D')) {
                    throw new ExpressionParsingException('Cannot apply ' + (isLeft?'LEFT':'RIGHT') + '(str, num) function: Expected String, Number parameters but received "'
                                                         + getValueReferenceType(ref1) + '","' + getValueReferenceType(ref2) + '".');
                }
                
                String val = context.referencesString.get(ref1);
                decimal lenD = context.referencesDecimal.get(ref2);
                
                if (lenD == null) {
                    lenD = 0;
                }

                Integer len = Integer.valueOf(lenD);

                if (val == null) {
                    val = '';
                }

                String substr = val;

                if (String.isBlank(val) || len < 0) {
                    val = '';
                } else if (len < val.length()) {
                    substr = (isLeft) ? substr.left(len) : substr.right(len);
                }

                context.replace(m.group(0), substr);

            } else if (m.group().startsWith('ISPICKVAL')) {

                String ref1 = m.group(15);
                String ref2 = m.group(16);

                if(!ref1.contains('N') && !ref1.contains('S') && !ref2.contains('N') && !ref2.contains('S')) {
                    throw new ExpressionParsingException('Cannot apply ISPICKVAL(str, str) function: Expected String, String parameters but received "'
                                                         +getValueReferenceType(ref1) + '","' + getValueReferenceType(ref2) + '".');
                }
                
                String val = context.referencesString.get(ref1);
                String pickval = context.referencesString.get(ref2);
                Boolean isPickVal = (val == pickval);

                context.replace(m.group(0), isPickVal);
            }
        }
    }
    
    public static void evaluateCompareExpressions (ParserContext context) {
        
        Pattern myPattern = pattern.compile(EXP_COMPARE_EXPRESSION);
        Matcher m = myPattern.matcher(context.outputString);

        while (m.find()) {
            
            String leftOperand = m.group(2);
            String operator = m.group(3);
            String rightOperand = m.group(4);

            if (leftOperand.contains('N') && !rightOperand.contains('N')) {

                String tmp = leftOperand;
                leftOperand = rightOperand;
                rightOperand = tmp;

                if (operator == '_O0O_') {
                    operator = '_O1O_';
                } else if (operator == '_O1O_') {
                    operator = '_O0O_';
                } else if (operator == '_O3O_') {
                    operator = '_O4O_';
                } else if (operator == '_O4O_') {
                    operator = '_O3O_';
                }
            }
            
            if (leftOperand.contains('S')) {

                if (!rightOperand.contains('S') && !rightOperand.contains('N')) {
                    throw new ExpressionParsingException(iterativePlaceholderDiscover(rightOperand, context) + ' is not a string in ' + iterativePlaceholderDiscover(m.group(0), context));
                }

                if (operator != '_O2O_' && operator != '_O5O_') {
                    throw new ExpressionParsingException(operator + ' is not a valid string compare operator in' + iterativePlaceholderDiscover(m.group(0), context));
                }

                String strLeftValue = context.referencesString.get(leftOperand);
                String strRightValue = rightOperand.contains('N')?'':context.referencesString.get(rightOperand);
                Boolean val = (strLeftValue == strRightValue && operator == '_O2O_') || (strLeftValue != strRightValue && operator == '_O5O_');
                context.replace(m.group(0), val);
                
            } else if (leftOperand.contains('D')) {

                decimal dblLeftValue = context.referencesDecimal.get(leftOperand);
                
                if (!rightOperand.contains('D') && !rightOperand.contains('N')) {
                    throw new ExpressionParsingException(iterativePlaceholderDiscover(rightOperand, context) + ' is not a number in ' + m.group(0));
                }
                
                decimal dblRightValue = rightOperand.contains('N') ? 0 : context.referencesDecimal.get(rightOperand);
                
                if (dblLeftValue == null) {
                    dblLeftValue = 0;
                }

                if (dblRightValue == null) {
                    dblRightValue = 0;
                }
                
                Boolean val = (operator == '_O0O_' && dblLeftValue <= dblRightValue)
                    || (operator == '_O1O_' && dblLeftValue >= dblRightValue)
                    || (operator == '_O2O_' && dblLeftValue == dblRightValue)
                    || (operator == '_O3O_' && dblLeftValue < dblRightValue)
                    || (operator == '_O4O_' && dblLeftValue > dblRightValue)
                    || (operator == '_O5O_' && dblLeftValue != dblRightValue);

                context.replace(m.group(0), val);

            } else if (leftOperand.contains('B')) {

                Boolean blnLeftValue = context.referencesBoolean.get(leftOperand);

                if (!rightOperand.contains('B') && !rightOperand.contains('N')) {
                    throw new ExpressionParsingException(iterativePlaceholderDiscover(rightOperand, context) + ' is not a boolean in ' + m.group(0));
                }

                if (operator != '_O2O_' && operator != '_O5O_') {
                    throw new ExpressionParsingException(operator + ' is not a valid boolean compare operator in' + m.group(0));
                }

                Boolean blnRightValue = rightOperand.contains('N') ? false : context.referencesBoolean.get(rightOperand);
                Boolean val = (blnLeftValue == blnRightValue && operator == '_O2O_') || (blnLeftValue != blnRightValue && operator == '_O5O_');
                context.replace(m.group(0), val);

            } else if (leftOperand.contains('T')) {

                DateTime dblLeftValue = context.referencesDatetime.get(leftOperand);

                if (!rightOperand.contains('T') && !rightOperand.contains('N')) {
                    throw new ExpressionParsingException(rightOperand + ' is not a date/datetime in ' + m.group(0));
                }
                
                DateTime dblRightValue = rightOperand.contains('N')?null:context.referencesDatetime.get(rightOperand);
                Boolean val = false;

                if (dblLeftValue == null) {
                    val = (operator == '_O0O_') 
                        || (operator == '_O1O_' && dblRightValue == null)
                        || (operator == '_O2O_' && dblRightValue == null)
                        || (operator == '_O3O_' && dblRightValue != null)
                        || (operator == '_O5O_' && dblRightValue != null);
                } else if (dblRightValue == null) {
                    val = (operator == '_O4O_' || operator == '_O5O_');
                } else {
                    val = (operator == '_O0O_' && dblLeftValue <= dblRightValue)
                        || (operator == '_O1O_' && dblLeftValue >= dblRightValue)
                        || (operator == '_O2O_' && dblLeftValue == dblRightValue)
                        || (operator == '_O3O_' && dblLeftValue < dblRightValue)
                        || (operator == '_O4O_' && dblLeftValue > dblRightValue)
                        || (operator == '_O5O_' && dblLeftValue != dblRightValue);
                }

                context.replace(m.group(0), val);

            } else if (leftOperand.contains('N') && rightOperand.contains('N')) {
                Boolean val = (operator == '_O2O_' || operator == '_O0O_' || operator == '_O1O_');
                context.replace(m.group(0), val);
            } else {
                throw new ExpressionParsingException(iterativePlaceholderDiscover(leftOperand, context) + ' not found in ' + iterativePlaceholderDiscover(m.group(0), context));
            }
        }
        context.outputString = context.outputString.replaceAll('\\s+',' ');
    }
    
    public static void evaluateFlowExpressions (ParserContext context) {
        
        Pattern myPattern = pattern.compile(EXP_IF);
        Matcher m = myPattern.matcher(context.outputString);

        while (m.find()) {
            
            String ifCondition = m.group(1);
            String ifTrue = m.group(2);
            String ifFalse = m.group(3);

            if (!ifCondition.contains('B')) {
                throw new ExpressionParsingException('Expected boolean condition on ' + iterativePlaceholderDiscover(m.group(0), context));
            }

            if (ifTrue.replaceAll('[0-9]','').replace('_','') != ifFalse.replaceAll('[0-9]','').replace('_','') && !(ifTrue.contains('N') || ifFalse.contains('N'))) {
                throw new ExpressionParsingException('Different return types for IF on ' + iterativePlaceholderDiscover(m.group(0), context));
            }

            Boolean condValue = context.referencesBoolean.get(ifCondition);

            if (ifTrue.contains('N') || ifFalse.contains('N')) {
                context.replace(m.group(0));
            }

            if(ifTrue.contains('B') || ifFalse.contains('B')){
                Boolean val = (condValue)?context.referencesBoolean.get(ifTrue):context.referencesBoolean.get(ifFalse);
                if (val == null) {
                    val = false;
                }
                context.replace(m.group(0), val);
            } else if (ifTrue.contains('S') || ifFalse.contains('S')) {
                String val = (condValue) ? context.referencesString.get(ifTrue) : context.referencesString.get(ifFalse);

                if(val == null) {
                    val = '';
                }

                context.replace(m.group(0), val);
            } else if (ifTrue.contains('D') || ifFalse.contains('D')) {
                Decimal val = (condValue) ? context.referencesDecimal.get(ifTrue) : context.referencesDecimal.get(ifFalse);

                if(val == null) {
                    val = 0;
                }
                
                context.replace(m.group(0), val);
            } else if (ifTrue.contains('T') || ifFalse.contains('T')) {
                DateTime val = (condValue)?context.referencesDateTime.get(ifTrue):context.referencesDateTime.get(ifFalse);
                context.replace(m.group(0), val);
            }
        }

        context.outputString = context.outputString.replaceAll('\\s+',' ');
        
    }

    public static void evaluateFlowExpressionsCASE (ParserContext context) {
        
        Pattern myPattern = pattern.compile(EXP_CASE);
        Pattern myPatternInternal = pattern.compile(EXP_OPERAND);
        Matcher m = myPattern.matcher(context.outputString);

        while (m.find()) {

            List<String> caseBranches = new List<String>();
            Matcher mInt = myPatternInternal.matcher(m.group());

            while (mInt.find()) {
                caseBranches.add(mInt.group());
            }
            
            if (Math.mod(caseBranches.size(), 2) != 0 || caseBranches.size() <= 2) {
                throw new ExpressionParsingException('Incorrect number of switch brances in ' + iterativePlaceholderDiscover(m.group(0), context));
            }
            
            String caseType = caseBranches[0].replaceAll('[0-9]','').replace('_','');
            String returnType = caseBranches[2].replaceAll('[0-9]','').replace('_','');
            String defaultType = caseBranches[caseBranches.size()-1].replaceAll('[0-9]','').replace('_','');

            if (caseType == 'N') {
                throw new ExpressionParsingException('Invalid null type condition for CASE on ' + iterativePlaceholderDiscover(m.group(0), context));                    
            }

            if (defaultType != returnType && defaultType != 'N') {
                throw new ExpressionParsingException('Different return types for CASE on ' + iterativePlaceholderDiscover(m.group(0), context));                    
            }
            
            if (returnType == 'N') {
                for(Integer i = 1; i < caseBranches.size()-1; i+=2) {
                    String returnTypeTemp = caseBranches[2].replaceAll('[0-9]','').replace('_','');                    
                    if (returnTypeTemp != 'N') {
                        returnType = returnTypeTemp;
                        break;
                    }
                }
            }

            for (Integer i = 1; i < caseBranches.size()-1; i+=2) {

                String cbCondition = caseBranches[i].replaceAll('[0-9]','').replace('_','');
                String cbReturn = caseBranches[i+1].replaceAll('[0-9]','').replace('_','');

                if (cbCondition != caseType) {
                    throw new ExpressionParsingException('Different conditions types for CASE on ' + iterativePlaceholderDiscover(m.group(0), context));                    
                }
                if (cbReturn != returnType && cbReturn != 'N') {
                    throw new ExpressionParsingException('Different return types for CASE on ' + iterativePlaceholderDiscover(m.group(0), context));                    
                }   

            }
            
            String returnPlaceholder = caseBranches[caseBranches.size() - 1];

            for (Integer i = 1; i < caseBranches.size()-1; i+=2) {
                if (caseType.contains('B')) {
                    Boolean valConditionIteration = (caseBranches[i].contains('N')) ? false : context.referencesBoolean.get(caseBranches[i]);
                    Boolean valMainCondition = context.referencesBoolean.get(caseBranches[0]);
                    if (valMainCondition == valConditionIteration) {
                        returnPlaceholder = caseBranches[i + 1];
                        break;
                    }
                } else if (caseType.contains('D')) {
                    Decimal valConditionIteration = (caseBranches[i].contains('N')) ? 0 : context.referencesDecimal.get(caseBranches[i]);
                    Decimal valMainCondition = context.referencesDecimal.get(caseBranches[0]);
                    if (valMainCondition == valConditionIteration) {
                        returnPlaceholder = caseBranches[i + 1];
                        break;
                    }
                } else if (caseType.contains('T')) {
                    DateTime valConditionIteration = (caseBranches[i].contains('N')) ? null : context.referencesDateTime.get(caseBranches[i]);
                    DateTime valMainCondition = context.referencesDateTime.get(caseBranches[0]);
                    if (valMainCondition == valConditionIteration) {
                        returnPlaceholder = caseBranches[i + 1];
                        break;
                    }
                } else if (caseType.contains('S')) {
                    String valConditionIteration = (caseBranches[i].contains('N')) ? null : context.referencesString.get(caseBranches[i]);
                    String valMainCondition = context.referencesString.get(caseBranches[0]);
                    if (valMainCondition == valConditionIteration || (String.isBlank(valMainCondition) && String.isBlank(valConditionIteration))) {
                        returnPlaceholder = caseBranches[i + 1];
                        break;
                    }
                }
            }

            if (returnType.contains('N')) {
                context.replace(m.group(0));
            } else if (returnType.contains('B')) {
                Boolean val = (returnPlaceholder.contains('N')) ? false : context.referencesBoolean.get(returnPlaceholder);
                context.replace(m.group(0), val);
            } else if (returnType.contains('D')) {
                Decimal val = (returnPlaceholder.contains('N')) ? 0 : context.referencesDecimal.get(returnPlaceholder);
                context.replace(m.group(0), val);
            } else if (returnType.contains('T')) {
                DateTime val = (returnPlaceholder.contains('N')) ? null : context.referencesDateTime.get(returnPlaceholder);
                context.replace(m.group(0), val);
            } else if (returnType.contains('S')) {
                String val = (returnPlaceholder.contains('N')) ? null : context.referencesString.get(returnPlaceholder);
                context.replace(m.group(0), val);
            }
        }

        context.outputString = context.outputString.replaceAll('\\s+',' ');

    }

    public static void evaluateBooleanExpressions (ParserContext context) {

        Pattern myPattern = pattern.compile('(AND|OR)\\s*\\(\\s*' + EXP_OPERAND + '(\\s*,\\s*' + EXP_OPERAND + ')+\\s*\\)');
        Matcher m = myPattern.matcher(context.outputString);

        while (m.find()) {

            String operator = m.group(1);
            Pattern myPattern2 = pattern.compile(EXP_OPERAND);
        	Matcher m2 = myPattern2.matcher(m.group(0));
            Boolean result = null;

            while (m2.find()) {
                String operand = m2.group(0);

                if (!operand.contains('B')) {
                    throw new ExpressionParsingException('Expected boolean expression on ' + operator + ' operand in ' + iterativePlaceholderDiscover(m2.group(0), context));
                }

                if (result == null) {
                    result = context.referencesBoolean.get(operand);
                } else {
                    if (operator == 'AND') {
                        result &= context.referencesBoolean.get(operand);
                    } else if (operator == 'OR') {
                        result |= context.referencesBoolean.get(operand);                        
                    }
                }
            }

            context.replace(m.group(0), result);
            
        }

        myPattern = pattern.compile('(NOT)\\s*\\(\\s*'+EXP_OPERAND+'\\s*\\)');
        m = myPattern.matcher(context.outputString);

        while (m.find()) {
            
            String operator = m.group(1);
            String rightOperand = m.group(2);
            
            if (!rightOperand.contains('B')) {
                throw new ExpressionParsingException('Expected boolean expression on ' + operator + ' operand in ' + iterativePlaceholderDiscover(m.group(0), context));
            }
            
            Boolean rVal = context.referencesBoolean.get(rightOperand);
            Boolean val = !rVal;
            context.replace(m.group(0), val);
            
        }
        
        myPattern = pattern.compile('(XOR)\\s*\\(\\s*' + EXP_OPERAND + '\\s*,\\s*' + EXP_OPERAND + '\\s*\\)');
        m = myPattern.matcher(context.outputString);

        while (m.find()) {
            
            String operator = m.group(1);
            String rightOperand = m.group(3);
            String leftOperand = m.group(2);
            
            if (!rightOperand.contains('B') || !leftOperand.contains('B')) {
                throw new ExpressionParsingException('Expected boolean expressions on ' + operator + ' operands in ' + iterativePlaceholderDiscover(m.group(0), context));
            }
           
            Boolean rVal = context.referencesBoolean.get(leftOperand);
            Boolean lVal = context.referencesBoolean.get(rightOperand);
            Boolean val = (!rVal && lVal) || (rVal && !lVal);
            context.replace(m.group(0), val);

        }
        
        myPattern = pattern.compile(EXP_OPERAND + ' (&&|\\^\\^|\\|\\|) ' + EXP_OPERAND);
        m = myPattern.matcher(context.outputString);

        while(m.find()){
            
            String leftOperand = m.group(1);
            String operator = m.group(2);
            String rightOperand = m.group(3);
            
            if (!leftOperand.contains('B')) {
                throw new ExpressionParsingException('Expected boolean expression on left ' + operator + ' operand in ' + iterativePlaceholderDiscover(m.group(0), context));
            }

            if (!rightOperand.contains('B')) {
                throw new ExpressionParsingException('Expected boolean expression on right ' + operator + ' operand in ' + iterativePlaceholderDiscover(m.group(0), context));
            }

            Boolean lVal = context.referencesBoolean.get(leftOperand);
            Boolean rVal = context.referencesBoolean.get(rightOperand);
            Boolean val = false;

            if (operator == '&&') {
                val = lVal && rVal;
            } else if (operator == '||') {
                val = lVal || rVal;
            } else if (operator == '^^') {
                val = (lVal && !rVal) || (!lval && rVal);
            }

            context.replace(m.group(0), val);
            
        }

        context.outputString = context.outputString.replaceAll('\\s+',' ');
        
        myPattern = pattern.compile('(!)\\s*' + EXP_OPERAND);
        m = myPattern.matcher(context.outputString);

        while (m.find()) {
            
            String operator = m.group(1);
            String rightOperand = m.group(2);
            
            if (!rightOperand.contains('B')) {
                throw new ExpressionParsingException('Expected boolean expression on ' + operator + ' operand in ' + iterativePlaceholderDiscover(m.group(0), context));
            }
            
            Boolean rVal = context.referencesBoolean.get(rightOperand);
            Boolean val = !rVal;
            context.replace(m.group(0), val);
            
        }
        context.outputString = context.outputString.replaceAll('\\s+',' ');
    }

    public static Object evaluateResult (ParserContext context) {

        String result = context.outputString.trim();

        if (context.outputString.contains('(') || context.outputString.contains(')')) {
            throw new ExpressionParsingException('Unbalanced parenthesis');
        }

        if (context.outputType == 'NUMBER') {
            
            if (Pattern.matches(EXP_NULL_TOKEN, result)) {
                return 0;
            }

            String sign = null;

            if (Pattern.matches('([+-])\\s*' + EXP_NUMBER_TOKEN, result)) {
                if (result.contains('+')) {
                    sign ='+';
                } else {
                    sign ='-';
                }
            }

            result = result.replaceAll('([+-])\\s*','');

            if (!Pattern.matches(EXP_NUMBER_TOKEN, result)) {
                throw new ExpressionParsingException('Formula output is NUMBER. Got ' + context.outputString + ' instead');
            }
            
            Decimal resultDec = ((sign == '-') ? -1 : 1) * context.referencesDecimal.get(result);
            if (context.scale != null) {
            	return resultDec.setscale(context.scale);
            }

            return resultDec;
        }
        
        if (result.split('\\s').size() > 1) {
            throw new ExpressionParsingException('Malformed expression ' + context.outputString.trim());
        }

        if (context.outputType == 'BOOLEAN') {

            if (!Pattern.matches(EXP_BOOLEAN_TOKEN, result)) {
                if(Pattern.matches(EXP_NULL_TOKEN, result)) {
                    return false;
                }
                throw new ExpressionParsingException('Formula output is BOOLEAN. Got ' + context.outputString + ' instead');
            }
   
            return context.referencesBoolean.get(result);

        } else if (context.outputType == 'STRING') {

            if (Pattern.matches(EXP_NULL_TOKEN, result)) {
                return '';
            }
            
            if (!Pattern.matches(EXP_STRING_TOKEN, result)) {
                throw new ExpressionParsingException('Formula output is STRING. Got ' + context.outputString + ' instead');
            }
            
            return context.referencesString.get(result);

        } else if (context.outputType == 'DATETIME') {

            if (Pattern.matches(EXP_NULL_TOKEN, result)) {
                return null;
            }
            
            if (!Pattern.matches(EXP_DATETIME_TOKEN, result)){
                throw new ExpressionParsingException('Formula output is DATETIME. Got ' + context.outputString + ' instead');
            }
            
            return context.referencesDateTime.get(result);

        } else if (context.outputType == 'DATE') {

            if (Pattern.matches(EXP_NULL_TOKEN, result)) {
                return null;
            }
            
            if (!Pattern.matches(EXP_DATETIME_TOKEN, result)) {
                throw new ExpressionParsingException('Formula output is DATE. Got ' + context.outputString + ' instead');
            }
            
            return context.referencesDateTime.get(result).date();

        }

        return null;
    }

    public static String iterativePlaceholderDiscover (String start, ParserContext context) {
        
        String output = start;
        Pattern myPattern = pattern.compile(EXP_OPERAND + '');

        while (true) { 

            output = start;
            Matcher m = myPattern.matcher(start);

            while (m.find()) {

                String token = m.group(0);
                String replacement = context.replacements.get(token);

                if (replacement == null) {
                    replacement = context.fieldsPlaceholders.get(token);
                } 
                
                if(replacement == null) {
                    replacement = context.referencesString.get(token);
                }

                if (replacement == null) {
                    replacement = String.valueOf(context.referencesDecimal.get(token));
                }

                if (replacement == null) {
                    replacement = String.valueOf(context.referencesBoolean.get(token));
                }

                if (replacement == null) {
                    replacement = String.valueOf(context.referencesDateTime.get(token));
                }

                if (replacement == null && context.referencesNULL.contains(token)) {
                    replacement = 'NULL';
                }

                if (replacement == null) {
                    continue;
                }

                start = start.replace(token, replacement);
            }

            if(output == start) {
                break;
            }
            
        }
        return start;
    }
                
    public class ExpressionParsingException extends Exception{}
}