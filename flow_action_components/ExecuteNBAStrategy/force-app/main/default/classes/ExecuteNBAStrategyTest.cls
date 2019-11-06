@IsTest(SeeAllData=true)
private class ExecuteNBAStrategyTest {
    static final String TEST_STRING = 'Random Test String';
    static final String ACCEPT_LABEL = 'Accepted';
    static final String REJECT_LABEL = 'Rejected';
    static final String FLOW_API_NAME = 'AcceptFlow1';
    static final String STRATEGY_NAME = 'TestStrat1';

    @IsTest
    static void ExecuteNBAStrategyTest() {
        Account acc = new Account(Name = TEST_STRING);
        insert acc;
        Recommendation rec = new Recommendation(AcceptanceLabel = ACCEPT_LABEL, ActionReference = FLOW_API_NAME, Description = TEST_STRING, Name = TEST_STRING, RejectionLabel = REJECT_LABEL);
        insert rec;
        Test.startTest();
        List<ExecuteNBAStrategy.Requests> requests = new List<ExecuteNBAStrategy.Requests>();
        ExecuteNBAStrategy.Requests request = new ExecuteNBAStrategy.Requests();
        request.contextRecordId = acc.Id;
        request.strategyName = STRATEGY_NAME;
        request.maxResults = 25;
        requests.add(request);
        List<ExecuteNBAStrategy.Results> results = ExecuteNBAStrategy.ExecuteNBAStrategy(requests);
        ExecuteNBAStrategy.setRecommendationReaction(acc.Id, ACCEPT_LABEL, STRATEGY_NAME, JSON.serialize(results[0].curRecs.recommendations[0]));
        ExecuteNBAStrategy.setRecommendationReaction(acc.Id, REJECT_LABEL, STRATEGY_NAME, JSON.serialize(results[0].curRecs.recommendations[0]));
        Test.stopTest();
    }

    @IsTest
    static void AutolaunchFlowTest() {
        List<AutolaunchFlow.Requests> requests = new List<AutolaunchFlow.Requests>();
        AutolaunchFlow.Requests request = new AutolaunchFlow.Requests();
        request.flowName = FLOW_API_NAME;
        requests.add(request);
        Test.startTest();
        AutolaunchFlow.autolaunchFlow(requests);
        Test.stopTest();
    }
}