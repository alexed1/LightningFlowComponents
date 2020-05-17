/**
 * @File Name			: SendHTMLEmailTest.cls
 * @Description			: Test the SendHTMLEmail Action Component. Uses Spring/Summer '20 EmailTemplate Object + ContentVersion with multi-lingual
 * @NotTested			: OrgWideEmailAddress - cannot be assured deployment org actually has any and test insert not allowed
 * @Author				: various, including Salesforce, Alex Edelstein, https://digitalflask.com/blog/send-email-attachments-salesforce-apex/
 * @Group				: unofficialSF
 * @Last Modified By	: Jack D. Pond
 * @Last Modified On	: 2/5/2020, 4:02:33 PM
 * @Modification Log	: 
 * @License				: LICENSE found in https://github.com/alexed1/LightningFlowComponents
 * Ver		Date		Author					Modification
 * -------	----------	----------------------	------------------------------------------
 * 1.32		2/05/2020	Jack D. Pond			Updated Versioning
 * 1.33.1	4/11/2020	Jack D. Pond			Added tests for Issues #308,#316
 * 1.33.2	5/03/2020	Jack D. Pond			Version 1.33.2 upgrade - Issues #351,#354
**/
// @Test t001_canSendEmail: emailDeliverabilityEnabled and capacity not exceeded or not emailDeliverabilityEnabled
// @Test t002_errorIfNoAddress: Error expected if no addresses specified
// @Test t003_errorIfBothTemplateAndBody: Error expected if both body and templateId set
// @Test t004_errorIfTemplateButNoContextRecord: Error expected if templateID does not exist
// @Test t005_errorIfTemplateNameAndTemplateID: Error expected if templateID and templateName both used
// @Test t006_coverageIfTemplateNameAndNoLanguage: Can select the Organization LanguageLocaleKey template if no language specified.  However, if LanguageLocaleKey isn't en_US, still works
// @Test t007_coverageIfTemplateNameDoesntExist: Error expected if Named Template non-existent 
// @Test t008_coverageWithAttachments: Can add Attachments and send to collections (Contact, Lead, User)
// @Test t009_coverageTestActivity: Can allow email activity and task activity on recordId object
// @Test t010_canSendEmailCCUsers: Can send email to a collection of users, email addresses and useSalesforceSignature
// @Test t011_ErrorIfNoBody: Error expected if (templateID == null  && HTMLbody == null && plainTextBody == null)
// @Test t012_ErrorIfSaveAsActivityAndNoRecordId: Error expected if (saveAsActivity == true && recordId/whatId == null)
// @Test t013_CoverageAttemptForOrgWideEmailAddress : Error expected if (saveAsActivity == true && recordId/whatId == null)
// @Test t014_coverageTestActivityAndBulkification: Can allow email activity and task activity on recordId object if records, plus bulkification

