global with sharing class FilterCollection {
    @InvocableMethod
    global static List <Results> filter(List<Requests> requestList) {


        List<Results> responseWrapper = new List<Results>();
        for (Requests curRequest : requestList) {
            String formulaString = curRequest.formula;
            List<SObject> inputCollection = curRequest.inputCollection;
            List<SObject> outputCollection = new List<SObject>();
    
            //for each member of the inputCollection, call the FormulaEvaluator.parseFormua method, which
            //will return true if the formula is true for this member
            //the FormulaEvaluator will use the recordId of the current member as context, replacing expressions in the 
            //formula string of the form $Record.fieldname. For example, if the formula is '$Record.Age__c > 21' and the input Collection
            //is a collection of Student__c, the evaluator will take the current student's ID, retrieve the record, and look for a field 'Student__c.Age__c' 
            //This package includes an expressionBuilder flow screen component that can be added to flows that are used to generate formula strings. These strings are
            //usually generated in a separate 'management' flow from the runtime flow that does this filtering.
            if (inputCollection != null && !inputCollection.isEmpty()) {
                for (SObject member : inputCollection) {

                    List<usf.FormulaEvaluator.ContextWrapper> context = new List<usf.FormulaEvaluator.ContextWrapper>();
                    context.add(new usf.FormulaEvaluator.ContextWrapper('$Record', member.Id));
                    String stringContext = JSON.serialize(context);
                    String result = usf.FormulaEvaluator.parseFormula(formulaString, stringContext);

                    if (result == 'true') {
                        outputCollection.add(member);
                    }
                }
            }
    
            Results response = new Results();
            response.outputCollection = outputCollection;
            responseWrapper.add(response);
        }
        

        return responseWrapper;

    }

    global class Requests {
        @InvocableVariable(required=true)
        global List<SObject> inputCollection;

        @InvocableVariable
        global String formula;

    }

    global class Results {

        public Results() {
            outputCollection = new List<SObject>();
        }

        @InvocableVariable
        global String errors;

        @InvocableVariable
        global List<SObject> outputCollection;
    }
}