public class RefreshRecords {
    public class Request {
        @InvocableVariable
        public List<SObject> inputCollection;
    }

    public class Response {
        @InvocableVariable
        public List<SObject> refreshedCollection;

        public Response(List<SObject> results) {
            this.refreshedCollection = results;
        }
    }

    @InvocableMethod(label='Refresh Records')
    public static List<Response> RefreshRecords(List<Request> inputs) {
        List<Response> outputs = new List<Response>();
        for (Request input : inputs) {
            List<SObject> values = input.inputCollection;
            List<string> ids = new List<string>();
            for (SObject o : values) {
                ids.add(o.Id);
            }
            DescribeSObjectResult describe = values.get(0).getSObjectType().getDescribe();
            string queryFor = String.join((Iterable<String>)describe.fields.getMap().keySet(), ',');
    
            String queryString =' SELECT ' + queryFor +' FROM ' + describe.getName() +' WHERE Id in :ids ';
            outputs.add(new Response(Database.query( queryString )));
        }
        return outputs;
    }
}