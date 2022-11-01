public with sharing class GetFlowMetadata {
    @InvocableMethod
    public static List <Result> execute(List<Request> requestList) {
        List<Result> resultList  = new List<Result>();
        for(Request req : requestList) {
            try {
                usf3.MetadataService.MetadataPort service = usf3.MetadataService.createService();

                List<usf3.MetadataService.Flow > flowList =
                (List<usf3.MetadataService.Flow >) service.readMetadata('Flow', new List<String> {req.flowName}).getRecords();

                System.debug(flowList[0].fullName);
                Result res = new Result();
                res.flowMetadataJSON = JSON.serialize(flowList[0]);
                res.flowMetadata = flowList[0];
                resultList.add(res);
            } catch(Exception e) {
                Result res = new Result();
                res.errors = e.getMessage();
                resultList.add(res);
            }
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
