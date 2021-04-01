@isTest
public inherited sharing class GetRecordsFromIdsTest {

    @isTest
    public static void CanGetRecordsFromIds() {
        

        GetRecordsFromIds.Request curRequest = new GetRecordsFromIds.Request();
        curRequest.objectName = 'AccountTeamMember';
        curRequest.fieldNames = 'Id,Name';
        curRequest.inputIds = new List<String>();
        curRequest.inputIds.add('4o4M4o4M');
        curRequest.inputIds.add('j34k4o4M');
        
        List<GetRecordsFromIds.Request> curRequests = new List<GetRecordsFromIds.Request>();
        curRequests.add(curRequest);
        List<GetRecordsFromIds.Result> curResponses = GetRecordsFromIds.execute(curRequests);
        System.debug('curResponses is:' + curResponses);
        System.assertEquals(curResponses[0].records, null);
    }
    
}