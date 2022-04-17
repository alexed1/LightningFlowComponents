@isTest
global with sharing class ManageFilesInFoldersTest {
    
    global static ContentDocument doc1;
    global static ContentDocument doc2;
    global static ContentFolder folder1;
    global static ContentFolder folder2;
    global static List<ContentDocument> curContentDocuments;
    global static List<ContentFolder> curContentFolders;


    private static void setupFilesAndFolders() {


        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing '); 
            
        ContentVersion cv1 = new ContentVersion(
            Title='doc1', 
            PathOnClient ='SampleTitle.jpg',
            VersionData = bodyBlob, 
            origin = 'H'
        );
        insert cv1;

        ContentVersion cv2 = new ContentVersion(
            Title='doc2', 
            PathOnClient ='SampleTitle.jpg',
            VersionData = bodyBlob, 
            origin = 'H'
        );
        insert cv2;

        cv1 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv1.Id LIMIT 1];
        cv2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv2.Id LIMIT 1];
        System.debug('cv1 and cv2: ' + cv1 + ' ' + cv2);
        ContentDocument doc1 = [SELECT Id, Title FROM ContentDocument WHERE Id = :cv1.ContentDocumentId LIMIT 1];
        ContentDocument doc2 = [SELECT Id, Title FROM ContentDocument WHERE Id = :cv2.ContentDocumentId LIMIT 1];
        System.debug('doc1 and doc2: ' + doc1 + ' ' + doc2);
        folder1 = new ContentFolder(
            Name='folder1'
        );
        folder2 = new ContentFolder( Name='folder2');


        curContentDocuments= new  List<ContentDocument> ();
        curContentDocuments.add(doc1);
        curContentDocuments.add(doc2);
        curContentFolders= new  List<ContentFolder> ();
        curContentFolders.add(folder1);
        curContentFolders.add(folder2);
        //insert curContentDocuments;
        insert curContentFolders;
    }

    @isTest
    global static void canAddFilesToFolders(){
        setupFilesAndFolders();
        ManageFilesInFolders.Requests testRequest = new  ManageFilesInFolders.Requests();
        List<ManageFilesInFolders.Requests> testRequestList = new  List<ManageFilesInFolders.Requests> ();
        testRequest.actionType = 'add';
        testRequest.selectedContentDocuments = curContentDocuments;
        testRequest.selectedContentFolders = curContentFolders;
        testRequestList.add(testRequest);
        List<ManageFilesInFolders.Results> testResponseList = ManageFilesInFolders.execute(testRequestList);
        System.assertEquals(testResponseList[0].curContentFolderMembers[0].childRecordId, curContentDocuments[0].id);
        System.assertEquals(testResponseList[0].curContentFolderMembers[0].ParentContentFolderId, curContentFolders[0].id);
        System.assertEquals(true, testResponseList[0].isSuccess);

    }
}