@isTest
public with sharing class SendHTMLEmailTest {
/**
    Test classes that create standard object records can cause failures if the deploying org has customized required fields,  
    validations, triggers, . . . because it is complex to find and mimic these customizations and a failure in creation will stop the deployment
    Inversely, not doing these tests can cause code coverage % failures.  For pre-deployment testing purposes, TEST_WITH_CREATED_RECORDS should be set to true,
    but for version release, should be set to false.
**/
    private Static Final Boolean TEST_WITH_CREATED_RECORDS = true;
//
    private Static Final String TEMPLATE_NAME = 'xxxyyy Test Email Template yyyxxx';
    private Static Final String TEMPLATE_DEVNAME = 'xxxyyy_Test_Email_Template_yyyxxx';
    private Static Final String TEMPLATE_LANGUAGE = 'en_US';
    private Static Final String TEMPLATE_NOSUCH = 'ZZXZ_XYZZY';
    private Static Final String TEMPLATE_NAME_NOSUCH = 'ZZXZ XYZZY';
    private Static Final String EMAIL_SUBJECT = 'this is the subject';
    private Static Final String EMAIL_BODY = 'this is the body';
    private Static Final String EMAIL_NOSUCH = 'test@foo.com';
    private Static Final String EMAIL_NAME_NOSUCH = 'Do Not Reply';
    private Static Final Integer TEST_CONTACTS_COUNT = 1;
    private Static Final Integer BULK_TEST_COUNT = 4;

//	set up two email templates - one language enabled, the other not.   These will also be used as the relatedTo (WhatId/recordId)
	@testSetup static void testSetupdata(){
            EmailTemplate validEmailTemplate = new EmailTemplate(
            isActive = true,
            Name = TEMPLATE_NAME,
            DeveloperName = TEMPLATE_DEVNAME,
            TemplateType = 'custom',
            Description = 'Test Email Template - No Language Specified',
            FolderId = UserInfo.getUserId(),
            Subject = 'Test Email Template'
        );
        if (TEST_WITH_CREATED_RECORDS){
            validEmailTemplate.UIType = 'SFX';
            validEmailTemplate.RelatedEntityType = 'Account';
        }
        insert validEmailTemplate;

        validEmailTemplate = new EmailTemplate(
            isActive = true,
            Name = TEMPLATE_NAME,
            DeveloperName = TEMPLATE_DEVNAME+'_'+TEMPLATE_LANGUAGE,
            TemplateType = 'custom',
            Description = 'Test Email Template - Language Specified (Language="'+TEMPLATE_LANGUAGE+'")',
            FolderId = UserInfo.getUserId(),
            Subject = 'Test Email Template - Language'
        );
        if (TEST_WITH_CREATED_RECORDS){
            validEmailTemplate.UIType = 'SFX';
            validEmailTemplate.RelatedEntityType = 'Account';
        }
        insert validEmailTemplate;
    }
// Check to see if email is deliverable (enabled and capacity not exceeded)    
    private static Boolean emailDeliverabilityEnabled(){
        Boolean emailDeliverabilityEnabled = true;
        try {
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.reserveMassEmailCapacity(1);
        } catch (System.NoAccessException e) {
            emailDeliverabilityEnabled = false;
            system.debug('WARNING!!!:  Messaging has not been enabled or insufficient capacity for test.');
        }
        return emailDeliverabilityEnabled;
    }

//  Create Content and content links for testing 'attachments'
    private static List<ContentDocumentLink> emailCreateAttachments(ID validEmailTemplateId){
        ContentVersion content=new ContentVersion(); 
            content.Title='Test_Content'; 
            content.PathOnClient='/' + content.Title + '.txt'; 
            Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
            content.VersionData=bodyBlob; 
            //content.LinkedEntityId=sub.id;
            content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=validEmailTemplateId;
            contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
            contentlink.ShareType = 'V';
            test.starttest();
        insert contentlink;
        List<ContentDocumentLink> cdls=new List<ContentDocumentLink>();
        cdls.add(contentlink);
        System.assertEquals(1, cdls.size());
        return cdls;
    }
//	Create a contact to test email field merge (recipient && relatedTo[WhichId,relatedId])
    private static List<Contact> emailCreateTestContacts(integer howMany){
        List<Contact> ctList = new List<Contact>();
        for (Integer i = 0; i < howMany; i++){
            ctList.add(new Contact(
                    LastName    = 'Contact '+ ('0000'+i).right(4),
                    FirstName   = 'Test',
                	email		= 'e'+('0000'+i).right(4)+EMAIL_NOSUCH
                )
            );
        }
        insert ctList;
        return ctList;
    }
//	Create leads to test coverage for sent to leads)
    private static List<Lead> emailCreateTestLeads(integer howMany){
        List<Lead> ldList = new List<Lead>();
        for (Integer i = 0; i < howMany; i++){
            ldList.add(new Lead(
                    LastName    = 'Lead '+ ('0000'+i).right(4),
                    FirstName   = 'Test',
                	email		= 'e'+('0000'+i).right(4)+EMAIL_NOSUCH
                )
            );
        }
        insert ldList;
        return ldList;
    }

//	Create a contact to test email field merge (recipient && relatedTo[WhichId,relatedId])
    private static List<Account> emailCreateTestAccount(integer howMany, ID relatedContactId){
        List<Account> accountList = new List<Account>();
        for (Integer i = 0; i < howMany; i++){
            accountList.add(new Account(
                    Name    	= 'Test Account '+ ('0000'+i).right(4)	
                )
            );
        }
        insert AccountList;
        return AccountList;
    }

    
// @Test t001_canSendEmail: emailDeliverabilityEnabled and capacity not exceeded or not emailDeliverabilityEnabled
    @isTest
    public static void t001_canSendEmail () {
        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.Subject = EMAIL_SUBJECT;
        testReq.HTMLbody = EMAIL_BODY;
        testReq.SendTOthisOneEmailAddress = EMAIL_NOSUCH;
        testReq.SendCCthisOneEmailAddress = EMAIL_NOSUCH;
        testReq.SendBCCthisOneEmailAddress = EMAIL_NOSUCH;

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);

		Boolean exceptionHit = false;
        try {            
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
            system.debug('t001_error: IfNoAddress: '+e.getMessage());
        }
	    
        Boolean emailDeliverabilityEnabled = emailDeliverabilityEnabled();
        if(emailDeliverabilityEnabled){
            System.assertEquals(exceptionHit,false,'emailDeliverabilityEnabled and capacity exceeded');
        } else {
            System.assertEquals(emailDeliverabilityEnabled,false,'emailDeliverabilityEnabled');
        }
    }

