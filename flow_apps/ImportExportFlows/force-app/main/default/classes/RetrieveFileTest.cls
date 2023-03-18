@isTest
public with sharing class RetrieveFileTest {

    static testMethod void test() {

        String testFileName = 'TestFile';
        String testFilePath = testFileName + '.txt';
        String testFileContent = 'This is a test file!';
        ContentVersion cv = new ContentVersion();
        cv.VersionData = Blob.valueOf(testFileContent);
        cv.Title = testFileName;
        cv.PathOnClient = testFilePath;
        cv.IsMajorVersion = false;
        insert cv;
        List<ContentDocument> cd = [Select Id from ContentDocument WHERE LatestPublishedVersionId =: cv.Id LIMIT 1];
        String docId = cd[0].Id;

        RetrieveFile.Request testRequest = new RetrieveFile.Request();

        testRequest.documentId = docId;

        List<RetrieveFile.Request> testRequestList = new List<RetrieveFile.Request>();
        testRequestList.add(testRequest);

        List<RetrieveFile.Result> testResponseList = RetrieveFile.retrieveCVR(testRequestList);
        system.debug('RESPONSE - '+testResponseList);

        system.assertEquals(testResponseList[0].fileName, testFilePath);
        system.assertEquals(testResponseList[0].fileContent, testFileContent);

    }

}