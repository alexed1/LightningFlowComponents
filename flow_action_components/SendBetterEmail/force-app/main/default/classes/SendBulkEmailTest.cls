@isTest
private class SendBulkEmailTest {
    @isTest
    static void t001_bulkSendEmail() {
        List<SendBetterEmailRequest> reqList = new List<SendBetterEmailRequest>();

        for (integer i = 0; i < 5; i++) {
            SendBetterEmailRequest testReq = new SendBetterEmailRequest();
            testReq.Subject = SendBetterEmailTest.EMAIL_SUBJECT + i;
            testReq.HTMLbody = SendBetterEmailTest.EMAIL_BODY + i;
            testReq.SendTOthisOneEmailAddress =
                i + SendBetterEmailTest.EMAIL_NOSUCH;
            testReq.SendCCthisOneEmailAddress =
                i + SendBetterEmailTest.EMAIL_NOSUCH;
            testReq.SendBCCthisOneEmailAddress =
                i + SendBetterEmailTest.EMAIL_NOSUCH;
            reqList.add(testReq);
        }

        List<List<SendBetterEmailRequest>> emailRequestLists = new List<List<SendBetterEmailRequest>>();
        emailRequestLists.add(reqList);

        List<List<SendBetterEmailResponse>> sendBetterEmailResponseList = SendBulkEmail.SendEmail(
            emailRequestLists
        );
        for (
            List<SendBetterEmailResponse> lstresponse : sendBetterEmailResponseList
        ) {
            for (SendBetterEmailResponse sendEmailResponse : lstresponse) {
                System.assertEquals(sendEmailResponse.isSuccess, true);
            }
        }
    }
}