// @Test t002_errorIfNoAddress: Error expected if no addresses specified
    @isTest
    public static void t002_errorIfNoAddress () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.Subject = EMAIL_SUBJECT;
        testReq.HTMLbody = EMAIL_BODY;
        //testReq.SendTOthisOneEmailAddress = EMAIL_NOSUCH;

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
		Boolean exceptionHit = false;
        try {            
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        	System.assertEquals(testResponseList[0].isSuccess,false,'t002_errorIfNoAddress: Error expected if no addresses specified');
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
            system.debug('t002_error - IfNoAddress: '+e.getMessage());
        }
    }

// @Test t003_errorIfBothTemplateAndBody: Error expected if both body and templateId set
    @isTest
    public static void t003_errorIfBothTemplateAndBody () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.Subject = EMAIL_SUBJECT;
        testReq.HTMLbody = EMAIL_BODY;
        testReq.templateID = TEMPLATE_NOSUCH;
        testReq.SendTOthisOneEmailAddress = EMAIL_NOSUCH;

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
        Boolean exceptionHit=false;
        try {
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
            system.debug('t003_error - IfBothTemplateAndBody error: '+e.getMessage());
        }
        System.assertEquals(true, exceptionHit,'Error expected if flow attempts to set both body and templateId');
    }

// @Test t004_errorIfTemplateButNoContextRecord: Error expected if templateID does not exist
    @isTest
    public static void t004_errorIfTemplateButNoContextRecord () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.Subject = EMAIL_SUBJECT;
        //testReq.HTMLbody = EMAIL_BODY;
        testReq.templateID = TEMPLATE_NOSUCH;
        testReq.SendTOthisOneEmailAddress = EMAIL_NOSUCH;

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
		Boolean exceptionHit=false;
        try {
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
            system.debug('t004_errorIfTemplateButNoContextRecord error: '+e.getMessage());
        }
        System.assertEquals(true, exceptionHit,'Error expected if templateID does not exist');
    }

// @Test t005_errorIfTemplateNameAndTemplateID: Error expected if templateID and templateName both used
    @isTest
    public static void t005_errorIfTemplateNameAndTemplateID () {
        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.Subject = EMAIL_SUBJECT;
        //testReq.HTMLbody = EMAIL_BODY;
        testReq.templateID = TEMPLATE_NOSUCH;
        testReq.templateName = TEMPLATE_NAME_NOSUCH;
        testReq.SendTOthisOneEmailAddress = EMAIL_NOSUCH;

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
		Boolean ExceptionHit=false;
        try {
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        } catch (SendHTMLEmail.InvocableActionException e) {
            ExceptionHit=true;
            system.debug('t005_errorIfTemplateNameAndTemplateID error: '+e.getMessage());
        }
        System.assertEquals(true, ExceptionHit,'Error expected if templateID and templateName both used');
    }
// @Test t006_coverageIfTemplateNameAndNoLanguage: Can select the Organization LanguageLocaleKey template if no language specified.  However, if LanguageLocaleKey isn't en_US, still works
    @isTest
    public static void t006_coverageIfTemplateNameAndNoLanguage() {
        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.templateName = TEMPLATE_NAME;
        testReq.templateTargetObjectId = UserInfo.getUserId();
        // if templateTargetObjectId type = user, saveAsActivity must be false
        testReq.saveAsActivity = false;

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
		Boolean noExceptionHit=true;
        List<SendHTMLEmail.Response> testResponseList;
        try {
            testResponseList = SendHTMLEmail.SendEmail(reqList);
        } catch (SendHTMLEmail.InvocableActionException e) {
            noExceptionHit=false;
            system.debug('t006_coverageIfTemplateNameAndNoLanguage error: '+e.getMessage());
        }
//		Depending on the organization locallangage key, could be either
        if ([Select LanguageLocaleKey From Organization limit 1].LanguageLocaleKey == TEMPLATE_LANGUAGE){
			System.assertEquals(testResponseList[0].templateUsed,
                                [Select Id from EmailTemplate where DeveloperName=:(TEMPLATE_DEVNAME+'_'+TEMPLATE_LANGUAGE)].Id);
        } else {
			System.assertEquals(testResponseList[0].templateUsed, [Select Id from EmailTemplate where DeveloperName=:TEMPLATE_DEVNAME].Id);
        }
    }

