/**
 * @description       : Dedupe a collection of sobjects the easy way
 * @author            : agentgill
 * @group             : Flow Action (Invocable Method)
 * @last modified on  : 09-01-2020
 * @last modified by  : agentgill
 * Modifications Log
 * Ver   Date         Author      Modification
 * 1.0   08-28-2020   agentgill   Initial Version
 **/
public with sharing class DedupeSObjectCollectionInvocable {
    @InvocableMethod(label='Dedupe collection')
    public static List<Results> dedupe(List<Requests> requests) {
        List<Results> results = new List<Results>();
        Results result = new Results();
        Map<Id, sobject> uniqueSobject = new Map<Id, sObject>();
        for (Requests request : requests) {
            List<SObject> inputCollection = request.inputCollection;

            uniqueSobject.putAll(inputCollection);
        }
        result.outputCollection = uniqueSobject.values();
        results.add(result);
        return results;
    }

    public class Requests {
        @InvocableVariable(required=true)
        public List<SObject> inputCollection;
    }

    public class Results {
        public Results() {
            outputCollection = new List<SObject>();
        }

        @InvocableVariable
        public List<SObject> outputCollection;
    }
}
