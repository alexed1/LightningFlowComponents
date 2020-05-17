@isTest
public  class GenerateFlowLinkTest {
    
    @isTest
    public static void VerifyURL() {
       GenerateFlowLink.Requests testReq = new GenerateFlowLink.Requests();
       
       String baseURL = Url.getOrgDomainUrl().toExternalForm();
       testReq.flowName = 'myFlow';

       List<GenerateFlowLink.Requests> reqList = new List<GenerateFlowLink.Requests>();
       reqList.add(testReq);
       List<GenerateFlowLink.Results> responseList = GenerateFlowLink.getLink(reqList);
       System.assertEquals(responseList[0].flowLink,baseURL + '/flow/myFlow');

    }

}