// @Test t007_coverageIfTemplateNameDoesntExist: Error expected if Named Template non-existent 
    @isTest
    public static void t007_coverageIfTemplateNameDoesntExist() {
        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.templateName = TEMPLATE_NOSUCH;

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
		Boolean ExceptionHit=false;
        List<SendHTMLEmail.Response> testResponseList;
        try {
            testResponseList = SendHTMLEmail.SendEmail(reqList);
        } catch (SendHTMLEmail.InvocableActionException e) {
            ExceptionHit=true;
            system.debug('t007_coverageIfTemplateNameDoesntExist error: '+e.getMessage());
        }
        System.assertEquals(true, ExceptionHit,'Error expected if Named Template non-existent');
    }
// @Test t008_coverageWithAttachments: Can add Attachments and send to collections (Contact, Lead, User)
    @isTest
    public static void t008_coverageWithAttachments() {
        String devName = TEMPLATE_DEVNAME+'_'+TEMPLATE_LANGUAGE;
        EmailTemplate validEmailTemplate = [Select Id,Name from EmailTemplate where DeveloperName=:devName];
        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
    	List<ContentDocumentLink> cdls = emailCreateAttachments(validEmailTemplate.Id);
        testReq.templateName = validEmailTemplate.Name;
        testReq.recordId = validEmailTemplate.Id;
        if (TEST_WITH_CREATED_RECORDS){
            List<Contact>sendToContactCollection = emailCreateTestContacts(TEST_CONTACTS_COUNT);
			testReq.templateTargetObjectId = sendToContactCollection[0].Id;
        	testReq.recordId = emailCreateTestAccount(1,testReq.templateTargetObjectId)[0].Id;
			// also do code coverage test for sentTo Contact Collection
            List<Id> theseIds = new List<Id>();
            for (Contact thisContact : sendToContactCollection) theseIds.Add(thisContact.Id);
            sendToContactCollection = [Select Id,Email from Contact where Id in :theseIds ];
            testReq.SendBCCtheEmailAddressesFromThisCollectionOfContacts = sendToContactCollection;
			// also do code coverage test for sentTo Lead Collection
            List<Lead>sendToLeadCollection = emailCreateTestLeads(TEST_CONTACTS_COUNT);
            theseIds = new List<Id>();
            for (Lead thisLead : sendToLeadCollection) theseIds.Add(thisLead.Id);
            sendToLeadCollection = [Select Id,Email from Lead where Id in :theseIds ];
            testReq.SendBCCtheEmailAddressesFromThisCollectionOfLeads = sendToLeadCollection;

            // Contact showContact = [SELECT Id,Name,Email from Contact where Id = :testReq.templateTargetObjectId];
            // system.debug('showContact.Id: '+ showContact.Id + ' showContact.Name: '+ showContact.Name + ' showContact.Email: '+ showContact.Email);
        }else{
        	testReq.templateTargetObjectId = UserInfo.getUserId();
        	testReq.recordId = validEmailTemplate.Id;
            // if templateTargetObjectId type = user, saveAsActivity must be false
            testReq.saveAsActivity = false;
        	testReq.SendTOthisOneEmailAddress = EMAIL_NOSUCH;
        }
		testReq.contentDocumentAttachments = cdls;
        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
        system.debug('t008 attachlist: '+cdls);
		Boolean ExceptionHit=false;
        try {
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        	if (TEST_WITH_CREATED_RECORDS){
        		System.assertEquals(testResponseList[0].isSuccess,true,'t008_error: IfNoAddress. Error expected if no addresses specified');
            } else {
	        	System.assertEquals(testResponseList[0].isSuccess,false,'t008_error: WhatId is not available for sending emails to UserIds when using User as targetObject');
            }
        } catch (SendHTMLEmail.InvocableActionException e) {
            ExceptionHit=true;
            system.debug('t008_coverage: WithAttachments error: '+e.getMessage());
        }
		// This will fail to send because WhatId is not available for sending emails to UserIds.
    }

