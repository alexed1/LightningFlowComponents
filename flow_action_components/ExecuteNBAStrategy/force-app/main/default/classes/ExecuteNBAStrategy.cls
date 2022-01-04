public with sharing class ExecuteNBAStrategy {
    static final String DUMMY_FLOW_API_NAME = 'Flow_Based_Strategy';
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
        response.recCount = curApexDefinedRecList.recommendations.size();

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

        @InvocableVariable
        public Integer recCount;

    }

    @AuraEnabled
    public static List<Recommendation> executeNBAFlow(String strategyName, String contextRecordId, Integer maxResults) {
        Flow.Interview curInterview = Flow.Interview.createInterview(strategyName, new Map<String,Object>{'recordId' =>contextRecordId });
        curInterview.start();
        System.debug(curInterview.getVariableValue('outputRecommendations'));
        return (List<Recommendation>)curInterview.getVariableValue('outputRecommendations');
    }



    @AuraEnabled
    public static string launchFLow(Recommendation rec, String strategyName, String contextRecordId){
        List<FlowDefinitionView> flowDefList = [SELECT Id, ProcessType, TriggerType, ApiName FROM FlowDefinitionView WHERE apiName = :rec.ActionReference];
        if(flowDefList.size() > 0) {
            if( flowDefList[0].ProcessType == 'AutoLaunchedFlow') {
                Flow.Interview curInterview = Flow.Interview.createInterview(rec.ActionReference, new Map<String, Object>{
                    'recordId' => rec.ExternalId,
                    'strategyName' => strategyName,
                    'userId' => UserInfo.getUserId(),
                    'recommendationName' => rec.Name
                });
                curInterview.start();
            }
            //a limitation in the recordation interface means that a strategyName is still required 
            //to record a reaction even if the recommendation was generated by a flow and not a legacy-style strategy. 
            //Use any string that matches an existing strategy (the strategy won't be run and doesn't have to do anything)
            ConnectApi.RecommendationReactionInput reactionInput = new ConnectApi.RecommendationReactionInput();
            reactionInput.strategyName = DUMMY_FLOW_API_NAME;
            reactionInput.targetActionName = rec.ActionReference;
            reactionInput.targetId =  rec.ExternalId;
            reactionInput.contextRecordId = contextRecordId;
            reactionInput.reactionType = ConnectApi.RecommendationReactionType.Accepted;
            ConnectApi.RecommendationReaction reactionResult = ConnectApi.NextBestAction.setRecommendationReaction(reactionInput);

            return flowDefList[0].ProcessType;
        } else {
            throw new AuraHandledException ('Incorrect flow ame : ' + rec.ActionReference);
        }
    }

}