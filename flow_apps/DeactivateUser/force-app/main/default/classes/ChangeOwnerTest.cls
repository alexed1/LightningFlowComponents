@isTest
public with sharing class ChangeOwnerTest {
    @isTest
    static void testExecute() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@usf.com');

        String ownerId = UserInfo.getUserId();
        System.runAs(u) {
            System.debug(UserInfo.getUserId() + ' ' + ownerId);
        

            List<Account> accountList = new List<Account>();
            for(Integer i = 0; i < 5; i++) {
                accountList.add(new Account(Name = 'test ' + i));
            }

            insert accountList;

            List<Opportunity> oppList = new List<Opportunity>();
            for(Integer i = 0; i < 5; i++) {
                oppList.add(new Opportunity(Name = 'test ' + i, AccountId = accountList[0].Id, StageName = 'Closed Won', CloseDate = Date.today()));
            }

            insert oppList;

            Test.startTest();
            ChangeOwner.Requests request = new ChangeOwner.Requests();
            //check supported inputs for Account Record
            request.TransferAllOwnedCases = false;
            request.TransferOthersOpenOpportunities = false;
            request.TransferOwnedClosedOpportunities = false;
            request.TransferOwnedOpenCases = false;
            request.TransferOwnedOpenOpportunities = false;
            request.targetRecordCollection = accountList;
            request.newOwnerId = ownerId;

            ChangeOwner.Results result = ChangeOwner.execute(new List<ChangeOwner.Requests>{request})[0];
            System.debug('Result: ' + result);
            System.assert(result.success);

            //check not supported inputs for Account Record
            request.EnforceNewOwnerHasReadAccess = false;
            request.KeepAccountTeam = false;
            request.KeepSalesTeam = false;
            request.KeepSalesTeamGrantCurrentOwnerReadWriteAccess = false;
            request.TransferArticleOwnedPublishedVersion = false;
            request.TransferArticleOwnedArchivedVersions = false;
            request.TransferArticleAllVersions = false;
            request.TransferContacts = false;
            request.TransferContracts = false;
            request.TransferNotesAndAttachments = false;
            request.TransferOpenActivities = false;
            request.TransferOrders = false;
            request.targetRecord = accountList[0];
            request.targetRecordId = accountList[1].Id;
            result = ChangeOwner.execute(new List<ChangeOwner.Requests>{request})[0];

            System.debug('Result: ' + result);
            System.assert(!result.success);

           

            request = new ChangeOwner.Requests();
            //check supported inputs for Opportunity Record
            request.KeepSalesTeam = false;
            request.KeepSalesTeamGrantCurrentOwnerReadWriteAccess = false;
            request.targetRecordCollection = oppList;
            request.newOwnerId = ownerId;

            result = ChangeOwner.execute(new List<ChangeOwner.Requests>{request})[0];
            System.debug('Result: ' + result);
            System.assert(result.success);

            
            //check supported inputs for Opportunity Record
            request.TransferAllOwnedCases = false;
            request.TransferOthersOpenOpportunities = false;
            request.TransferOwnedClosedOpportunities = false;
            request.TransferOwnedOpenCases = false;
            request.TransferOwnedOpenOpportunities = false;
            request.targetRecordCollection = oppList;
            request.newOwnerId = ownerId;

            result = ChangeOwner.execute(new List<ChangeOwner.Requests>{request})[0];
            System.debug('Result: ' + result);
            System.assert(!result.success);


            Test.stopTest();
        }
    }

    public class WebServiceMockImpl implements WebServiceMock 
	{
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
            System.debug(request);
            partnerSoapSforceCom.updateResponse_element responseElement = new partnerSoapSforceCom.updateResponse_element();
            responseElement.result = new List<partnerSoapSforceCom.SaveResult>();
            partnerSoapSforceCom.SaveResult saveResult = new partnerSoapSforceCom.SaveResult();
            saveResult.success = true;
            responseElement.result.add(saveResult);
			response.put('response_x', responseElement);
		}
	}    
}
