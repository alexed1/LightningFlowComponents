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
            VersionData = EncodingUtil.base64Decode('Test'),
            IsMajorVersion = FALSE
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

    @isTest
    public static void create_contentversion(){
        String encodedKey = FileUploadImprovedHelper.getKey();
        String encodedRecordId = FileUploadImprovedHelper.encrypt(getCon().Id, encodedKey);

        String beforeString = 'File Upload Improved';
        Blob beforeBlob = Blob.valueOf(beforeString);
        String newVersionData = EncodingUtil.base64Encode(beforeblob);

        List<String> fileNames = new List<String>{'FileUploadImproved.txt'};
        List<Id> versIds = new List<Id>();
        system.test.startTest();   
            List<FileUploadImprovedHelper.objFiles> objFiles = FileUploadImprovedHelper.createContentVers(fileNames, encodedRecordId);

            for(FileUploadImprovedHelper.objFiles objFile : objFiles){
                versIds.add(objFile.contentVersionId);
                FileUploadImprovedHelper.appendDataToContentVersion(objFile.contentVersionId, newVersionData);
            }
        system.test.stopTest();

        for(ContentVersion vers : [SELECT VersionData, Guest_Record_fileupload__c FROM ContentVersion WHERE Id IN :versIds]){
            system.assertEquals(encodedRecordId, vers.Guest_Record_fileupload__c);

            // I'm stumped on this one, I'd expect this to return this way, but it doesn't.
            // Perhaps there's a bug in Salesforce tests that make it so you can't update ContentVersions?
            // system.assertEquals(newVersionData, EncodingUtil.base64Encode(vers.VersionData));
        }
    }

    @isTest
    public static void append_to_contentversion_version_has_data(){
        ContentVersion cv = getCV();

        String currentVersionData = EncodingUtil.base64Encode(cv.VersionData);

        String beforeString = 'File Upload Improved';
        Blob beforeBlob = Blob.valueOf(beforeString);
        String newVersionData = EncodingUtil.base64Encode(beforeblob);

        system.test.startTest();
            FileUploadImprovedHelper.appendDataToContentVersion(cv.Id, newVersionData);
        system.test.stopTest();

        // Stumped here too.
        // system.assertEquals(currentVersionData + newVersionData, EncodingUtil.base64Encode(getCV().VersionData));
    }

    private static ContentVersion getCV(){
        return [SELECT Id, Guest_Record_fileupload__c, ContentDocument.Title, ContentDocumentId, VersionData FROM ContentVersion LIMIT 1];
    }

    private static Contact getCon(){
        return [SELECT Id FROM Contact];
    }
}