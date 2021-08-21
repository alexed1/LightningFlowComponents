@isTest
public class FileUploadImproved_Test {
	@isTest
    public static void encrypted_test(){
        Contact con = new Contact(
            LastName = 'Test'
        );
        insert con;
        
        String key = FileUploadImprovedHelper.getKey();
        
        ContentVersion cv = new ContentVersion(
        	Title = 'Test',
            PathOnClient = 'Test',
            VersionData = EncodingUtil.base64Decode('Test'),
            Guest_Record_fileupload__c = FileUploadImprovedHelper.encrypt(con.Id,key)
        );
        insert cv;
        
        FileUploadImprovedHelper.createContentDocLink(new List<String>{cv.Id},key);
        
        List<ContentDocumentLink> cdl = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :con.Id];
        
        system.assertEquals(1, cdl.size());
    }
}