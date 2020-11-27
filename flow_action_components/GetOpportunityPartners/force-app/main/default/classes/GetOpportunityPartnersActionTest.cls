/**
* @author       : Tamar Erlich
* @date         : October 07, 2020
* @description  : Test class for GetOpportunityPartnersAction Invocable method
* Note          :
* *************************************************
*       <runTest>GetOpportunityPartnersActionTest<runTest>
* *************************************************
* @History
* -------
* VERSION | AUTHOR                | DATE               | DESCRIPTION
* 1.0     | Tamar Erlich          | October 07, 2020   | created
**/
@IsTest
public with sharing class GetOpportunityPartnersActionTest {


    @isTest
    public static void opportunityPartnersFound(){

        // initialize variables
        List<GetOpportunityPartnersAction.Requests> requestList = new List<GetOpportunityPartnersAction.Requests>();
        String accountId;
        String opportunityId;

        // create test account
        List<Account> accounts = new List<Account>();

        for (Integer j = 0; j < 1; j++) {

            Account a = new Account(
                Name = 'email' + j + '.com'
                );

            accounts.add(a);
        }
        
        insert accounts;

        // create test opportunity
        Date closeDate = System.today();
        Opportunity testOpp;

        testOpp = new Opportunity(
            Name = 'test opp',
            StageName = 'Open In-Progress',
            Amount = 100,
            CloseDate = closeDate
        );
        insert testOpp;

        accountId = accounts[0].Id;
        opportunityId = testOpp.Id;

        // create test opportunity partner
        OpportunityPartner testPartner;
        testPartner = new OpportunityPartner(
            OpportunityId = opportunityId,
            AccountToId = accountId,
            Role = 'Dealer',
            IsPrimary = false
        );
        insert testPartner;

        // prepare request for GetOpportunityPartnersAction
        GetOpportunityPartnersAction.Requests request = new GetOpportunityPartnersAction.Requests();
        request.accountId = accountId;
        request.opportunityId = opportunityId;
        requestList.add(request);

        // run test and assert results
        List <GetOpportunityPartnersAction.Results> results = GetOpportunityPartnersAction.get(requestList);
        System.assertEquals(results[0].errors, null,'Errors not expected');
        System.assertNotEquals(results[0].successful, 'false', 'Success expected');
        System.assertEquals(true, !String.isEmpty(results[0].outputString), 'Opportunity Partners expected');
    }

    @isTest
    public static void opportunityPartnersNotFound(){


        // initialize variables
        List<GetOpportunityPartnersAction.Requests> requestList = new List<GetOpportunityPartnersAction.Requests>();
        String accountId;
        String opportunityId;

        // create test account
        List<Account> accounts = new List<Account>();

        for (Integer j = 0; j < 1; j++) {

            Account a = new Account(
                Name = 'email' + j + '.com'
                );

            accounts.add(a);
        }
        
        insert accounts;

        // create test opportunity
        Date closeDate = System.today();
        Opportunity testOpp;

        testOpp = new Opportunity(
            Name = 'test opp',
            StageName = 'Open In-Progress',
            Amount = 100,
            CloseDate = closeDate
        );
        insert testOpp;

        accountId = accounts[0].Id;
        opportunityId = testOpp.Id;

        // prepare request for GetOpportunityPartnersAction
        GetOpportunityPartnersAction.Requests request = new GetOpportunityPartnersAction.Requests();
        request.accountId = accountId;
        request.opportunityId = opportunityId;
        requestList.add(request);

        // run test and assert results
        List <GetOpportunityPartnersAction.Results> results = GetOpportunityPartnersAction.get(requestList);
        System.assertEquals(results[0].errors, null,'Errors not expected');
        System.assertEquals(false, results[0].outputCollection.size()>0, 'Opportunity Partners not expected');

    }

    @isTest
    public static void noAccountOrOpportunity(){

        // initialize variables
        List<GetOpportunityPartnersAction.Requests> requestList = new List<GetOpportunityPartnersAction.Requests>();
        String accountId = null;
        String opportunityId = null;

        // prepare request for GetOpportunityPartnersAction
        GetOpportunityPartnersAction.Requests request = new GetOpportunityPartnersAction.Requests();
        request.accountId = accountId;
        request.opportunityId = opportunityId;
        requestList.add(request);

        // run test and assert results
        List <GetOpportunityPartnersAction.Results> results = GetOpportunityPartnersAction.get(requestList);
        System.assertEquals(false, results[0].outputCollection.size()>0, 'Opportunity Partners not expected');

    }

    @isTest
    public static void invalidAccountOrOpportunity(){

        // initialize variables
        List<GetOpportunityPartnersAction.Requests> requestList = new List<GetOpportunityPartnersAction.Requests>();
        String accountId = '1234';
        String opportunityId = '1234';

        // prepare request for GetOpportunityPartnersAction
        GetOpportunityPartnersAction.Requests request = new GetOpportunityPartnersAction.Requests();
        request.accountId = accountId;
        request.opportunityId = opportunityId;
        requestList.add(request);

        // run test and assert results
        List <GetOpportunityPartnersAction.Results> results = GetOpportunityPartnersAction.get(requestList);
        System.assertEquals(false, results[0].outputCollection.size()>0, 'Opportunity Partners not expected');

    }

}