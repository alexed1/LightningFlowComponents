/**
 * @description       : Tests DedupeSObjectCollectionInvocable Class
 * @author            : agentgill
 * @group             :
 * @last modified on  : 09-01-2020
 * @last modified by  : agentgill
 * Modifications Log
 * Ver   Date         Author      Modification
 * 1.0   08-28-2020   agentgill   Initial Version
 **/
@isTest
public with sharing class DedupeSObjectCollectionInvocableTest {
    @istest
    public static void testDedupe() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'User',
            Company = 'Test Company'
        );
        insert testLead;
        List<sObject> sobjectList = new List<sObject>();
        sobjectList.add(testLead);
        sobjectList.add(testLead);
        System.assertEquals(2, sobjectList.size(), 'Something went wrong');

        List<DedupeSObjectCollectionInvocable.Requests> requestList = new List<DedupeSObjectCollectionInvocable.Requests>();
        DedupeSObjectCollectionInvocable.Requests request = new DedupeSObjectCollectionInvocable.Requests();
        request.inputCollection = sobjectList;
        requestList.add(request);
        List<DedupeSObjectCollectionInvocable.Results> results = new List<DedupeSObjectCollectionInvocable.Results>();

        Test.startTest();
        results = DedupeSObjectCollectionInvocable.dedupe(requestList);
        Test.stopTest();

        System.assertEquals(
            1,
            results[0].outputCollection.size(),
            'Something went wrong'
        );
    }
}
