@isTest
public with sharing class GenerateReportFromFlowAnalysisTest {
    @isTest
    static void testGenerateReport() {
        AnalyzeFlows.Request request = new AnalyzeFlows.Request();

        request.initFlow = JSON.serialize( AnalyzeFlowsTest.genereateFlowForTest1());
        request.secondFlow = JSON.serialize(AnalyzeFlowsTest.genereateFlowForTest2());
        request.analyticalModulenames = 'DetectElementModifications,DetectMissingElements,DetectNewElements';
        

        AnalyzeFlows.Result result = AnalyzeFlows.execute(new List<AnalyzeFlows.Request>{request})[0];
        System.assert(String.isEmpty(result.errors));
        System.debug(result);

        
        GenerateReportFromFlowAnalysis.Requests reportRequest = new GenerateReportFromFlowAnalysis.Requests();
        reportRequest.inputCollection = result.analysisResults;
        GenerateReportFromFlowAnalysis.Results reportResults = GenerateReportFromFlowAnalysis.generateReport(new List< GenerateReportFromFlowAnalysis.Requests>{reportRequest})[0];
        System.assert(String.isNotEmpty(reportResults.reportString));
    }
}