// @Test t009_coverageTestActivityAndBulkification: Can allow email activity and task activity on recordId object
    @isTest
    public static void t009_coverageTestActivityAndBulkification() {
        String devName = TEMPLATE_DEVNAME+'_'+TEMPLATE_LANGUAGE;
        EmailTemplate validEmailTemplate = [Select Id,Name from EmailTemplate where DeveloperName=:devName];
        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.templateName = validEmailTemplate.Name;
        testReq.recordId = validEmailTemplate.Id;
        if (TEST_WITH_CREATED_RECORDS){
			testReq.templateTargetObjectId = emailCreateTestContacts(TEST_CONTACTS_COUNT)[0].Id;
        	testReq.recordId = emailCreateTestAccount(1,testReq.templateTargetObjectId)[0].Id;
        	testReq.saveAsActivity = true;
        }else{
        	testReq.templateTargetObjectId = UserInfo.getUserId();
        	// if templateTargetObjectId type = user, saveAsActivity must be false
            testReq.SendTOthisOneEmailAddress = EMAIL_NOSUCH;
        	testReq.saveAsActivity = false;
        }

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
		Boolean ExceptionHit=False;
        try {
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
            system.debug('t009: testResponseList: ' + testResponseList);
            if (TEST_WITH_CREATED_RECORDS){
                System.assertEquals(testResponseList[0].isSuccess,true,'Cannot allow email record as activity on recordId object');
            } else {
                System.assertEquals(testResponseList[0].isSuccess,false,'WhatId is not available for sending emails to UserIds when using User as targetObject');
            }
        } catch (SendHTMLEmail.InvocableActionException e) {
            ExceptionHit=true;
            String error = e.getMessage();
            system.debug('t009_coverage - TestActivity error: '+e.getMessage());
        }
    }

// @Test t010_canSendEmailCCUsers: Can send email to a collection of users, email addresses and useSalesforceSignature
    @isTest
    public static void t010_canSendEmailCCToCollectionOfUsers() {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.Subject = EMAIL_SUBJECT;
        testReq.HTMLbody = EMAIL_BODY;
        testReq.SendTOthisOneEmailAddress = EMAIL_NOSUCH;
        testReq.SendBCCthisOneEmailAddress = EMAIL_NOSUCH;
        testReq.SendCCtheEmailAddressesFromThisCollectionOfUsers = [Select Id,Email from User where Id=:UserInfo.getUserId()];
        testReq.SendBCCthisStringCollectionOfEmailAddresses = new List<String>{EMAIL_NOSUCH};
		testReq.useSalesforceSignature = true;
        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);

		Boolean exceptionHit = false;
        try {            
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
            system.debug('t001_errorIfNoAddress: '+e.getMessage());
        }
	    
        Boolean emailDeliverabilityEnabled = emailDeliverabilityEnabled();
        if(emailDeliverabilityEnabled){
            System.assertEquals(exceptionHit,false,'Cannot send email to a collection of users and email addresses and/or useSalesforceSignature');
        } else {
            System.assertEquals(emailDeliverabilityEnabled,false,'emailDeliverabilityDisabled Enabled or capacity exceeded');
        }
    }
// @Test t011_ErrorIfNoBody: Error expected if (templateID == null  && HTMLbody == null && plainTextBody == null)
    @isTest
    public static void t011_ErrorIfNoBody() {
        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.Subject = EMAIL_SUBJECT;
        testReq.SendTOthisOneEmailAddress = EMAIL_NOSUCH;
        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);

		Boolean exceptionHit = false;
        try {            
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
            system.debug('t011_ErrorIfNoBody: '+e.getMessage());
        }
	    
        Boolean emailDeliverabilityEnabled = emailDeliverabilityEnabled();
        if(emailDeliverabilityEnabled){
            System.assertEquals(exceptionHit,true,'Error not received when (templateID == null  && HTMLbody == null && plainTextBody == null)');
        } else {
            System.assertEquals(emailDeliverabilityEnabled,false,'emailDeliverabilityDisabled Enabled or capacity exceeded');
        }
    }
// @Test t012_ErrorIfSaveAsActivityAndNoRecordId: Error expected if (saveAsActivity == true && recordId/whatId == null)
    @isTest
    public static void t012_ErrorIfSaveAsActivityAndNoRecordId() {
        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.Subject = EMAIL_SUBJECT;
        testReq.HTMLbody = EMAIL_BODY;
        testReq.SendTOthisOneEmailAddress = EMAIL_NOSUCH;
        testReq.saveAsActivity = true;
        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);

		Boolean exceptionHit = false;
        try {            
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
            system.debug('t012_ErrorIfSaveAsActivityAndNoRecordId: '+e.getMessage());
        }
	    
        Boolean emailDeliverabilityEnabled = emailDeliverabilityEnabled();
        if(emailDeliverabilityEnabled){
            System.assertEquals(exceptionHit,true,'Error not received when (saveAsActivity == true && recordId/whatId == null)');
        } else {
            System.assertEquals(emailDeliverabilityEnabled,false,'emailDeliverabilityDisabled Enabled or capacity exceeded');
        }
    }
