@isTest
public with sharing class SendRichEmailTest {
	
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

    @isTest
    public static void CanSendEmail () {

        SendRichEmail.Request testReq = new SendRichEmail.Request();
        testReq.HTMLbody = 'this is the body';
        testReq.Subject = 'this is the subject';
        testReq.SendTOthisOneEmailAddress = 'test@foo.com';
        testReq.SendCCthisOneEmailAddress = 'test@foo.com';
        testReq.SendBCCthisOneEmailAddress = 'test@foo.com';

        List<SendRichEmail.Request> reqList = new List<SendRichEmail.Request>();
        reqList.add(testReq);

        List<SendRichEmail.Response> testResponseList = SendRichEmail.SendEmail(reqList);
	    
        Boolean EmailDeliverabilityEnabled = EmailDeliverabilityEnabled();
        if(EmailDeliverabilityEnabled){
            System.assertEquals(testResponseList[0].isSuccess,true);
        } else {
            System.assertEquals(EmailDeliverabilityEnabled,false);
        }

    }

    @isTest
    public static void errorIfNoAddress () {

        SendRichEmail.Request testReq = new SendRichEmail.Request();
        testReq.HTMLbody = 'this is the body';
        testReq.Subject = 'this is the subject';
        //testReq.SendTOthisOneEmailAddress = 'test@foo.com';

        List<SendRichEmail.Request> reqList = new List<SendRichEmail.Request>();
        reqList.add(testReq);

        List<SendRichEmail.Response> testResponseList = SendRichEmail.SendEmail(reqList);
        System.assertEquals(testResponseList[0].isSuccess,false);



    }

    @isTest
    public static void errorIfBothTemplateandBody () {

        SendRichEmail.Request testReq = new SendRichEmail.Request();
        testReq.HTMLbody = 'this is the body';
        testReq.templateID = 'temp';
        testReq.Subject = 'this is the subject';
        testReq.SendTOthisOneEmailAddress = 'test@foo.com';

        List<SendRichEmail.Request> reqList = new List<SendRichEmail.Request>();
        reqList.add(testReq);
        Boolean exceptionHit=false;
        try {
            List<SendRichEmail.Response> testResponseList = SendRichEmail.SendEmail(reqList);
        
        } catch (SendRichEmail.InvocableActionException e) {
            exceptionHit=true;
        }
        System.assertEquals(true, exceptionHit);



    }

     @isTest
    public static void errorIfTemplateButNoContextRecord () {

         SendRichEmail.Request testReq = new SendRichEmail.Request();
        //testReq.HTMLbody = 'this is the body';
        testReq.templateID = 'temp';
        testReq.Subject = 'this is the subject';
        testReq.SendTOthisOneEmailAddress = 'test@foo.com';

        List<SendRichEmail.Request> reqList = new List<SendRichEmail.Request>();
        reqList.add(testReq);
		Boolean exceptionHit=false;
        try {
            List<SendRichEmail.Response> testResponseList = SendRichEmail.SendEmail(reqList);
        
        } catch (SendRichEmail.InvocableActionException e) {
            exceptionHit=true;
        }
        System.assertEquals(true, exceptionHit);
       

    }
}
