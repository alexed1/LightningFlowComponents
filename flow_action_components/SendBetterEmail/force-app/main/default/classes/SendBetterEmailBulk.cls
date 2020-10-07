/**
 * @description       : 
 * @author            : Jack D. Pond
 * @group             : 
 * @last modified on  : 10-06-2020
 * @last modified by  : Jack D. Pond
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   10-06-2020   Jack D. Pond   Initial Version
**/
public with sharing class SendBetterEmailBulk {
    @invocableMethod(
        label='Send Better Email Bulk'
    )
    public static List<List<SendBetterEmailResponse>> SendBetterEmailBulk(List<List<SendBetterEmailRequest>> emailRequests) {
        List<List<SendBetterEmailResponse>> emailResponses = new List<List<SendBetterEmailResponse>>();
        for (List<SendBetterEmailRequest> thisRequestList : emailRequests){
        	emailResponses.add(SendBetterEmail.SendEmail(thisRequestList));
        }
        return emailResponses;
    }
}