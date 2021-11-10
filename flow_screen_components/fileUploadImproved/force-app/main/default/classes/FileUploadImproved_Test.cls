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
            FileUploadImprovedHelper.createContentDocLink(new List<String>{cv.Id},key,true);
        system.test.stopTest();


        List<ContentDocumentLink> cdl = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :con.Id];
        system.assertEquals(1, cdl.size());
    }

    @isTest
    public static void get_existing_files(){
        String key = FileUploadImprovedHelper.getKey();

        Contact con = getCon();
        ContentVersion cv = getCV();
        cv.Guest_Record_fileupload__c = FileUploadImprovedHelper.encrypt(con.Id,key);
        update cv;
        
        system.test.startTest();
            FileUploadImprovedHelper.createContentDocLink(new List<String>{cv.Id},key,false);
            List<FileUploadImprovedHelper.objFiles> objFiles = FileUploadImprovedHelper.getExistingFiles(con.Id); 
        system.test.stopTest();

        system.assertEquals(1, objFiles.size());
    }

    @isTest
    public static void change_file_name(){
        ContentVersion cv = getCV();
        String fileName = 'https://www.linkedin.com/in/rygramer/';

        system.test.startTest();
        FileUploadImprovedHelper.updateFileName(new List<String>{cv.Id}, fileName);
        system.test.stopTest();

        cv = getCV();
        system.assertEquals(fileName, cv.ContentDocument.Title);
    }

    @isTest
    public static void delete_test(){
        ContentVersion cv = getCV();

        system.test.startTest();
            FileUploadImprovedHelper.deleteContentDoc(cv.Id);
        system.test.stopTest();
        
    }

    @isTest
    public static void invocable_test_create_link(){
        ContentVersion cv = getCV();
        Contact con = getCon();

        FileUploadImprovedHelper.Input input = new FileUploadImprovedHelper.Input();
        input.versIds = new List<Id>{cv.Id};
        input.recordId = con.Id;
        input.visibleToAllUsers = TRUE;

        system.test.startTest();
            FileUploadImprovedHelper.createContentDocumentLinkDownstream(new List<FileUploadImprovedHelper.Input>{input});
        system.test.stopTest();

        ContentDocumentLink link = [SELECT Visibility FROM ContentDocumentLink WHERE LinkedEntityId = :con.Id];

        system.assert(link.Visibility == 'AllUsers');
    }

    @isTest
    public static void invocable_test_link_already_exists(){
        ContentVersion cv = getCV();
        Contact con = getCon();

        ContentDocumentLink link = new ContentDocumentLink(
            ContentDocumentId = cv.ContentDocumentId,
            LinkedEntityId = con.Id,
            Visibility = 'AllUsers'
        );
        insert link;

        FileUploadImprovedHelper.Input input = new FileUploadImprovedHelper.Input();
        input.versIds = new List<Id>{cv.Id};
        input.recordId = con.Id;
        input.visibleToAllUsers = TRUE;

        system.test.startTest();
            FileUploadImprovedHelper.createContentDocumentLinkDownstream(new List<FileUploadImprovedHelper.Input>{input});
        system.test.stopTest();

        link = [SELECT Visibility FROM ContentDocumentLink WHERE LinkedEntityId = :con.Id];

        system.assert(link.Visibility == 'AllUsers');
    }

    @isTest
    public static void invocable_test_with_empty_list(){

        FileUploadImprovedHelper.Input input = new FileUploadImprovedHelper.Input();
        input.versIds = new List<Id>();

        system.test.startTest();
            FileUploadImprovedHelper.createContentDocumentLinkDownstream(new List<FileUploadImprovedHelper.Input>{input});
        system.test.stopTest();

    }

    private static ContentVersion getCV(){
        return [SELECT Id, Guest_Record_fileupload__c, ContentDocument.Title, ContentDocumentId FROM ContentVersion LIMIT 1];
    }

    private static Contact getCon(){
        return [SELECT Id FROM Contact];
    }
}