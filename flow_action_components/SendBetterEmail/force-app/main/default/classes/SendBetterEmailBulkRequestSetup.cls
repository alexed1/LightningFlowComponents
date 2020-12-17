/**
 * @File Name			: SendBetterEmailBulkRequestSetup.cls
 * @Description			: CPE helper for creating a single bulk request - only returns the request 
 * @Author		        : Jack D. Pond
 * @Group				: unofficialSF
 * @Last Modified By	: Jack D. Pond
 * @Last Modified On	: 10-06-2020
 * @License				: LICENSE found in https://github.com/alexed1/LightningFlowComponents
 * @Modification Log	:
 *
 * Ver          Date        Author					Modification
 * 10-06-2020	10-06-2020	Jack Pond				Initial setup
 *
**/

public without sharing class SendBetterEmailBulkRequestSetup {
    @invocableMethod(
        label='Send Better Email Bulk Request Setup'
        configurationEditor='c:sendBetterEmailCPE'
    )
    public static List<List<SendBetterEmailRequest>> SendEmail(List<SendBetterEmailRequest> requests)
    {
		List<List<SendBetterEmailRequest>> responseList = new List<List<SendBetterEmailRequest>>();
        responseList.add(requests);
        return responseList;
    }
}