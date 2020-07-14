@isTest
global class AssertionIterators {
    
    static String makeMsgTemplate (String fieldName, Boolean isDescending, String sortKey) {
        return String.format('previous.{0} ({3}) {1} current.{0} ({4}), sortKeys={2}.',
        new List<String> {fieldName,
            (isDescending ? '>=' : '<='), 
            sortKey,
            '{0}', 
            '{1}'});
    }

    /**
     * Extend this iterator for specific value types.
     */
    global virtual class FieldSortAssertionIterator implements Iterator <SObject> {
        List<SObject> objects {get; set;}
        Integer i {get; set;}
        String fieldName;
        Boolean isDescending;
        SObject previous = null;
        String msgTemplate;

        /**
         * @param objects - List of objects
         * @param sortKey - A string in the format of FieldName:SortDirection where SortDirection is
         *  DESC or ASC (anything other than DESC is treated as ASC)
         */
        public FieldSortAssertionIterator (List<SObject> objects, String sortKey) {
            List<String> tokens;
            this.objects = objects;
            this.i = 0;
            tokens = sortKey.split(':');
            this.fieldName = tokens[0];
            this.isDescending = (tokens[1] == 'DESC');
            this.msgTemplate = makeMsgTemplate(this.fieldName, this.isDescending, sortKey);
        }
        
        global boolean hasNext(){
            return (this.i < this.objects.size());
        }

        global virtual SObject next() {
            SObject current;
            if (hasNext()) {
                current = this.objects[i];
                if (i == 0) {
                    this.previous = current;
                } else {
                    Integer prevValue = this.previous.get(this.fieldName) == null ?
                        null : (Integer) this.previous.get(this.fieldName);
                    Integer curValue = current.get(this.fieldName) == null ? 
                        null : (Integer) current.get(this.fieldName);
                    List<Integer> values = new List<Integer> {prevValue,curValue};
                    if (isDescending) {
                        System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                        String.format(this.msgTemplate, values));
                    } else {
                        System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                        String.format(this.msgTemplate, values));                    
                    }
                    this.previous = current;
                }
                i++;
                return current;
            } 
            return null;
        }
    }
    /**
     * Field value type 'BOOLEAN' (checkboxes)
     */
    global class BooleanFieldSortAssertionIterator extends FieldSortAssertionIterator {

        public BooleanFieldSortAssertionIterator (List<SObject> objects, String sortKey) {
            super(objects, sortKey);
        }

        global override SObject next() {
            SObject current;
            if (hasNext()) {
                current = this.objects[i];
                if (i == 0) {
                    this.previous = current;
                } else {
                    Boolean prevValue = this.previous.get(this.fieldName) == null ?
                        null : (Boolean) this.previous.get(this.fieldName);
                    Boolean curValue = current.get(this.fieldName) == null ? 
                        null : (Boolean) current.get(this.fieldName);
                    List<Boolean> values = new List<Boolean> {prevValue,curValue};
                    if (isDescending) {
                        System.assert((prevValue == curValue) || (prevValue && !curValue), 
                        String.format(this.msgTemplate, values));
                    } else {
                        System.assert((prevValue == curValue) || (!prevValue && curValue), 
                        String.format(this.msgTemplate, values));                    
                    }
                    this.previous = current;
                }
                i++;
                return current;
            } 
            return null;
        }
    }

    /**
     * Field value types 'DATE'
     */
    global class DateFieldSortAssertionIterator extends FieldSortAssertionIterator {

        public DateFieldSortAssertionIterator (List<SObject> objects, String sortKey) {
            super(objects, sortKey);
        }
        
        global override SObject next() {
            SObject current;
            if (hasNext()) {
                current = this.objects[i];
                if (i == 0) {
                    this.previous = current;
                } else { // Datetime.newInstance(1700, 1, 1) is the minimum Salesforce date
                    Date prevValue = this.previous.get(this.fieldName) == null ?
                        null : (Date) this.previous.get(this.fieldName); 
                    Date curValue = current.get(this.fieldName) == null ? 
                       null : (Date) current.get(this.fieldName);
                    List<Object> values = new List<Date> {prevValue,curValue};
                    if (isDescending) {
                        System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                        String.format(this.msgTemplate, values));
                    } else {
                        System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                        String.format(this.msgTemplate, values));                    
                    }
                    this.previous = current;
                }
                i++;
                return current;
            } 
            return null;
        }
    }

    /**
     * Field value types DATETIME'
     */
    global class DatetimeFieldSortAssertionIterator extends FieldSortAssertionIterator {

        public DatetimeFieldSortAssertionIterator (List<SObject> objects, String sortKey) {
            super(objects, sortKey);
        }
        
        global override SObject next() {
            SObject current;
            if (hasNext()) {
                current = this.objects[i];
                if (i == 0) {
                    this.previous = current;
                } else { // Datetime.newInstance(1700, 1, 1) is the minimum Salesforce date
                    Datetime prevValue = this.previous.get(this.fieldName) == null ?
                        null : (Datetime) this.previous.get(this.fieldName); 
                    Datetime curValue = current.get(this.fieldName) == null ? 
                       null : (Datetime) current.get(this.fieldName);
                    List<Datetime> values = new List<Datetime> {prevValue,curValue};
                    System.debug(String.format('DatetimeFieldSortAssertionIterator.prevValue {0} , .curValue {1}', 
                        new List<Datetime> {prevValue, curValue}));
                    if (isDescending) {
                        System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                        String.format(this.msgTemplate, values));
                    } else {
                        System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                        String.format(this.msgTemplate, values));                    
                    }
                    this.previous = current;
                }
                i++;
                return current;
            } 
            return null;
        }
    }

    /**
     * Field value type decimal - 'CURRENCY', 'DECIMAL'
     */
    global class DecimalFieldSortAssertionIterator extends FieldSortAssertionIterator {

        public DecimalFieldSortAssertionIterator (List<SObject> objects, String sortKey) {
            super(objects, sortKey);
        }
        
        global override SObject next() {
            SObject current;
            if (hasNext()) {
                current = this.objects[i];
                if (i == 0) {
                    this.previous = current;
                } else {
                    Decimal prevValue = this.previous.get(this.fieldName) == null ?
                        null : (Decimal) this.previous.get(this.fieldName);
                    Decimal curValue = current.get(this.fieldName) == null ? 
                        null : (Decimal) current.get(this.fieldName);
                    List<Decimal> values = new List<Decimal> {prevValue,curValue};
                    if (isDescending) {
                        System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                        String.format(this.msgTemplate, values));
                    } else {
                        System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                        String.format(this.msgTemplate, values));                    
                    }
                    this.previous = current;
                }
                i++;
                return current;
            } 
            return null;
        }
    }
    /**
     * Field value types 'DOUBLE', 'INTEGER', 'PERCENT' 
     */
    global class DoubleFieldSortAssertionIterator extends FieldSortAssertionIterator {

        public DoubleFieldSortAssertionIterator (List<SObject> objects, String sortKey) {
            super(objects, sortKey);
        }
        
        global override SObject next() {
            SObject current;
            if (hasNext()) {
                current = this.objects[i];
                if (i == 0) {
                    this.previous = current;
                } else {
                    Double prevValue = this.previous.get(this.fieldName) == null ?
                        null : (Double) this.previous.get(this.fieldName); 
                        Double curValue = current.get(this.fieldName) == null ? 
                       null : (Double) current.get(this.fieldName);
                    List<Double> values = new List<Double> {prevValue,curValue};
                    if (isDescending) {
                        System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                        String.format(this.msgTemplate, values));
                    } else {
                        System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                        String.format(this.msgTemplate, values));                    
                    }
                    this.previous = current;
                }
                i++;
                return current;
            } 
            return null;
        }
    }
    /**
     * Field value types 'ID', 'EMAIL', 'STRING', 'PICKLIST', 'PHONE'
     */
    global class StringFieldSortAssertionIterator extends FieldSortAssertionIterator {

        public StringFieldSortAssertionIterator (List<SObject> objects, String sortKey) {
            super(objects, sortKey);
        }
        
        global override SObject next() {
            SObject current;
            if (hasNext()) {
                current = this.objects[i];
                if (i == 0) {
                    this.previous = current;
                } else { // Datetime.newInstance(1700, 1, 1) is the minimum Salesforce date
                    String prevValue = this.previous.get(this.fieldName) == null ?
                        null : (String) this.previous.get(this.fieldName); 
                    String curValue = current.get(this.fieldName) == null ? 
                       null : (String) current.get(this.fieldName);
                    List<String> values = new List<String> {prevValue,curValue};
                    if (isDescending) {
                        System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                        String.format(this.msgTemplate, values));
                    } else {
                        System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                        String.format(this.msgTemplate, values));                    
                    }
                    this.previous = current;
                }
                i++;
                return current;
            } 
            return null;
        }
    }
    /**
     * Field value types 'TIME'
     */
    global class TimeFieldSortAssertionIterator extends FieldSortAssertionIterator {

        public TimeFieldSortAssertionIterator (List<SObject> objects, String sortKey) {
            super(objects, sortKey);
        }
        
        global override SObject next() {
            SObject current;
            if (hasNext()) {
                current = this.objects[i];
                if (i == 0) {
                    this.previous = current;
                } else { // Datetime.newInstance(1700, 1, 1) is the minimum Salesforce date
                    Time prevValue = this.previous.get(this.fieldName) == null ?
                        null : (Time) this.previous.get(this.fieldName); 
                    Time curValue = current.get(this.fieldName) == null ? 
                       null : (Time) current.get(this.fieldName);
                    List<Time> values = new List<Time> {prevValue,curValue};
                    if (isDescending) {
                        System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                        String.format(this.msgTemplate, values));
                    } else {
                        System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                        String.format(this.msgTemplate, values));                    
                    }
                    this.previous = current;
                }
                i++;
                return current;
            } 
            return null;
        }

        Time makeTime (String s) {
            Time t = null;
            if (s != null) {
                List<String> timeTokens = s.split(':'); // Max 4 tokens
                t = Time.newInstance(timeTokens.size() >= 1 ? Integer.valueOf(timeTokens[0]) : 0, //hour
                                     timeTokens.size() >= 3 ? Integer.valueOf(timeTokens[1]) : 0, //min
                                     timeTokens.size() >= 3 ? Integer.valueOf(timeTokens[2]) : 0,  //sec
                                     timeTokens.size() >= 4 ? Integer.valueOf(timeTokens[3]) : 0); //ms
            }
            return t;
        }
    }
}