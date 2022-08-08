global with sharing class ChangeOwner {
    private static final String TEST_SESSION_ID = 'TEST_SESSION_ID';
    @InvocableMethod(label='Change Owner' description='Change Owner')
    global static List<Results> execute(List<Requests> requestList) {    

        List< Results> outputs = new List<Results>{};

        for (Requests request: requestList) {
            Results curResult = new Results();
            try{
                partnerSoapSforceCom.Soap myPartnerSoap = new partnerSoapSforceCom.Soap(); 
                if(request.targetRecordCollection == null) {
                    request.targetRecordCollection = new List<Sobject>();
                }

                if(request.targetRecord != null) {
                    request.targetRecordCollection.add(request.targetRecord);
                }
                partnerSoapSforceCom.SessionHeader_element sessionHeader = new partnerSoapSforceCom.SessionHeader_element();  
                sessionHeader.sessionId = Test.isRunningTest() ? TEST_SESSION_ID : Page.usf3__GenerateSessionIdForLWC.getContent().toString();

                partnerSoapSforceCom.OwnerChangeOptions_element optionList = new partnerSoapSforceCom.OwnerChangeOptions_element();
                optionList.options = new List<partnerSoapSforceCom.OwnerChangeOption>();
                myPartnerSoap.OwnerChangeOptions = optionList;
                myPartnerSoap.sessionHeader = sessionHeader;
                partnerSoapSforceCom.OwnerChangeOption opt = new partnerSoapSforceCom.OwnerChangeOption();
                
                if(request.enforceNewOwnerHasReadAccess != null) {
                    opt.execute=request.enforceNewOwnerHasReadAccess;
                    opt.type_x = 'EnforceNewOwnerHasReadAccess';
                    optionList.options.add(opt);
                }

                if(request.KeepAccountTeam != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.KeepAccountTeam;
                    opt.type_x = 'KeepAccountTeam';
                    optionList.options.add(opt);
                }

                if(request.KeepSalesTeam != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.KeepSalesTeam;
                    opt.type_x = 'KeepSalesTeam';
                    optionList.options.add(opt);
                }

                if(request.KeepSalesTeamGrantCurrentOwnerReadWriteAccess != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.KeepSalesTeamGrantCurrentOwnerReadWriteAccess;
                    opt.type_x = 'KeepSalesTeamGrantCurrentOwnerReadWriteAccess';
                    optionList.options.add(opt);
                }

                if(request.SendEmailAlert != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.SendEmailAlert;
                    opt.type_x = 'SendEmail';
                    optionList.options.add(opt);
                }

                if(request.TransferAllOwnedCases != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferAllOwnedCases;
                    opt.type_x = 'TransferAllOwnedCases';
                    optionList.options.add(opt);
                }

                if(request.TransferArticleOwnedPublishedVersion != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferArticleOwnedPublishedVersion;
                    opt.type_x = 'TransferArticleOwnedPublishedVersion';
                    optionList.options.add(opt);
                }

                if(request.TransferArticleOwnedArchivedVersions != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferArticleOwnedArchivedVersions;
                    opt.type_x = 'TransferArticleOwnedArchivedVersions';
                    optionList.options.add(opt);
                }

                if(request.TransferArticleAllVersions != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferArticleAllVersions;
                    opt.type_x = 'TransferArticleAllVersions';
                    optionList.options.add(opt);
                }

                if(request.TransferContacts != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferContacts;
                    opt.type_x = 'TransferContacts';
                    optionList.options.add(opt);
                }

                if(request.TransferContracts != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferContracts;
                    opt.type_x = 'TransferContracts';
                    optionList.options.add(opt);
                }


                if(request.TransferNotesAndAttachments != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferNotesAndAttachments;
                    opt.type_x = 'TransferNotesAndAttachments';
                    optionList.options.add(opt);
                }

                if(request.TransferOrders != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferOrders;
                    opt.type_x = 'TransferOrders';
                    optionList.options.add(opt);
                }


                if(request.TransferOthersOpenOpportunities != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferOthersOpenOpportunities;
                    opt.type_x = 'TransferOthersOpenOpportunities';
                    optionList.options.add(opt);
                }


                if(request.TransferOwnedClosedOpportunities != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferOwnedClosedOpportunities;
                    opt.type_x = 'TransferOwnedClosedOpportunities';
                    optionList.options.add(opt);
                }


                if(request.TransferOwnedOpenCases != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferOwnedOpenCases;
                    opt.type_x = 'TransferOwnedOpenCases';
                    optionList.options.add(opt);
                }


                if(request.TransferOwnedOpenOpportunities != null) {
                    opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferOwnedOpenOpportunities;
                    opt.type_x = 'TransferOwnedOpenOpportunities';
                    optionList.options.add(opt);
                }


                List<partnerSoapSforceCom.sObject_x> xSObjectList = new List<partnerSoapSforceCom.sObject_x>();
                for(Sobject sobj : request.targetRecordCollection) {
                    partnerSoapSforceCom.sObject_x xSObj = new partnerSoapSforceCom.sObject_x();
                    xSObj.Id = sobj.Id;
                    xSObj.OwnerId = request.newOwnerId;
                    xSObj.type_x =  sobj.Id.getSObjectType().getDescribe().getName();
                    xSObjectList.add(xSObj);
                }

                if(String.isNotEmpty(request.targetRecordId)) {
                    partnerSoapSforceCom.sObject_x xSObj = new partnerSoapSforceCom.sObject_x();
                    xSObj.Id = request.targetRecordId;
                    Id sobjectId = (Id)request.targetRecordId;
                    xSObj.OwnerId = request.newOwnerId;
                    xSObj.type_x = sobjectId.getSObjectType().getDescribe().getName();
                    xSObjectList.add(xSObj);
                }
                List<partnerSoapSforceCom.SaveResult> mySaveResults = myPartnerSoap.update_x(xSObjectList);
                curResult.success = true;
                curResult.errorMessage = '';
                if(mySaveResults != null) {
                    for(partnerSoapSforceCom.SaveResult saveResult : mySaveResults) {
                        if(!saveResult.success) {
                            curResult.success = false;
                            curResult.errorMessage += '\n' + SaveResult.errors;
                        } 
                    }
                }
                outputs.add(curResult);

            }catch(Exception e) {
                curResult.success = false;
                curResult.errorMessage = e.getMessage();
                outputs.add(curResult);
            }
        }
        return outputs;
    }
    

    global class Requests {

        @InvocableVariable
        global List<SObject> targetRecordCollection;

        @InvocableVariable
        global string targetRecordId;
        @InvocableVariable
        global SObject targetRecord;
        @InvocableVariable
        global string newOwnerId;
        @InvocableVariable
        global Boolean EnforceNewOwnerHasReadAccess;
        @InvocableVariable
        global Boolean KeepAccountTeam;
        @InvocableVariable
        global Boolean KeepSalesTeam;
        @InvocableVariable
        global Boolean KeepSalesTeamGrantCurrentOwnerReadWriteAccess;
        @InvocableVariable
        global Boolean SendEmailAlert;
        @InvocableVariable
        global Boolean TransferAllOwnedCases;
        @InvocableVariable
        global Boolean TransferArticleOwnedPublishedVersion;
        @InvocableVariable
        global Boolean TransferArticleOwnedArchivedVersions;
        @InvocableVariable
        global Boolean TransferArticleAllVersions;
        @InvocableVariable
        global Boolean TransferContacts;
        @InvocableVariable
        global Boolean TransferContracts;
        @InvocableVariable
        global Boolean TransferNotesAndAttachments;
        @InvocableVariable
        global Boolean TransferOpenActivities;
        @InvocableVariable
        global Boolean TransferOrders;
        @InvocableVariable
        global Boolean TransferOthersOpenOpportunities;
        @InvocableVariable
        global Boolean TransferOwnedClosedOpportunities;
        @InvocableVariable
        global Boolean TransferOwnedOpenCases;
        @InvocableVariable
        global Boolean TransferOwnedOpenOpportunities;
    }

    global class Results {
        @InvocableVariable
        global Boolean success;
        @InvocableVariable
        global String errorMessage;
    
    }
}
