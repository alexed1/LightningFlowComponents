public class QueryNRecords {

    /**
     * Based on a component (QueryNRecords) created by: Narender Singh (ForcePanda)
     * https://forcepanda.wordpress.com/2019/12/24/workaround-for-query-only-first-n-records-in-flows-part-3generic-solution-spring20delight/
     *
     * Description:     QueryNRecords
     *                  Get the first 10 records of the selected Object for the Column Wizard running in the datatable CPE
     *
     * 10/29/20 -       Eric Smith -    Version 3.0.0    Initial release along with datatableCPE
     *
     **/ 
    
    /* Class definition for throwing custom exceptions */
    public class FlowApexActionException extends Exception{}
    
    @InvocableMethod(label='Query N records' description='Returns a list of N records, where is N specified by a user as a flow input.')
    public static List<QueryResults> getNrecords(QueryParameters[] queryParams) {
        
        List<QueryResults> result = new List<QueryResults>();

        for (QueryParameters queryParam : queryParams) {
            if (queryParam.numberOfRecords >= 50000)
                throw new FlowApexActionException('You cannot query more than 50000 records.');

            string query = 'Select '+ queryParam.fieldsToQuery + ' FROM ' +  queryParam.objectApiName + ' LIMIT ' + queryParam.numberOfRecords;
            system.debug('QUERY: '+query);
            try {

                sObject[] recordList = database.query(query);
                system.debug(recordList);

                // Make sure there are the requested # of records
                if (!recordList.isEmpty() && recordList.size() < 10) {
                    for (Integer i = recordList.size(); i < queryParam.numberOfRecords; i++) { 
                        recordList.add(recordList[0]);
                    }
                }
                system.debug('Number of Records: ' + recordList.size());

                // Include null fields in the serialized result
                List<Map<String, Object>> records = new List<Map<String, Object>> ();
                for (SObject so : recordList) { 
                    Map<String, Object> rec = new Map<String, Object> ();
                    for (SObjectField f : ((SObject)(Type.forName('Schema.'+queryParam.objectApiName).newInstance())).getSObjectType().getdescribe().fields.getmap().values()) {
                        if ((queryParam.fieldsToQuery + ',Id').contains(String.valueOf(f))) {
                            try {rec.put(String.valueOf(f), so.get(f));}
                            catch(Exception e) {rec.put(String.valueOf(f), null);}
                        }
                    }
                    records.add(rec);
                }

                QueryResults qr = new QueryResults();
                qr.recordString = JSON.serialize(records);
                // qr.recordString = JSON.serialize(recordList);
                result.add(qr);

            } catch(Exception e) {
                throw e;
            }
        }
        return result;
    }
    
    /* Input parameters for the Apex action */
    public class QueryParameters{
        @InvocableVariable(label='Api name of the Object' required = true )
        public string objectApiName;
        
        @InvocableVariable(label='API names of the fields to query(Comma separated)' required = true)
        public string fieldsToQuery;
        
        @InvocableVariable(label='Number of records to query' required = true)
        public integer numberOfRecords;
    }
    
    /* Output parameters of the Apex action */
    public class QueryResults{
        @InvocableVariable(label='List of records')
        public string recordString;        
    }

}
