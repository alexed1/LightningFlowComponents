@isTest
public with sharing class CreateFileTest {

    static testMethod void test() {

        String testFileName = 'TestFile';
        String testFileContent = 'This is a test file!';

        CreateFile.Request testRequest = new CreateFile.Request();
        List<CreateFile.Request> testRequestList = new List<CreateFile.Request>();
        testRequest.fileName = testFileName;
        testRequest.fileContent = testFileContent;
        testRequestList.add(testRequest);

        List<CreateFile.Result> testResponseList = CreateFile.createCVR(testRequestList);
        system.debug('RESPONSE - '+testResponseList);

        String docId = testResponseList[0].documentId; 
        ContentVersion cvr = 
            [SELECT 
                Title, FileExtension, VersionData
                FROM ContentVersion
                WHERE ContentDocumentId = :docId
                    AND IsLatest = true 
            ];

        system.assertEquals(cvr.Title, testFileName);

    }

}