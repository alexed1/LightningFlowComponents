global with sharing class ChangeOwner {
    private static final String TEST_SESSION_ID = 'TEST_SESSION_ID';
    private static final String ACCOUNT_API_NAME = 'Account';
    private static final String KNOWLEDGE_API_NAME = 'KnowledgeArticle';
    private static final String OPPORTUNITY_API_NAME = 'Opportunity';

    private static final List<String> availableValuesForAlsoTransferRelatedOpp = new List<String> {
        'All Open and Closed',
        'Owned Open and Closed',
        'Owned Open',
        'All Open',
        'Closed'
    };

    private static final List<String> availableValuesForAlsoTransferRelatedCases = new List<String> {
        'None', 'Open', 'All'
    };

    private static final List<String> availableValuesForAlsoTransferKnowledgeVersions = new List<String> {
        'None', 'Published', 'Archived', 'All'
    };

    @InvocableMethod(label='Change Owner' description='Change Owner')
    global static List<Results> execute(List<Requests> requestList) {    

        List< Results> outputs = new List<Results>{};
        List<String> errorList = new List<String>();
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

                if(String.isNotEmpty(request.targetRecordId)) {
                    Id recordId = request.targetRecordId;
                    String  sobjectName = recordId.getSObjectType().getDescribe().getName();
                    List<SObject> recordList = Database.query('SELECT Id, OwnerId FROM ' + sobjectName + ' WHERE Id = :recordId');
                    System.debug('recordList: ' + recordList);
                    request.targetRecordCollection.addAll(recordList);
                }

                if(isDifferentOwners(request.targetRecordCollection)) {
                    errorList.add('You passed in records with more than one existing owner, but Change Owner action requires that every record passed in have the same existing owner');
                }

                if(String.isNotEmpty(request.AlsoTransferKnowledgeVersions) && !availableValuesForAlsoTransferKnowledgeVersions.contains(request.AlsoTransferKnowledgeVersions)) {
                    errorList.add('Available values for \'AlsoTransferKnowledgeVersions\': ' + String.join(availableValuesForAlsoTransferKnowledgeVersions,', '));
                }

                if(String.isNotEmpty(request.AlsoTransferRelatedCases) && !availableValuesForAlsoTransferRelatedCases.contains(request.AlsoTransferRelatedCases)) {
                    errorList.add('Available values for \'AlsoTransferRelatedCases\': ' + String.join(availableValuesForAlsoTransferRelatedCases,', '));
                }

                if(String.isNotEmpty(request.AlsoTransferRelatedOpportunities) && !availableValuesForAlsoTransferRelatedOpp.contains(request.AlsoTransferRelatedOpportunities)) {
                    errorList.add('Available values for \'AlsoTransferRelatedOpportunities\': ' + String.join(availableValuesForAlsoTransferRelatedOpp,', '));
                }

                String  sobjectName = '';
                if(!request.targetRecordCollection.isEmpty()) {
                    sobjectName = request.targetRecordCollection[0].Id.getSObjectType().getDescribe().getName();
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

                if(request.KeepSalesTeam != null ) {
                    if(sobjectName == OPPORTUNITY_API_NAME) {
                        opt = new partnerSoapSforceCom.OwnerChangeOption();
                        opt.execute=request.KeepSalesTeam;
                        opt.type_x = 'KeepSalesTeam';
                        optionList.options.add(opt);
                    } else {
                        errorList.add('You can only provide a value for the \'KeepSalesTeam\' if the record(s) you\'re changing are Opportunities');
                    }
                    
                }

                if(request.KeepSalesTeamGrantCurrentOwnerReadWriteAccess != null) {
                    if(sobjectName == OPPORTUNITY_API_NAME) {
                        opt = new partnerSoapSforceCom.OwnerChangeOption();
                        opt.execute=request.KeepSalesTeamGrantCurrentOwnerReadWriteAccess;
                        opt.type_x = 'KeepSalesTeamGrantCurrentOwnerReadWriteAccess';
                        optionList.options.add(opt);
                    } else {
                        errorList.add('You can only provide a value for the \'KeepSalesTeamGrantCurrentOwnerReadWriteAccess\' if the record(s) you\'re changing are Opportunities');
                    }
                    
                }

                // if(request.SendEmailAlert != null) {
                //     opt = new partnerSoapSforceCom.OwnerChangeOption();
                //     opt.execute=request.SendEmailAlert;
                //     opt.type_x = 'SendEmail';
                //     optionList.options.add(opt);
                // }

                if(request.TransferAllOwnedCases != null || request.AlsoTransferRelatedCases == availableValuesForAlsoTransferRelatedCases[2] ) {
                    if(sobjectName == ACCOUNT_API_NAME) {
                        opt = new partnerSoapSforceCom.OwnerChangeOption();
                    opt.execute=request.TransferAllOwnedCases;
                    opt.type_x = 'TransferAllOwnedCases';
                    optionList.options.add(opt);
                    } else {
                        errorList.add('You can only provide a value for the \'When Transferring Cases with an Account, Transfer Open AND Closed Cases Owned By The Original Owner\' if the record(s) you\'re changing are Accounts');
                    }
                    
                }

                if(request.TransferArticleOwnedPublishedVersion != null || request.AlsoTransferKnowledgeVersions == availableValuesForAlsoTransferKnowledgeVersions[1]) {
                    if(sobjectName == KNOWLEDGE_API_NAME) {
                        opt = new partnerSoapSforceCom.OwnerChangeOption();
                        opt.execute=request.TransferArticleOwnedPublishedVersion;
                        opt.type_x = 'TransferArticleOwnedPublishedVersion';
                        optionList.options.add(opt);
                    } else {
                        errorList.add('You can only provide a value for the \'Also transfer Published versions owned by the current draft owner [KNOWLEDGE ONLY]\' if the record(s) you\'re changing are Knowledges');
                    }
                }

                if(request.TransferArticleOwnedArchivedVersions != null || request.AlsoTransferKnowledgeVersions == availableValuesForAlsoTransferKnowledgeVersions[2]) {
                    if(sobjectName == KNOWLEDGE_API_NAME) {
                        opt = new partnerSoapSforceCom.OwnerChangeOption();
                        opt.execute=request.TransferArticleOwnedArchivedVersions;
                        opt.type_x = 'TransferArticleOwnedArchivedVersions';
                        optionList.options.add(opt);
                    } else {
                        errorList.add('You can only provide a value for the \'Also transfer Archived versions owned by the current draft owner [KNOWLEDGE ONLY]\' if the record(s) you\'re changing are Knowledges');
                    }
                }

                if(request.TransferArticleAllVersions != null || request.AlsoTransferKnowledgeVersions == availableValuesForAlsoTransferKnowledgeVersions[3]) {
                    if(sobjectName == KNOWLEDGE_API_NAME) {
                        opt = new partnerSoapSforceCom.OwnerChangeOption();
                        opt.execute=request.TransferArticleAllVersions;
                        opt.type_x = 'TransferArticleAllVersions';
                        optionList.options.add(opt);
                    } else {
                        errorList.add('You can only provide a value for the \'Also transfer All versions owned by the current draft owner [KNOWLEDGE ONLY]\' if the record(s) you\'re changing are Knowledges');
                    }
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


                if(request.TransferOthersOpenOpportunities != null || request.AlsoTransferRelatedOpportunities == availableValuesForAlsoTransferRelatedOpp[0] || request.AlsoTransferRelatedOpportunities == availableValuesForAlsoTransferRelatedOpp[3]) {
                    if(sobjectName == ACCOUNT_API_NAME) {
                        opt = new partnerSoapSforceCom.OwnerChangeOption();
                        opt.execute=request.TransferOthersOpenOpportunities;
                        opt.type_x = 'TransferOthersOpenOpportunities';
                        optionList.options.add(opt);
                    } else {
                        errorList.add('You can only provide a value for the \'Transfer open opportunities that were owned by someone OTHER than the previous owner [ACCOUNT ONLY]\' if the record(s) you\'re changing are Accounts');
                    }
                    
                }


                if(request.TransferOwnedClosedOpportunities != null || request.AlsoTransferRelatedOpportunities == availableValuesForAlsoTransferRelatedOpp[1] || request.AlsoTransferRelatedOpportunities == availableValuesForAlsoTransferRelatedOpp[4]) {

                    if(sobjectName == ACCOUNT_API_NAME) {
                        opt = new partnerSoapSforceCom.OwnerChangeOption();
                        opt.execute=request.TransferOwnedClosedOpportunities;
                        opt.type_x = 'TransferOwnedClosedOpportunities';
                        optionList.options.add(opt);
                    } else {
                        errorList.add('You can only provide a value for the \'Transfer closed opportunities associated with the account [ACCOUNT ONLY]\' if the record(s) you\'re changing are Accounts');
                    }
                    
                }


                if(request.TransferOwnedOpenCases != null || request.AlsoTransferRelatedCases == availableValuesForAlsoTransferRelatedCases[1] ) {

                    if(sobjectName == ACCOUNT_API_NAME) {
                        opt = new partnerSoapSforceCom.OwnerChangeOption();
                        opt.execute=request.TransferOwnedOpenCases;
                        opt.type_x = 'TransferOwnedOpenCases';
                        optionList.options.add(opt);
                    } else {
                        errorList.add('You can only provide a value for the \'When Transferring Cases with an Account, Transfer Open Cases Owned By The Original Owner\' if the record(s) you\'re changing are Accounts');
                    }
                    
                }


                if(request.TransferOwnedOpenOpportunities != null || request.AlsoTransferRelatedOpportunities == availableValuesForAlsoTransferRelatedOpp[2] || request.AlsoTransferRelatedOpportunities == availableValuesForAlsoTransferRelatedOpp[1]) {

                    if(sobjectName == ACCOUNT_API_NAME) {
                        opt = new partnerSoapSforceCom.OwnerChangeOption();
                        opt.execute=request.TransferOwnedOpenOpportunities;
                        opt.type_x = 'TransferOwnedOpenOpportunities';
                        optionList.options.add(opt);
                    } else {
                        errorList.add('You can only provide a value for the \'Transfer open opportunities that were owned by the previous owner [ACCOUNT ONLY]\' if the record(s) you\'re changing are Accounts');
                    }
                    
                }

                if(!errorList.isEmpty()) {
                    throw new CustomException(String.join(errorList, '\n'));
                }

                List<partnerSoapSforceCom.sObject_x> xSObjectList = new List<partnerSoapSforceCom.sObject_x>();
                for(Sobject sobj : request.targetRecordCollection) {
                    partnerSoapSforceCom.sObject_x xSObj = new partnerSoapSforceCom.sObject_x();
                    xSObj.Id = sobj.Id;
                    xSObj.OwnerId = request.newOwnerId;
                    xSObj.type_x =  sobj.Id.getSObjectType().getDescribe().getName();
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

    static boolean isDifferentOwners(List<SObject> recordList) {
        if(recordList.size() <= 1) {
            return false;
        }

        for(Integer i = 1; i < recordList.size(); i++) {
            if(recordList[i].get('OwnerId') != recordList[i-1].get('OwnerId')) {
                return true;
            }
        }

        return false;
        
    } 
    

    global class Requests {

        @InvocableVariable
        global List<SObject> targetRecordCollection;

        @InvocableVariable
        global string targetRecordId;
        @InvocableVariable
        global SObject targetRecord;
        @InvocableVariable(required=true)
        global string newOwnerId;
        @InvocableVariable
        global Boolean EnforceNewOwnerHasReadAccess;
        @InvocableVariable
        global Boolean KeepAccountTeam;
        @InvocableVariable
        global Boolean KeepSalesTeam;
        @InvocableVariable
        global Boolean KeepSalesTeamGrantCurrentOwnerReadWriteAccess;
        // @InvocableVariable
        // global Boolean SendEmailAlert;
        @InvocableVariable(label='When Transferring Cases with an Account, Transfer Open AND Closed Cases Owned By The Original Owner')
        global Boolean TransferAllOwnedCases;
        @InvocableVariable(label='Also transfer Published versions owned by the current draft owner [KNOWLEDGE ONLY] ')
        global Boolean TransferArticleOwnedPublishedVersion;
        @InvocableVariable(label='Also transfer Archived versions owned by the current draft owner [KNOWLEDGE ONLY]')
        global Boolean TransferArticleOwnedArchivedVersions;
        @InvocableVariable(label='Also transfer All versions owned by the current draft owner [KNOWLEDGE ONLY]')
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
        @InvocableVariable(label='Transfer open opportunities that were owned by someone OTHER than the previous owner [ACCOUNT ONLY]')
        global Boolean TransferOthersOpenOpportunities;
        @InvocableVariable(label='Transfer closed opportunities associated with the account [ACCOUNT ONLY]')
        global Boolean TransferOwnedClosedOpportunities;
        @InvocableVariable(label='When Transferring Cases with an Account, Transfer Open Cases Owned By The Original Owner')
        global Boolean TransferOwnedOpenCases;
        @InvocableVariable(label='Transfer open opportunities that were owned by the previous owner [ACCOUNT ONLY]')
        global Boolean TransferOwnedOpenOpportunities;

        @InvocableVariable(description='available values:  None, Published, Archived, All')
        global  String AlsoTransferKnowledgeVersions;
        @InvocableVariable(description='available values:  None, Open, All')
        global  String AlsoTransferRelatedCases;
        @InvocableVariable(description='available values: All Open and Closed, Owned Open and Closed, Owned Open, All Open, Closed')
        global  String AlsoTransferRelatedOpportunities;
    }

    global class Results {
        @InvocableVariable
        global Boolean success;
        @InvocableVariable
        global String errorMessage;
    
    }

    public class CustomException extends Exception {

    }
}
