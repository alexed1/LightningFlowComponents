global class SObjectAggregateCalculator {
    // Summary: Method to calculate aggregate value based on action and field name
    // Input Parameters:
    // - records: Collection of SObjects on which to perform the aggregate calculation
    // - action: String representing the type of aggregate calculation to perform (SUM, COUNT, AVERAGE, MAX, MIN)
    // - fieldName: String representing the field on which to perform the aggregate calculation
    // Output: Decimal representing the result of the aggregate calculation
    // Created On: 2023-04-14
    // Created By: Andy Haas
    @InvocableMethod
    global static List <Results>calculate(List<Requests> requestList) {
        // Create Wrapper class to hold the results
        List<Results> results = new List<Results>();

        // Iterate through the requests
        for ( Requests request : requestList ) {
            // Create a new result object
            Results result = new Results();
            
            if (request.inputCollection != null && request.inputCollection.size() > 0 && request.action != null && request.fieldName != null) {
                switch on request.action.toLowerCase() {
                    when 'sum' {
                        result.result = sum(request.inputCollection, request.fieldName);
                    }
                    when 'count' {
                        result.result = count(request.inputCollection);
                    }
                    when 'average' {
                        result.result = average(request.inputCollection, request.fieldName);
                    }
                    when 'max' {
                        result.result = max(request.inputCollection, request.fieldName);
                    }
                    when 'min' {
                        result.result = min(request.inputCollection, request.fieldName);
                    }
                    when else {
                        // Handle unsupported action
                        result.result = null;
                    }
                }
            }
            // Add the result to the results list
            results.add(result);
        }

        // Return the results
        return results;
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

    // Summary: Method to calculate the average of a field on a collection of SObjects
    // Input Parameters:
    // - records: Collection of SObjects on which to calculate the average
    // - fieldName: String representing the field on which to calculate the average
    // Output: Decimal representing the average of the field values
    // Created On: 2023-04-14
    // Created By: Andy Haas
    private static Decimal average(SObject[] records, String fieldName) {
        Decimal sum = sum(records, fieldName);
        Integer count = count(records);
        return count > 0 ? sum.divide(count, 2) : 0;
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
        global String action;
        @InvocableVariable(required=true)
        global String fieldName;
    }

    global class Results {
        @InvocableVariable
        global Decimal result;
    }
}