global with sharing class CollectionCalculate {
    @InvocableMethod(label='Collection Calculate [USF Collection Processor]' category='Util' iconName='resource:CollectionProcessorsSVG:colproc')
    global static List <Results> execute(List<Requests> requestList) {
        System.debug('entering CollectionCalculate');
        List<Results> responseWrapper = new List<Results>();
        for (Requests curRequest : requestList) {
            Results response = new Results();
            
            
            
            if (curRequest.operation != null) {
                switch on curRequest.operation.toLowerCase() {
                    when 'multiply' {
                        Decimal startingValue = 1;
                        
                        response.outputDecimalResult = calculate('multiply', startingValue, curRequest);
                      
                    }
                    when 'add' {
                        Decimal startingValue = 0;
                        response.outputDecimalResult = calculate('add', startingValue, curRequest);
                    }
                    when 'average' {
                        Decimal startingValue = 0;
                        response.outputDecimalResult = calculate('average', startingValue, curRequest);
                    }
                    when 'min', 'minimum' {
                        response.outputDecimalResult = min(curRequest.inputCollection, curRequest.fieldName);
                    }
                    when 'max', 'maximum' {
                        response.outputDecimalResult = max(curRequest.inputCollection, curRequest.fieldName);
                    }
                    when 'sum' {
                        response.outputDecimalResult = sum(curRequest.inputCollection, curRequest.fieldName);
                    }
                    when 'count' {
                        response.outputDecimalResult = count(curRequest.inputCollection);
                    }
                    when else {
                        throw new InvocableActionException('You provided an invalid value for the operation input');
                    }
                }
                response.outputStringResult = String.valueOf(response.outputDecimalResult);
    
            }
           
    
        
            responseWrapper.add(response);

        }

       

        return responseWrapper;
    }

    private static Decimal  calculate (string op, Decimal startingValue,  Requests curRequest) {
        List<SObject> inputCollection = curRequest.inputCollection;
        if (inputCollection.size() == 0 || inputCollection == null) {
            throw new InvocableActionException('The CollectionCalculate flow action was provided a collection of records that was either empty or null');
        }
        System.debug('inputCollection is: ' + inputCollection);
        String stringFieldValue;
        Decimal aggregate = startingValue;
        for(Integer x = 0; x< inputCollection.size(); x++) {
            Object rawFieldValue = inputCollection[x].get(curRequest.fieldName);
            System.debug ('x is: ' + x + ' and object is: ' + rawFieldValue);

            
            if (rawFieldValue == null) {
                switch on curRequest.policyForNullAndEmptyFields {
                    when 'use0' {
                        stringFieldValue = '0';
                    }
                    when 'use1' {
                        stringFieldValue ='1';
                    } when else {
                        stringFieldValue = null;
                    }
                } 
                    
                
            } else {
                stringFieldValue = String.valueOf(rawFieldValue);
            }

            System.debug('using this value for stringFieldValue: '+ stringFieldValue);
            if (stringFieldValue == null) {
                throw new InvocableActionException('The CollectionCalculate flow action was provided a collection of records and told to carry out the operation: ' + op + ' on the field: ' + curRequest.fieldName + ' and at least one record had no value. Note that the CollectionCalculate action can be configured in Flow Builder to use the value 0 or 1 for empty fields.');
      
            }
            Decimal decimalFieldValue = decimal.valueOf(stringFieldValue);
            switch on op {
                when 'multiply' {
                    aggregate = aggregate * decimalFieldValue;
                }
                when 'add','average' {
                    aggregate = aggregate + decimalFieldValue;
                }
            }
            
            
            System.debug('current total is: ' + aggregate);
            
        }
        if (op == 'average') {
            aggregate = aggregate/inputCollection.size();
        }
        
        return aggregate;
    }

        // Summary: Method to calculate the sum of a field on a collection of SObjects
    // Input Parameters:
    // - records: Collection of SObjects on which to calculate the sum
    // - fieldName: String representing the field on which to calculate the sum
    // Output: Decimal representing the sum of the field values
    // Created On: 2023-04-14
    // Created By: Andy Haas
    private static Decimal sum(SObject[] records, String fieldName) {
        Decimal sum = 0;
        for (SObject record : records) {
            if (record.get(fieldName) != null && record.get(fieldName) instanceof Decimal) {
                sum += (Decimal) record.get(fieldName);
            }
        }
        return sum;
    }

    // Summary: Method to calculate the count of records in a collection of SObjects
    // Input Parameters:
    // - records: Collection of SObjects on which to calculate the count
    // Output: Integer representing the count of records
    // Created On: 2023-04-14
    // Created By: Andy Haas
    private static Integer count(SObject[] records) {
        return records.size();
    }

    // Summary: Method to calculate the maximum value of a field on a collection of SObjects
    // Input Parameters:
    // - records: Collection of SObjects on which to calculate the maximum
    // - fieldName: String representing the field on which to calculate the maximum
    // Output: Decimal representing the maximum value of the field
    // Created On: 2023-04-14
    // Created By: Andy Haas    
    private static Decimal max(SObject[] records, String fieldName) {
        Decimal max = null;
        for (SObject record : records) {
            if (record.get(fieldName) != null && record.get(fieldName) instanceof Decimal) {
                Decimal fieldValue = (Decimal) record.get(fieldName);
                if (max == null || fieldValue > max) {
                    max = fieldValue;
                }
            }
        }
        return max;
    }

    // Summary: Method to calculate the minimum value of a field on a collection of SObjects
    // Input Parameters:
    // - records: Collection of SObjects on which to calculate the minimum
    // - fieldName: String representing the field on which to calculate the minimum
    // Output: Decimal representing the minimum value of the field
    // Created On: 2023-04-14
    // Created By: Andy Haas
    private static Decimal min(SObject[] records, String fieldName) {
        Decimal min = null;
        for (SObject record : records) {
            if (record.get(fieldName) != null && record.get(fieldName) instanceof Decimal) {
                Decimal fieldValue = (Decimal) record.get(fieldName);
                if (min == null || fieldValue < min) {
                    min = fieldValue;
                }
            }
        }
        return min;
    }

    global class Requests {
        @InvocableVariable(required=true)
        global List<SObject> inputCollection;

        @InvocableVariable(required=true)
        global String fieldName;

        @InvocableVariable(required=true)
        global String operation;

        @InvocableVariable
        global String policyForNullAndEmptyFields;
    }

    global class Results {

        public Results() {
            
        }

        @InvocableVariable
        global Decimal outputDecimalResult;

        @InvocableVariable
        global String outputStringResult;



    }
    public class InvocableActionException extends Exception{}
    
}