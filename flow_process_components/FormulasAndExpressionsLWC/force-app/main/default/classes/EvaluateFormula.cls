public with sharing class EvaluateFormula {

    @InvocableMethod
    public static List <Results> evaluate(List<Requests> requestList) {
        System.debug('entering Evaluate Formula');

        String formulaString = requestList[0].formulaString;
        String recordId = requestList[0].recordId;
        String contextDataString = JSON.serialize(generateContextByRecordId(recordId));

        String result = FormulaEvaluator.parseFormula(formulaString, contextDataString);
        //TO DO: need to fix this to return non-integer values effectively. we may need to pass in an indicator as to what
        //what the input type is

        //Create a Results object to hold the return values
        Results response = new Results();
        response.stringResult = result;

        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);
        System.debug('response is: ' + response);
        System.debug('responseWrapper is: ' + responseWrapper);

        return responseWrapper;

    }

    private static List<FormulaEvaluator.ContextWrapper> generateContextByRecordId(String recordId) {
        List<FormulaEvaluator.ContextWrapper> context = new List<FormulaEvaluator.ContextWrapper>();
        if(!String.isBlank(recordId)){
            context.add(new FormulaEvaluator.ContextWrapper('$Record', recordId));
        }
        return context;
    }

    public class Requests {

        @InvocableVariable
        public String formulaString;

        @InvocableVariable
        public String recordId;

    }

    public class Results {


        @InvocableVariable
        public String stringResult;

        @InvocableVariable
        public Decimal numberResult;


    }
}