// @Test t013_CoverageAttemptForOrgWideEmailAddress : Error expected if (saveAsActivity == true && recordId/whatId == null)
    @isTest
    public static void t013_ErrorIfSaveAsActivityAndNoRecordId() {
        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        for (OrgWideEmailAddress orgAddrs : [SELECT id, DisplayName, Address FROM OrgWideEmailAddress]){
        	SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
            testReq.Subject = EMAIL_SUBJECT;
            testReq.HTMLbody = EMAIL_BODY;
            testReq.SendTOthisOneEmailAddress = EMAIL_NOSUCH;
            testReq.orgWideEmailAddressId = orgAddrs.Id;
            reqList.add(testReq);
    	}
        if (reqList.size() > 0){
            Boolean exceptionHit = false;
            List<SendHTMLEmail.Response> testResponseList = new List<SendHTMLEmail.Response>();
            try {            
                testResponseList = SendHTMLEmail.SendEmail(reqList);
            } catch (SendHTMLEmail.InvocableActionException e) {
                exceptionHit=true;
                system.debug('t013_CoverageAttemptForOrgWideEmailAddress: '+e.getMessage());
            }
            
            Boolean emailDeliverabilityEnabled = emailDeliverabilityEnabled();
            if(emailDeliverabilityEnabled){
                for(SendHTMLEmail.Response thisTest : testResponseList){
                    system.debug('t013_CoverageAttemptForOrgWideEmailAddress Response:' + thisTest.isSuccess + ' Template Errors: ' + thisTest.errors + ' Template Used: '+ thisTest.templateUsed);
                }
//                System.assertEquals(exceptionHit,false,'Error on orgWideEmailAddressId');
            } else {
                System.assertEquals(emailDeliverabilityEnabled,false,'emailDeliverabilityDisabled Enabled or capacity exceeded');
            }
        } else {
            System.Debug('Unable to test orgWideEmailAddressId.  No orgWideEmailAddress available.');
        }
    }
// @Test t014_coverageTestActivityAndBulkification: Can allow email activity and task activity on recordId object if records, plus bulkification
    @isTest
    public static void t014_coverageTestActivityAndBulkification() {
        List<Contact> theseContacts = emailCreateTestContacts(BULK_TEST_COUNT);
        List<Account> theseAccounts = new List<Account>();
        if (TEST_WITH_CREATED_RECORDS){
			theseContacts = emailCreateTestContacts(BULK_TEST_COUNT);
            for (Contact thisContact : theseContacts){
                theseAccounts.add(emailCreateTestAccount(1,thisContact.Id)[0]);
            }
        }
        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
		SendHTMLEmail.Request testReq;
        for (Integer i=0;i<BULK_TEST_COUNT;i++){
            testReq = new SendHTMLEmail.Request();
            testReq.Subject = EMAIL_SUBJECT + ('0000'+i).right(4);
            testReq.SendTOthisOneEmailAddress = EMAIL_NOSUCH;
            // Deliberately introduce error every other request
            if (math.mod(i,2) == 0){
                testReq.HTMLbody = EMAIL_BODY + ('0000'+i).right(4);
            }
            if (TEST_WITH_CREATED_RECORDS){
                testReq.templateTargetObjectId = theseContacts[i].Id;
                testReq.recordId = theseAccounts[i].Id;
                testReq.saveAsActivity = true;
            }else{
                testReq.saveAsActivity = false;
            }
            system.debug('testReq'+('0000'+i).right(4)+': ' + testReq);
            reqList.add(testReq);
        }
        try {
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
            for (Integer i=0;i<testResponseList.size();i++){
                System.assertEquals(testResponseList[i].isSuccess,(math.mod(i,2) == 0),'Failed on '+ ('0000'+i).right(4));
            }
        } catch (SendHTMLEmail.InvocableActionException e) {
            String error = e.getMessage();
            system.debug('t014_coverageTestActivityAndBulkification error: '+e.getMessage());
        }
    }
}