global with sharing class ConvertInstancesToApexObjects {
    @InvocableMethod
    global static List <Results> execute(List<Requests> requestList) {

        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();

        OrchestrationInstanceSet curApexOrchInstances = new OrchestrationInstanceSet();
        response.apexOrchInstances = curApexOrchInstances;
        responseWrapper.add(response);
        return responseWrapper;

    }


    

    global class Requests {

        @InvocableVariable
        global List<FlowOrchestrationInstance> retrievedOrchInstances;
    }

    global class Results {

        @InvocableVariable
        global OrchestrationInstanceSet apexOrchInstances;
    }
}