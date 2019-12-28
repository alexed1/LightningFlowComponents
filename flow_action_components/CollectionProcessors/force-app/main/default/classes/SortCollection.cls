global with sharing class SortCollection {
    @InvocableMethod
    public static List <Results> sort(List<Requests> requestList) {
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
                Map<String, String> fieldTypes = getFieldTypes(outputCollection[0], allFields);

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

        public SObject acc;
        public String field;
        public Integer direction;
        public String fieldType;

        public SortableWrapper(SObject acc, String field, Integer direction, String fieldType) {
            this.acc = acc;
            this.field = field;
            this.direction = direction;
            this.fieldType = fieldType;
        }

        global Integer compareTo(Object compareTo) {
            SortableWrapper compareToAcc = (SortableWrapper) compareTo;

            Integer returnValue = 0;
            //Have to copy paste code here as there is no way to cast field types dynamically in APEX
            if (fieldType == 'STRING') {
                String origValue = String.valueOf(acc.get(this.field));
                String compareToValue = String.valueOf(compareToAcc.acc.get(this.field));
                if (origValue == null && compareToValue == null) {
                    returnValue = 0;
                } else if (origValue == null) {
                    returnValue = -1;
                } else if (compareToValue == null) {
                    returnValue = 1;
                } else {
                    if (origValue > compareToValue) {
                        returnValue = 1 * direction;
                    } else if (origValue < compareToValue) {
                        returnValue = -1 * direction;
                    }
                }
            } else if (fieldType == 'INTEGER' || fieldType == 'DOUBLE') {
                Double origValue = Double.valueOf(acc.get(this.field));
                Double compareToValue = Double.valueOf(compareToAcc.acc.get(this.field));
                if (origValue == null && compareToValue == null) {
                    returnValue = 0;
                } else if (origValue == null) {
                    returnValue = -1;
                } else if (compareToValue == null) {
                    returnValue = 1;
                } else {
                    if (origValue > compareToValue) {
                        returnValue = 1 * direction;
                    } else if (origValue < compareToValue) {
                        returnValue = -1 * direction;
                    }
                }
            }

            return returnValue;
        }
    }

    private static Map<String, String> getFieldTypes(SObject acc, List<String> fieldNames) {
        //Assuming SObject will be replaced with generic SObject
        Schema.SObjectType r = acc.Id.getSObjectType();

        Map<String, String> resultMap = new Map<String, String>();

        DescribeSObjectResult d = r.getDescribe();
        for (String fieldName : fieldNames) {
            resultMap.put(fieldName, d.fields.getMap().get(fieldName).getDescribe().getType().name());
        }

        return resultMap;
    }

    public class Requests {
        @InvocableVariable(required=true)
        public List<SObject> inputCollection;

        @InvocableVariable(required=true)
        public String sortKeys;

    }

    public class Results {

        public Results() {
            outputCollection = new List<SObject>();
        }

        @InvocableVariable
        public List<SObject> outputCollection;
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
}