public with sharing class ExecuteNBAStrategy {

    @InvocableMethod
    public static List<Results> ExecuteNBAStrategy(List<Requests> requests) {
        String contextRecordId = requests[0].contextRecordId;
        Integer maxResults = requests[0].maxResults;
        String strategyName = requests[0].strategyName;

        ConnectApi.NBARecommendations curRecs = ConnectApi.NextBestAction.executeStrategy(strategyName, maxResults, contextRecordId, true);
        System.debug('trace is: ' + curRecs.trace);
        NBARecommendationsList curApexDefinedRecList = MapToApexDefinedRecList(curRecs);
        //Create a Results object to hold the return values
        Results response = new Results();

        //add the return values to the Results object
        response.curRecs = curApexDefinedRecList;

        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;

    }

    //Flow can't directly 'see' the ConnectApi datastructure that gets returned by the NBA Engine.ApexPages
    //However, using Apex-Defined Types, we can easily transform the data into something Flow can use.
    //See https://unofficialsf.com/part-1-manipulate-complex-internet-data-in-flow-without-code/
    public static NBARecommendationsList MapToApexDefinedRecList(ConnectApi.NBARecommendations returnedRecResponse) {
        NBARecommendationsList curApexDefinedRecList = new NBARecommendationsList();

        curApexDefinedRecList.recommendations = MapToFlowVisibleRecommendations(returnedRecResponse.recommendations);
        //curApexDefinedRecList.errors = returnedRecResponse.errors;
        curApexDefinedRecList.executionId = returnedRecResponse.executionId;
        curApexDefinedRecList.onBehalfOfId = returnedRecResponse.onBehalfOfId;
        //curApexDefinedRecList.debug = returnedRecResponse.debug;

        return curApexDefinedRecList;
    }

    //this flow-visible apex-defined type combines several nested connectAPI objects for simplicity
    public static List<NBARecommendation> MapToFlowVisibleRecommendations(List<ConnectApi.NBARecommendation> allReturnedRecs) {
        List<NBARecommendation> flowVisibleRecommendations = new List<NBARecommendation>();
        for (ConnectApi.NBARecommendation curReturnedRec : allReturnedRecs) {

            NBARecommendation flowVisibleRec = new NBARecommendation();
            flowVisibleRec.acceptanceLabel = curReturnedRec.acceptanceLabel;
            flowVisibleRec.externalId = curReturnedRec.externalId;
            flowVisibleRec.description = curReturnedRec.description;
            flowVisibleRec.rejectionLabel = curReturnedRec.rejectionLabel;

            flowVisibleRec.name = ((ConnectApi.NBANativeRecommendation) curReturnedRec.target).name;
            flowVisibleRec.url = ((ConnectApi.NBANativeRecommendation) curReturnedRec.target).url;
            flowVisibleRec.Id = ((ConnectApi.NBANativeRecommendation) curReturnedRec.target).id;
            flowVisibleRec.acceptFlowName = ((ConnectApi.NBAFlowAction) curReturnedRec.targetAction).name; //flowLabel is a mistake in the api. should be apiname
            flowVisibleRec.acceptFlowType = ((ConnectApi.NBAFlowAction) curReturnedRec.targetAction).flowType.name(); //flowLabel is a mistake in the api. should be apiname

            List<ConnectApi.NBAActionParameter> myListofParams = new List<ConnectApi.NBAActionParameter>();
            myListofParams = ((ConnectApi.NBAFlowAction) curReturnedRec.targetAction).parameters;
            flowVisibleRec.params = MapToFlowVisibleParams(myListofParams);
            flowVisibleRecommendations.add(flowVisibleRec);
        }
        return flowVisibleRecommendations;
    }

    public static List<FlowParameter> MapToFlowVisibleParams(List<ConnectApi.NBAActionParameter> myListofParams) {
        List<FlowParameter> flowVisibleParams = new List<FlowParameter>();
        for (ConnectApi.NBAActionParameter returnedParam : myListofParams) {
            FlowParameter flowVisibleParam = new FlowParameter();
            flowVisibleParam.name = returnedParam.name;
            flowVisibleParam.value = returnedParam.value;
            flowVisibleParam.type = returnedParam.type;
            flowVisibleParams.add(flowVisibleParam);
        }
        return flowVisibleParams;
    }

    @AuraEnabled
    public static void setRecommendationReaction(Id recordId, String reaction, String strategyName, String recommendation) {
        NBARecommendation curRecommendation = (NBARecommendation) JSON.deserialize(recommendation, NBARecommendation.class);

        ConnectApi.RecommendationReactionInput reactionInput = new ConnectApi.RecommendationReactionInput();
        reactionInput.strategyName = strategyName;
        reactionInput.targetActionName = curRecommendation.acceptFlowName;
        reactionInput.targetId = curRecommendation.Id;
        reactionInput.contextRecordId = recordId;
        if (reaction == 'Accepted') {
            reactionInput.reactionType = ConnectApi.RecommendationReactionType.Accepted;
            if (curRecommendation.acceptFlowType == 'AutoLaunchedFlow') {
                Flow.Interview curInterview = Flow.Interview.createInterview(curRecommendation.acceptFlowName, new Map<String, Object>{
                        'recordId' => recordId,
                        'strategyName' => strategyName,
                        'userId' => UserInfo.getUserId(),
                        'recommendationName' => curRecommendation.name
                });
                curInterview.start();
            }
        } else {
            reactionInput.reactionType = ConnectApi.RecommendationReactionType.Rejected;
        }

        ConnectApi.RecommendationReaction reactionResult = ConnectApi.NextBestAction.setRecommendationReaction(reactionInput);

    }


    public class InvocableErrorException extends Exception {
    }


    public class Requests {

        @InvocableVariable
        public String contextRecordId;

        @InvocableVariable
        public String strategyName;

        @InvocableVariable
        public Integer maxResults;
    }

    public class Results {

        @InvocableVariable
        public NBARecommendationsList curRecs;

    }

}