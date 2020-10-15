/**
 * @description       : 
 * @author            : Mohith Shrivastava
 * @group             : 
 * @last modified on  : 10-12-2020
 * @last modified by  : Jack D. Pond
 * Modifications Log 
 * Ver		Date		Author				Modification
 * 2.00.02	10-06-2020	Mohith Shrivastava	Initial Version - Action Flow for Send Better Email
 * 2.00.02	10-06-2020	Jack D. Pond		Simplified
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