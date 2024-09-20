/**
 * @description       : 
 * @author            : Josh Dayment
 * @group             : 
 * @last modified on  : 08-21-2024
 * @last modified by  : Josh Dayment
**/
@IsTest
public class TestBase64ToFileConverter {

    @IsTest
    static void testConvertAndAttach() {
        // Create a test Account record
        Account acc = new Account(Name='Test Account');
        insert acc;

        // Create a test File Content
        Blob fileBody = Blob.valueOf('Test file content');

        // Convert the Blob to Base64
        String base64Text = EncodingUtil.base64Encode(fileBody);

        // Create a test Request object
        Base64ToFileConverter.Request req = new Base64ToFileConverter.Request();
        req.base64Text = 'data:image/jpeg;base64,' + base64Text;
        req.recordId = acc.Id;
        req.fileName = 'testFile.jpg';

        // Prepare a list of test Request objects
        List<Base64ToFileConverter.Request> requests = new List<Base64ToFileConverter.Request>{ req };

        // Run the test as a specific user
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Test.startTest();

            // Call the method to be tested
            List<Base64ToFileConverter.Response> responses = Base64ToFileConverter.convertAndAttach(requests);

            Test.stopTest();

            // Assertions
            System.assertEquals(1, responses.size(), 'Response list should have 1 item');
            System.assertNotEquals(null, responses[0].contentVersionId, 'ContentVersionId should not be null');

        }
    }
}



