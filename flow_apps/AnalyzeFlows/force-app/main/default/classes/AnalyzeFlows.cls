public with sharing class AnalyzeFlows {
    static final String DETECTED_NEW_ELEMENTS = 'DetectNewElements';
    static final String DETECTED_REMOVED_ELEMENTS = 'DetectRemovedElements';
    static final String DETECTED_ELEMENTS_MODIFICATIONS= 'DetectElementModifications';

    @InvocableMethod
    public static List <Result> execute(List<Request> requestList) {
        List<Result> resultList  = new List<Result>();
        for(Request req : requestList) {
            try {
                MetadataService.Flow initFlow = (MetadataService.Flow)JSON.deserialize(req.initFlow, MetadataService.Flow.class);
                MetadataService.Flow secondFlow = (MetadataService.Flow)JSON.deserialize(req.secondFlow, MetadataService.Flow.class);
                System.debug(initFlow);
                System.debug(secondFlow);
                Result res = new Result();
                res.analysisResults = new List<FlowAnalysis>();
                if(req.analyticalModulenames.contains(DETECTED_NEW_ELEMENTS)) {
                    res.analysisResults.add(MainAnalysis_DetectNewFlowEntities.detectNewFlowEntities(initFlow, secondFlow));
                }

                if(req.analyticalModulenames.contains(DETECTED_REMOVED_ELEMENTS)) {
                    res.analysisResults.add(MainAnalysis_DetectRemovedFlowEntities.detectRemovedFlowEntities(initFlow, secondFlow));
                }

                if(req.analyticalModulenames.contains(DETECTED_ELEMENTS_MODIFICATIONS)) {
                    FlowAnalysis report = MainAnalysis_GetRecords.analyzeGetRecords(initFlow, secondFlow);
                    report.elementChanges.addAll(MainAnalysis_UpdateRecords.analyzeCreateRecords(initFlow, secondFlow).elementChanges);
                    report.elementChanges.addAll(MainAnalysis_DeleteRecords.analyzeDeleteRecords(initFlow, secondFlow).elementChanges);
                    report.elementChanges.addAll(MainAnalysis_CreateRecords.analyzeCreateRecords(initFlow, secondFlow).elementChanges);
                    res.analysisResults.add(report);
                }
                resultList.add(res);
            } catch(Exception e) {
                Result res = new Result();
                res.errors = e.getMessage() + ' ' + e.getStackTraceString();
                resultList.add(res);
            }
        }
        return resultList;
    }

    public class Request {
       
        @InvocableVariable(required=true)
        public String initFlow;

        @InvocableVariable
        public String secondFlow;

        @InvocableVariable(required=true)
        public String analyticalModulenames;

    }
    public class Result {

        @InvocableVariable
        public List<FlowAnalysis> analysisResults = new List<FlowAnalysis>();

        @InvocableVariable
        public String errors;

    }

    public class WaitElementsWrapper{
        public String schName;
        public String label;
        public String connector;
        public String offsetNumber;
        public String offsetUnit;
        public String recordField; 
    }
}
