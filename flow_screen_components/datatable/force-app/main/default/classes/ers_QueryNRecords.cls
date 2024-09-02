/**
 * @description  Get the first 10 records of the selected Object for the Column Wizard running in the datatable CPE<br>
 * Based on a component (QueryNRecords) created by: Narender Singh (ForcePanda)<br>
 * {@link https://forcepanda.wordpress.com/2019/12/24/workaround-for-query-only-first-n-records-in-flows-part-3generic-solution-spring20delight/}
 * @group DataTable
 * @author Eric Smith
 * @since 10/29/20  Version 3.0.0    Initial release along with datatableCPE
 * @exception FlowApexActionException
 */
@SuppressWarnings('PMD.ClassNamingConventions')
public inherited sharing class ers_QueryNRecords {

    private static Boolean SHOW_DEBUG_INFO = false;
    private static String DEBUG_INFO_PREFIX = 'DATATABLE: ';

    /**
     * Class definition for throwing custom exceptions
     */
    public class FlowApexActionException extends Exception {
    }

    @InvocableMethod(
        label='Query N records'
        description='Returns a list of N records, where is N specified by a user as a flow input.'
    )
    public static List<QueryResults> getNrecords(QueryParameters[] queryParams) {
        List<QueryResults> result = new List<QueryResults>();

        for (QueryParameters queryParam : queryParams) {
            if (queryParam.numberOfRecords >= 50000) {
                throw new FlowApexActionException('You cannot query more than 50000 records.');
            }

            string query =
                'Select ' +
                queryParam.fieldsToQuery +
                ' FROM ' +
                queryParam.objectApiName +
                ' LIMIT ' +
                queryParam.numberOfRecords;
            System.debug(DEBUG_INFO_PREFIX + 'QUERY: ' + query);
            try {
                sObject[] recordList = database.query(query); //NOPMD
                if (SHOW_DEBUG_INFO) {
                    System.debug(DEBUG_INFO_PREFIX + 'Record List:' + recordList);
                }

                // Make sure there are the requested # of records
                if (!recordList.isEmpty() && recordList.size() < 10) {
                    for (Integer i = recordList.size(); i < queryParam.numberOfRecords; i++) {
                        recordList.add(recordList[0]);
                    }
                }
                System.debug(DEBUG_INFO_PREFIX + 'Number of Records: ' + recordList.size());

                // Include null fields in the serialized result
                List<Map<String, Object>> records = new List<Map<String, Object>>();
                for (SObject so : recordList) {
                    Map<String, Object> rec = new Map<String, Object>();
                    for (
                        SObjectField f : ((SObject) (Type.forName(
                                    'Schema.' + queryParam.objectApiName
                                )
                                .newInstance()))
                            .getSObjectType()
                            .getdescribe()
                            .fields.getmap()
                            .values()
                    ) {
                        if ((queryParam.fieldsToQuery + ',Id').contains(String.valueOf(f))) {
                            try {
                                rec.put(String.valueOf(f), so.get(f));
                            } catch (Exception e) {
                                rec.put(String.valueOf(f), null);
                            }
                        }
                    }
                    records.add(rec);
                }

                QueryResults qr = new QueryResults();
                qr.recordString = JSON.serialize(records);
                // qr.recordString = JSON.serialize(recordList);
                result.add(qr);
            } catch (Exception e) {
                System.debug(DEBUG_INFO_PREFIX + 'ers_QueryNRecords Error: ' + e);
                throw e;
            }
        }
        return result;
    }

    /**
     * Input parameters for the Apex action
     */
    public class QueryParameters {
        @InvocableVariable(label='Api name of the Object' required=true)
        public string objectApiName;

        @InvocableVariable(label='API names of the fields to query(Comma separated)' required=true)
        public string fieldsToQuery;

        @InvocableVariable(label='Number of records to query' required=true)
        public integer numberOfRecords;
    }

    /**
     * Output parameters of the Apex action
     */
    public class QueryResults {
        @InvocableVariable(label='List of records')
        public string recordString;
    }
}