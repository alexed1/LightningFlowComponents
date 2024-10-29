public with sharing class QueryWithLimit {

    /* Class definition for throwing custom exceptions */
    public class FlowApexActionException extends Exception{}
    
    @InvocableMethod(Label='Query N records [USF Collection Processor]' Description='Returns a list of N records, where is N specified by a user as a flow input.' Category='Util' IconName='resource:CollectionProcessorsSVG:colproc')
    public static List<QueryResults> getNrecords(QueryParameters[] queryParams){

        if (queryParams[0].numberOfRecords >= 50000) {
            throw new FlowApexActionException('You cannot query more than 50000 records.');
        }
        
        List<QueryResults> result = new List<QueryResults>();
        String query = 'SELECT '+ queryParams[0].fieldsToQuery + ' FROM ' +  queryParams[0].objectApiName + ' LIMIT ' + queryParams[0].numberOfRecords;
        try {
            SObject[] recordList = Database.query(query);
            QueryResults qr = new QueryResults();
            qr.records = recordList;
            result.add(qr);
        } catch(Exception e) {
            throw e;
        }
        return result;
    }
    
    /* Input parameters for the Apex action */
    public class QueryParameters{
        @InvocableVariable(Label='Api name of the Object' Required = true )
        public String objectApiName;
        
        @InvocableVariable(Label='API names of the fields to query(Comma separated)' Required = true)
        public String fieldsToQuery;
        
        @InvocableVariable(Label='Number of records to query' Required = true)
        public Integer numberOfRecords;
    }
    
    /* Output parameters of the Apex action */
    public class QueryResults{
        @InvocableVariable(Label='List of records')
	public SObject[] records;
    }
}
