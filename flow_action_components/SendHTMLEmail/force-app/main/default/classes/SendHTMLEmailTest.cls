@isTest
public with sharing class SendHTMLEmailTest {
    private Static Final String TEMPLATE_NAME = 'xxxyyy Test Email Template yyyxxx';
    private Static Final String TEMPLATE_DEVNAME = 'xxxyyy_Test_Email_Template_yyyxxx';
    private Static Final String TEMPLATE_LANGUAGE = 'en_US';
    private Static Final String TEMPLATE_NOSUCH = 'XYZZY';
    private Static Integer TEST_CONTACTS_COUNT = 1;
    private Static Integer TEST_CASES_COUNT = 1;

	@testSetup static void testSetupdata(){
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = TEMPLATE_NAME;
        validEmailTemplate.DeveloperName = TEMPLATE_DEVNAME;
        validEmailTemplate.TemplateType = 'custom';
        validEmailTemplate.Description = 'Test Email Template - No Language Specified';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        validEmailTemplate.Subject = 'Test Email Template';
        insert validEmailTemplate;

        validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'xxxyyy Test Email Template yyyxxx';
        validEmailTemplate.DeveloperName = TEMPLATE_DEVNAME+TEMPLATE_LANGUAGE;
        validEmailTemplate.TemplateType = 'custom';
        validEmailTemplate.Description = 'Test Email Template - Language Specified (Language="'+TEMPLATE_LANGUAGE+'")';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        validEmailTemplate.Subject = 'Test Email Template - Language';
        insert validEmailTemplate;
    }
    
    private static Boolean EmailDeliverabilityEnabled(){
        Boolean EmailDeliverabilityEnabled = true;
        try {
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.reserveMassEmailCapacity(1);
        } catch (System.NoAccessException e) {
            EmailDeliverabilityEnabled = false;
        }
        return EmailDeliverabilityEnabled;
    }
    private static List<List<Id>> EmailCreateRelatedSet(){
        List<List<String>> retLists = new List<List<String>>();
        List<Contact> ctList = new List<Contact>();
        for (Integer i = 0; i < TEST_CONTACTS_COUNT; i++){
            ctList.add(new Contact(
                    LastName    = 'Contact '+ ('0000'+i).right(4),
                    FirstName   = 'Test',
                	email		= 'test@foo.com'
                )
            );
        }
        insert ctList;
        retLists.add(new List<Id>(new Map<Id, Contact>(ctList).keySet()));
        List<Case> caseList = new List<Case>();
        for (Integer k = 0; k < TEST_CASES_COUNT; k++){
            caseList.add(new Case(
                    Subject    	= 'Test Case '+ ('0000'+k).right(4),
                	ContactId	= ctList[0].Id
                )
            );
        }
        insert caseList;
        retLists.add(new List<Id>(new Map<Id, Case>(caseList).keySet()));
        return retLists;
    }

    @isTest
    public static void CanSendEmail () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.HTMLbody = 'this is the body';
        testReq.Subject = 'this is the subject';
        testReq.SendTOthisOneEmailAddress = 'test@foo.com';
        testReq.SendCCthisOneEmailAddress = 'test@foo.com';
        testReq.SendBCCthisOneEmailAddress = 'test@foo.com';

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);

        List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
	    
        Boolean EmailDeliverabilityEnabled = EmailDeliverabilityEnabled();
        if(EmailDeliverabilityEnabled){
            System.assertEquals(testResponseList[0].isSuccess,true);
        } else {
            System.assertEquals(EmailDeliverabilityEnabled,false);
        }

    }

    @isTest
    public static void errorIfNoAddress () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.HTMLbody = 'this is the body';
        testReq.Subject = 'this is the subject';
        //testReq.SendTOthisOneEmailAddress = 'test@foo.com';

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);

        List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        System.assertEquals(testResponseList[0].isSuccess,false);



    }

    @isTest
    public static void errorIfBothTemplateandBody () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.HTMLbody = 'this is the body';
        testReq.templateID = 'temp';
        testReq.Subject = 'this is the subject';
        testReq.SendTOthisOneEmailAddress = 'test@foo.com';

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
        Boolean exceptionHit=false;
        try {
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
        }
        System.assertEquals(true, exceptionHit);
    }

     @isTest
    public static void errorIfTemplateButNoContextRecord () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        //testReq.HTMLbody = 'this is the body';
        testReq.templateID = 'temp';
        testReq.Subject = 'this is the subject';
        testReq.SendTOthisOneEmailAddress = 'test@foo.com';

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
		Boolean exceptionHit=false;
        try {
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
        }
        System.assertEquals(true, exceptionHit);
    }
    @isTest
    public static void errorIfTemplateNameAndTemplateID () {
        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        //testReq.HTMLbody = 'this is the body';
        testReq.templateID = 'temp';
        testReq.templateName = 'someTemplateName';
        testReq.Subject = 'this is the subject';
        testReq.SendTOthisOneEmailAddress = 'test@foo.com';

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
		Boolean exceptionHit=false;
        try {
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
        }
        System.assertEquals(true, exceptionHit);
    }
    @isTest
    public static void coverageIfTemplateNameAndNoTemplateId() {
        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        List<List<Id>> bothLists = EmailCreateRelatedSet();
        testReq.templateName = TEMPLATE_NAME;
        testReq.templateTargetObjectId = bothLists[0][0];
        testReq.templateWhatId = bothLists[1][0];

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
		Boolean exceptionHit=false;
        List<SendHTMLEmail.Response> testResponseList;
        try {
            testResponseList = SendHTMLEmail.SendEmail(reqList);
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
            system.debug('error: '+e.getMessage());
        }
        system.Debug([Select Id,DeveloperName from EmailTemplate where DeveloperName=:TEMPLATE_DEVNAME].Id);
//		Depending on the organization locallangage key, could be either
        if ([Select LanguageLocaleKey From Organization limit 1].LanguageLocaleKey == TEMPLATE_LANGUAGE){
			System.assertEquals(testResponseList[0].templateUsed,
                                [Select Id from EmailTemplate where DeveloperName=:(TEMPLATE_DEVNAME+TEMPLATE_LANGUAGE)].Id);
        } else {
			System.assertEquals(testResponseList[0].templateUsed, [Select Id from EmailTemplate where DeveloperName=:TEMPLATE_DEVNAME].Id);
        }
    }

    @isTest
    public static void coverageIfTemplateNameDoesntExist() {
        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.templateName = TEMPLATE_NAME+TEMPLATE_NOSUCH;

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
		Boolean exceptionHit=false;
        List<SendHTMLEmail.Response> testResponseList;
        try {
            testResponseList = SendHTMLEmail.SendEmail(reqList);
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
            system.debug('error: '+e.getMessage());
        }
        System.assertEquals(true, exceptionHit);
    }
}