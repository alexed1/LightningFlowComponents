/**
 * @description  CPE helper for creating a single bulk request - only returns the request
 * @author		         Jack D. Pond
 * @group             SendBetterEmail
 * @License				: LICENSE found in https://github.com/alexed1/LightningFlowComponents
 *
 * Ver          Date        Author					Modification
 * @since 10-06-2020	10-06-2020	Jack Pond				Initial setup
 *
 **/
@SuppressWarnings('PMD.MethodNamingConventions')
public without sharing class SendBetterEmailBulkRequestSetup {
    /**
     * @description
     *
     * @param requests SBE Requests
     * @return         `List<List<SendBetterEmailRequest>>`
     */
    @invocableMethod(
        label='Send Better Email Bulk Request Setup'
        configurationEditor='c:sendBetterEmailCPE'
    )
    public static List<List<SendBetterEmailRequest>> SendEmail(
        List<SendBetterEmailRequest> requests
    ) {
        List<List<SendBetterEmailRequest>> responseList = new List<List<SendBetterEmailRequest>>();
        responseList.add(requests);
        return responseList;
    }
}