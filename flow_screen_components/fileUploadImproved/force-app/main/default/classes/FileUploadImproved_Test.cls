@isTest
public class FileUploadImproved_Test {
    
    @TestSetup
    static void makeData(){
        Contact con = new Contact(
            LastName = 'Test'
        );
        insert con;
        
        ContentVersion cv = new ContentVersion(
        	Title = 'Test',
            PathOnClient = 'Test',
            VersionData = EncodingUtil.base64Decode('Test')
        );
        insert cv;
    }

	@isTest
    public static void encrypted_test(){
        String key = FileUploadImprovedHelper.getKey();

        Contact con = getCon();
        ContentVersion cv = getCV();
        cv.Guest_Record_fileupload__c = FileUploadImprovedHelper.encrypt(con.Id,key);
        update cv;
        
        system.test.startTest();
            FileUploadImprovedHelper.createContentDocLink(new List<String>{cv.Id},key);
        system.test.stopTest();


        List<ContentDocumentLink> cdl = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :con.Id];
        system.assertEquals(1, cdl.size());
    }

    @isTest
    public static void delete_test(){
        ContentVersion cv = getCV();

        system.test.startTest();
            FileUploadImprovedHelper.deleteContentDoc(cv.Id);
        system.test.stopTest();
        
    }

    private static ContentVersion getCV(){
        return [SELECT Id, Guest_Record_fileupload__c FROM ContentVersion LIMIT 1];
    }

    private static Contact getCon(){
        return [SELECT Id FROM Contact];
    }
}