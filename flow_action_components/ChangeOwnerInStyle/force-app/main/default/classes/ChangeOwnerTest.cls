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

            Test.startTest();
            ChangeOwner.Requests request = new ChangeOwner.Requests();
            request.EnforceNewOwnerHasReadAccess = true;
            request.KeepAccountTeam = true;
            request.KeepSalesTeam = true;
            request.KeepSalesTeamGrantCurrentOwnerReadWriteAccess = true;
            //request.SendEmailAlert = true;
            request.TransferAllOwnedCases = true;
            request.TransferArticleOwnedPublishedVersion = true;
            request.TransferArticleOwnedArchivedVersions = true;
            request.TransferArticleAllVersions = true;
            request.TransferContacts = true;
            request.TransferContracts = true;
            request.TransferNotesAndAttachments = true;
            request.TransferOpenActivities = true;
            request.TransferOrders = true;
            request.TransferOthersOpenOpportunities = true;
            request.TransferOwnedClosedOpportunities = true;
            request.TransferOwnedOpenCases = true;
            request.TransferOwnedOpenOpportunities = true;

            //request.targetRecordId = true;
            //request.targetRecord = true;
            request.targetRecordCollection = accountList;
            request.newOwnerId = ownerId;

            ChangeOwner.Results result = ChangeOwner.execute(new List<ChangeOwner.Requests>{request})[0];
            request.targetRecordCollection = null;
            request.targetRecord = accountList[0];
            request.targetRecordId = accountList[1].Id;
            result = ChangeOwner.execute(new List<ChangeOwner.Requests>{request})[0];

            System.debug('Result: ' + result);
            System.assert(result.success);
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
