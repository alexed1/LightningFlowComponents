public inherited sharing class SendBulkEmail {
    @invocableMethod(label='Send Bulk Email')
    public static List<List<SendBetterEmailResponse>> SendEmail(
        List<List<SendBetterEmailRequest>> emailRequests
    ) {
        // split all requests to list of single requests
        List<SendBetterEmailRequest> singlerequests = new List<SendBetterEmailRequest>();
        List<SendBetterEmailResponse> responseList = new List<SendBetterEmailResponse>();
        List<List<SendBetterEmailResponse>> emailResponses = new List<List<SendBetterEmailResponse>>();

        for (List<SendBetterEmailRequest> lstRequests : emailRequests) {
            singlerequests.addAll(lstRequests);
        }

        responseList = SendBetterEmail.SendEmail(singlerequests);
        emailResponses.add(responseList);
        return emailResponses;
    }
}
