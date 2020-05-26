/**
 * The following field types have been tested: 
 *  BOOLEAN, CURRENCY, DATE, DATETIME, DOUBLE, EMAIL, ID, PERCENT, PHONE, 
 *  PICKLIST, REFERENCE, STRING, TIME
 * The following field types are also supported:
 *  DECIMAL, INTEGER, LONG
 * API Data Types and Salesforce Field Types
 * https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/api_ui_datatype_map.htm
 */
global with sharing class SortCollection {
    @InvocableMethod

    global static List <Results> sort(List<Requests> requestList) {
        List<String> rawData = requestList[0].sortKeys.replaceAll('"+| +', '').split(',');
        SortKeys sk = new SortKeys();
        for (String rd : rawData) {
            if (rd != null && rd.length() > 2) {
                List<String> fieldDirection = rd.split(':');
                if (fieldDirection.size() == 2) {
                    sk.sortKeys.add(new SortKeyMember(fieldDirection[0], fieldDirection[1]));
                }
            }
        }

        List<SObject> outputCollection = requestList[0].inputCollection;

        if (outputCollection != null && !outputCollection.isEmpty()) {
            List<String> allFields = new List<String>();
            for (SortKeyMember skm : sk.sortKeys) {
                allFields.add(skm.field);
            }

            if (!outputCollection.isEmpty()) {
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
        }

        Results response = new Results();
        response.outputCollection = outputCollection;
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;

    }

    global class SortableWrapper implements Comparable {
        global SObject acc;
        global String field;
        global Integer direction;
        global String fieldType;
 
        public SortableWrapper(SObject acc, String field, Integer direction, String fieldType) {
            this.acc = acc;
            this.field = field;
            this.direction = direction;
            this.fieldType = fieldType;
            System.debug('SortCollection.compareTo(): field ' + field + ', field type "' + fieldType + '".' );
        }

        global Integer compareTo(Object compareTo) {
            SortableWrapper compareToAcc = (SortableWrapper) compareTo;

            Integer returnValue = 0;
            //Have to copy paste code here as there is no way to cast field types dynamically in APEX
            switch on fieldType {
                when 'BOOLEAN' {
                    BooleanComparable origValue = new BooleanComparable(acc.get(this.field));
                    returnValue = origValue.compareTo(compareToAcc.acc.get(this.field)) * direction;
                }
                when 'CURRENCY', 'DOUBLE', 'PERCENT' {
                    DoubleComparable origValue = new DoubleComparable(acc.get(this.field));
                    returnValue = origValue.compareTo(compareToAcc.acc.get(this.field)) * direction;
                }
                when 'DECIMAL' {
                    DecimalComparable origValue = new DecimalComparable(acc.get(this.field));
                    returnValue = origValue.compareTo(compareToAcc.acc.get(this.field)) * direction;
                }
                when 'DATE' {
                    DateComparable origValue = new DateComparable(acc.get(this.field));
                    returnValue = origValue.compareTo(compareToAcc.acc.get(this.field)) * direction;
                }
                when 'DATETIME' {
                    DatetimeComparable origValue = new DatetimeComparable(acc.get(this.field));
                    returnValue = origValue.compareTo(compareToAcc.acc.get(this.field)) * direction;
                }
                when 'INTEGER', 'LONG' {
                    DoubleComparable origValue = new DoubleComparable(acc.get(this.field));
                    returnValue = origValue.compareTo(compareToAcc.acc.get(this.field)) * direction;
                }
                when 'ID', 'EMAIL', 'STRING', 'PHONE', 'PICKLIST', 'REFERENCE' {
                    StringComparable origValue = new StringComparable(acc.get(this.field));
                    returnValue = origValue.compareTo(compareToAcc.acc.get(this.field)) * direction;
                    // TODO: Sort PICKLIST according to order https://www.jitendrazaa.com/blog/salesforce/get-picklist-values-in-apex/
                }
                when 'TIME' {
                    TimeComparable origValue = new TimeComparable(acc.get(this.field));
                    returnValue = origValue.compareTo(compareToAcc.acc.get(this.field)) * direction;  
                }
                when else {
                    System.debug(System.LoggingLevel.WARN, 
                    String.format('UNSUPPORTED_FIELD_TYPE: field "{0}", fieldType "{1}" in SortableWrapper.compareTo().',
                    new List<String> {field, fieldType}));
                }
            }
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

        @InvocableVariable (label='Output Collection')
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
