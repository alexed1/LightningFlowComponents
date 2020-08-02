/**
 * Provides a Salesforce Ligntning Flow component for sorting collections.
 * 
 * The following field types are supported and have been tested: 
 *  BOOLEAN, CURRENCY, DATE, DATETIME, DECIMAL, DOUBLE, EMAIL, ID, INTEGER, 
 *  LONG, PERCENT, PHONE, PICKLIST, REFERENCE, STRING, TIME.
 * See SortCollectionTest.cls for test coverage of API data types and UI field types.
 */
global with sharing class SortCollection {
    @InvocableMethod
    global static List <Results> sort(List<Requests> requestList) {
        List<Results> responseWrapper = new List<Results>();
        for (Requests curRequest : requestList) {
            List<SObject> outputCollection;
            List<String> rawData = curRequest.sortKeys.replaceAll('"+| +', '').split(',');
            SortKeys sk = new SortKeys();
            for (String rd : rawData) {
                if (rd != null && rd.length() > 2) {
                    List<String> fieldDirection = rd.split(':');
                    if (fieldDirection.size() == 2) {
                        sk.sortKeys.add(new SortKeyMember(fieldDirection[0], fieldDirection[1]));
                    }
                }
            }

            outputCollection = curRequest.inputCollection;

            if (outputCollection != null && !outputCollection.isEmpty()) {
                List<String> allFields = new List<String>();
                for (SortKeyMember skm : sk.sortKeys) {
                    allFields.add(skm.field);
                }

                Map<String, String> fieldTypes = CollectionProcessorsUtils.getFieldTypes(outputCollection[0], allFields);

                for (SortKeyMember skm : sk.sortKeys) {
                    List<SortableWrapper> sortable = new List<SortableWrapper>();
                    for (SObject acc : outputCollection) {
                        sortable.add(new SortableWrapper(acc, skm.field, skm.direction == 'DESC' ? -1 : 1, fieldTypes.get(skm.field)));
                    }
                    sortable.sort();
                    outputCollection.clear();
                    for (SortableWrapper sw : sortable) {
                        outputCollection.add(sw.acc);
                    }
                }
            }

            Results response = new Results();
            response.outputCollection = outputCollection;
            responseWrapper.add(response);
        }
        return responseWrapper;
    }

    global class SortableWrapper implements Comparable {
        global SObject acc;
        global String field;
        global Integer direction;
        global String fieldType;
        global Comparable orig;
 
        public SortableWrapper(SObject acc, String field, Integer direction, String fieldType) {
            this.acc = acc;
            this.field = field;
            this.direction = direction;
            this.fieldType = fieldType;
            this.orig = getComparable(this.fieldType, acc.get(this.field));
            if (this.orig == null) {
            	System.debug(System.LoggingLevel.WARN, 
                    String.format('UNSUPPORTED_FIELD_TYPE: fieldType "{1}", field "{0}", in SortableWrapper().',
                    new List<String> {this.field, this.fieldType}));
            } else {
            	System.debug('SortableWrapper(): field ' + field + ', field type "' + fieldType + '", value ' + acc.get(this.field) + '.' );
        	}
        }

        global Integer compareTo(Object compareTo) {
            SortableWrapper compareToAcc = (SortableWrapper) compareTo;
            Integer returnValue = (this.orig != null) ? 
                this.orig.compareTo(compareToAcc.acc.get(this.field)) * direction :
                0;
            return returnValue;
        }
    }
    /**
     * @param inputCollection An SObject collection. Be sure that it includes 
     *  any field referenced in the Sort Keys.
     * @param sortKeys One or more comma separated sort keys formatted as 
     *  [Field API Name]:[ASC|DESC]. Sort directions other
     *  than DESC are treated as ASC. Invalid sort field api names will result 
     *  in a "System.NullPointerException: Attempt to de-reference a null 
     *  object".  If the field is missing from an SObject in the collection, 
     *  the following error will occur:
     *  "System.SObjectException: SObject row was retrieved via SOQL without 
     *  querying the requested field: [Object Name].[Field Name]"
     */
    global class Requests {
        @InvocableVariable(required=true label='Input Collection' 
                           description='An SObject collection. Be sure that it includes any field referenced in the Sort Keys.')
        global List<SObject> inputCollection;

        @InvocableVariable(required=true label='Sort Keys'
                          description='One or more comma separated sort keys formatted as [Field API Name]:[ASC|DESC].')
        global String sortKeys;
    }

    global class Results {

        public Results() {
            outputCollection = new List<SObject>();
        }

        @InvocableVariable(label='Output Collection')
        global List<SObject> outputCollection;
    }

    private class SortKeys {
        List<SortKeyMember> sortKeys;
        public SortKeys() {
            sortKeys = new List<SortKeyMember>();
        }
    }
    private class SortKeyMember {
        public SortKeyMember(String field, String direction) {
            this.field = field;
            this.direction = direction;
        }
        String field;
        String direction;
    }

    /**
     * Field Type Comparable Factory
     * @return A Comparable cooresponding to the fieldType or null if none exists.
     */
    @TestVisible
    private static Comparable getComparable (String fieldType, Object value) {
        Comparable comp = null;
        switch on fieldType {
            when 'BOOLEAN' {
                comp = new BooleanComparable(value);
            }
            when 'CURRENCY', 'DOUBLE', 'PERCENT' {
                comp = new DoubleComparable(value);
            }
            when 'DECIMAL' {
                comp = new DecimalComparable(value);
            }
            when 'DATE' {
                comp = new DateComparable(value);
            }
            when 'DATETIME' { 
                comp = new DatetimeComparable(value);
            }
            when 'INTEGER', 'LONG' {
                comp = new DoubleComparable(value);
            }
            when 'ID', 'EMAIL', 'STRING', 'PHONE', 'PICKLIST', 'REFERENCE' {
                comp = new StringComparable(value);
                // TODO: Sort PICKLIST according to order https://www.jitendrazaa.com/blog/salesforce/get-picklist-values-in-apex/
            }
            when 'TIME' {
                comp = new TimeComparable(value);
            }
        }
        return comp;            
    }

    private class BooleanComparable implements Comparable {
        Boolean value;
        
        public BooleanComparable (Object initialValue) {
            this.value = (initialValue == null) ? null : Boolean.valueOf(initialValue);
        }
        
        // true is greater than false; false is greater than null
        public Integer compareTo(Object compareTo) {
            Integer returnValue = 0;
            Boolean compareToValue = (compareTo == null) ? null : Boolean.valueOf(compareTo);
            //System.debug('BooleanComparable.compareTo value=' 
            //    + (value == null ? 'null' : String.valueof(value))
            //    + ' compareToValue=' + (compareToValue == null ? 'null' : String.valueof(compareToValue)));
            if (this.value == null && compareToValue == null) {
                returnValue = 0;
            } else if (value == null) {
                returnValue = -1;
            } else if ((compareToValue == null) || (this.value && !compareToValue)) {
                returnValue = 1;
            } else if (!this.value && compareToValue) {
                returnValue = -1;
            }     
            return returnValue;  
        }
    }
    private class DateComparable implements Comparable {
        Date value;
        
        public DateComparable (Object initialValue) {
            this.value = (initialValue == null) ? null : (Date) initialValue;
        }
        
        public Integer compareTo(Object compareTo) {
            Integer returnValue = 0;
            Date compareToValue = (compareTo == null) ? null : (Date) compareTo;
            if (this.value == null && compareToValue == null) { 
                returnValue = 0;
            } else if (this.value == null) {
                returnValue = -1;
            } else if ((compareToValue == null) || (this.value > compareToValue)) {
                returnValue = 1;
            } else if (this.value < compareToValue) {
                returnValue = -1;
            }
            return returnValue;
        }
    }

    private class DatetimeComparable implements Comparable {
        Datetime value;
        
        public DatetimeComparable (Object initialValue) {
            this.value = (initialValue == null) ? null : (Datetime) initialValue;
        }
        
        public Integer compareTo(Object compareTo) {
            Integer returnValue = 0;
            Datetime compareToValue = (compareTo == null) ? null : (Datetime) compareTo;
            if (this.value == null && compareToValue == null) { 
                returnValue = 0;
            } else if (this.value == null) {
                returnValue = -1;
            } else if ((compareToValue == null) || (this.value > compareToValue)) {
                returnValue = 1;
            } else if (this.value < compareToValue) {
                returnValue = -1;
            }
            return returnValue;
        }
    }

    private class DecimalComparable implements Comparable {
        Decimal value;
        
        public DecimalComparable (Object initialValue) {
            this.value = (initialValue == null) ? null : (Decimal) initialValue;
        }
        
        public Integer compareTo(Object compareTo) {
            Integer returnValue = 0;
            Decimal compareToValue = (compareTo == null) ? null : (Decimal) compareTo;
            if (this.value == null && compareToValue == null) { 
                returnValue = 0;
            } else if (this.value == null) {
                returnValue = -1;
            } else if ((compareToValue == null) || (this.value > compareToValue)) {
                returnValue = 1;
            } else if (this.value < compareToValue) {
                returnValue = -1;
            }
            return returnValue;
        }
    }

    private class DoubleComparable implements Comparable {
        Double value;
        
        public DoubleComparable (Object initialValue) {
            this.value = (initialValue == null) ? null : Double.valueOf(initialValue);
        }
        
        public Integer compareTo(Object compareTo) {
            Integer returnValue = 0;
            Double compareToValue = (compareTo == null) ? null : Double.valueOf(compareTo);
            if (this.value == null && compareToValue == null) { 
                returnValue = 0;
            } else if (this.value == null) {
                returnValue = -1;
            } else if ((compareToValue == null) || (this.value > compareToValue)) {
                returnValue = 1;
            } else if (this.value < compareToValue) {
                returnValue = -1;
            }
            return returnValue;
        }
    }

    private class StringComparable implements Comparable {
        String value;
        
        public StringComparable (Object initialValue) {
            this.value = (initialValue == null) ? null : String.valueOf(initialValue);
        }
        
        public Integer compareTo(Object compareTo) {
            Integer returnValue = 0;
            String compareToValue = (compareTo == null) ? null : String.valueOf(compareTo);
            if (this.value == null && compareToValue == null) { 
                returnValue = 0;
            } else if (this.value == null) {
                returnValue = -1;
            } else if ((compareToValue == null) || (this.value > compareToValue)) {
                returnValue = 1;
            } else if (this.value < compareToValue) {
                returnValue = -1;
            }
            return returnValue;
        }
    }

    private class TimeComparable implements Comparable {
        Time value;
        
        public TimeComparable (Object initialValue) {
            this.value = (Time) initialValue;
        }
        
        public Integer compareTo(Object compareTo) {
            Integer returnValue = 0;
            Time compareToValue = (Time) compareTo;
            if (this.value == null && compareToValue == null) { 
                returnValue = 0;
            } else if (this.value == null) {
                returnValue = -1;
            } else if ((compareToValue == null) || (this.value > compareToValue)) {
                returnValue = 1;
            } else if (this.value < compareToValue) {
                returnValue = -1;
            }
            return returnValue;
        }
    }
}