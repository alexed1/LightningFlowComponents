/**
 * @description       : Tests GetFieldSetValues which pairs with ExecuteSOQL or RecordDetailFSC (or other actions) and returns a Text Collection or Comma-Separated String of fields contained in an object's Field Set. Useful
 * For abstracting values out of the Flow so that it can be extended with minimal edits to the Flow.
 * @author            : Adam White
 * @last modified on  : 11-03-2020
 * Modifications Log 
 * Ver   Date         Author                              							 Modification
 * 1.0   11-02-2020   Adam White, https://www.linkedin.com/in/declarativeninja/   Initial Version
**/
@isTest
public class GetFieldSetValuesTests {
    @isTest
    public static void testFieldSetValues() {   
        List<GetFieldSetValues.Requests> requestList = new List<GetFieldSetValues.Requests>();
        GetFieldSetValues.Requests request = new GetFieldSetValues.Requests();
        request.fieldSetName = 'SampleSet';
        request.objectName = 'Account';
        requestList.add(request);
        
        List<GetFieldSetValues.Results> responseWrapper = GetFieldSetValues.getFieldSetVals(requestList);
        
        System.assert(responseWrapper[0].fieldSetValueCollection.size() > 0, 'Field set not greater than 0');

	}
}
