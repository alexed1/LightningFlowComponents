public with sharing class GetFlowMetadata {
    @InvocableMethod
    public static List <Result> execute(List<Request> requestList) {
        List<Result> resultList  = new List<Result>();
        Result res = new Result();
        for(Request req : requestList) {
            try {
                List<usf3.MetadataService.Flow > flowList = Test.isRunningTest() ? new List<usf3.MetadataService.Flow >{AnalyzeFlowsTest.genereateFlowForTest1()} : usf3.MetadataUtils.getFlowMetadataFromName(req.flowName);
                System.debug(flowList[0].fullName);
                
                res.flowMetadataJSON = JSON.serialize(flowList[0]);
                res.flowMetadata = flowList[0];
                resultList.add(res);
            } catch(Exception e) {
                res.errors = e.getMessage();
            }
            resultList.add(res);
        }
        return resultList;
    }

    public class Request {
       
        @InvocableVariable(required=true)
        public String flowName;
    }
    public class Result {

        @InvocableVariable
        public String errors;

       
        @InvocableVariable
        public String flowMetadataJSON;

        @InvocableVariable
        public usf3.MetadataService.Flow flowMetadata;

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
