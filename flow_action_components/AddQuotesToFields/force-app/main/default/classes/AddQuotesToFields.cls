global without sharing class AddQuotesToFields {
    global class Input {
        @InvocableVariable(description='Collection of records to transform')
        global List<String> fieldCollection;

        @InvocableVariable(description='Comma separated string of records to transform')
        global String fieldString;

        @InvocableVariable(description='Valid inputs are SINGLE for single quotes or DOUBLE for double quotes; Default value is SINGLE.')
        global String quoteType;
    }

    global class Output {
        @InvocableVariable(description='Collection of records transformed with quotes')
        global List<String> fieldCollection;

        @InvocableVariable(description='Comma separated string of records transformed with quotes')
        global String fieldString;
    }

    @InvocableMethod(description='Add qoutes to each element in a collection')
    global static List<Output> addQuotesToFields(List<Input> inputs) {
        List<Output> outputs = new List<Output>{};
        for (Input input: inputs) {
            if (input.fieldString != null && input.fieldString.length() > 0) {
                input.fieldCollection = input.fieldString.split(',');
            }
            if (input.quoteType == null) {
                input.quoteType = 'SINGLE';
            }
            List<String> transformed = new List<String>{};
            for (String field: input.fieldCollection) {
                if (input.quoteType == 'DOUBLE') {
                    field = '"' + field + '"';
                } else {
                    field = '\'' + field.replace('\'', '\\\'') + '\'';
                }
                transformed.add(field);
            }
            Output output = new Output();
            output.fieldCollection = transformed;
            output.fieldString = String.join(transformed, ',');
            outputs.add(output);
        }
        return outputs;
    }
}