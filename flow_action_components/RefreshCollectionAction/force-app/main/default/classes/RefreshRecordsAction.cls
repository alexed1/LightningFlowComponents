public class RefreshRecordsAction {
    public class RefreshRecordsInput {
        @InvocableVariable
        public List<SObject> values;
    }

    public class RefreshRecordsOutput {
        @InvocableVariable
        public List<SObject> values;

        public RefreshRecordsOutput(List<SObject> results) {
            this.values = results;
        }
    }

    @InvocableMethod(label='Refresh Records')
    public static List<RefreshRecordsOutput> RefreshRecords(List<RefreshRecordsInput> inputs) {
        List<RefreshRecordsOutput> outputs = new List<RefreshRecordsOutput>();
        for (RefreshRecordsInput input : inputs) {
            List<SObject> values = input.values;
            List<string> ids = new List<string>();
            for (SObject o : values) {
                ids.add(o.Id);
            }
            DescribeSObjectResult describe = values.get(0).getSObjectType().getDescribe();
            string queryFor = String.join((Iterable<String>)describe.fields.getMap().keySet(), ',');
    
            String queryString =' SELECT ' + queryFor +' FROM ' + describe.getName() +' WHERE Id in :ids ';
            outputs.add(new RefreshRecordsOutput(Database.query( queryString )));
        }
        return outputs;
    }
}