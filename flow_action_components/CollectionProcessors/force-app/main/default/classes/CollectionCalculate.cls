global with sharing class CollectionCalculate {
    @InvocableMethod
    global static List <Results> execute(List<Requests> requestList) {
        System.debug('entering CollectionCalculate');
        List<Results> responseWrapper = new List<Results>();
        for (Requests curRequest : requestList) {
            Results response = new Results();
            
            
            
            if (curRequest.operation != null) {
                switch on curRequest.operation {
                    when 'Multiply' {
                        Decimal startingValue = 1;
                        
                        response.outputDecimalResult = calculate('multiply', startingValue, curRequest);
                      
                    }
                    when 'Add','add' {
                        Decimal startingValue = 0;
                        response.outputDecimalResult = calculate('add', startingValue, curRequest);
                    }
                    when 'average','Average' {
                        Decimal startingValue = 0;
                        response.outputDecimalResult = calculate('average', startingValue, curRequest);
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