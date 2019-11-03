@isTest
public with sharing class ConvertFilesToAttachmentsTests {
    
    @isTest
    public static void CanConvert () {
        List<ContentDocumentLink> curDocumentLinks = new List<ContentDocumentLink>();
        ConvertFilesToAttachments.Request curRequest = new ConvertFilesToAttachments.Request();
        
        List<ConvertFilesToAttachments.Request> reqList = new List<ConvertFilesToAttachments.Request>();
        reqList.add(curRequest);

        List<ConvertFilesToAttachments.Response> response = ConvertFilesToAttachments.convert(reqList);
        System.assertEquals(response[0].isSuccess,null);

    }
}
