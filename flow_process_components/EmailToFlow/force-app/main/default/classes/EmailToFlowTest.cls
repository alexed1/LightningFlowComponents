@isTest
public class EmailToFlowTest {
    public static testMethod void TestInboundEmail(){
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        env.fromAddress = 'myemail@example.com';
        env.toAddress = 'youremail@example.com';
        email.fromAddress = 'myemail@example.com';
        email.ToAddresses = new List<string>{'youremail@example.com','youremail1@example.com','youremail2@example.com'};
        email.fromName = 'test inbound email';
        email.fromAddress = 'myemail@example.com';
        email.ccAddresses = new List<string>{'youremail3@example.com','youremail4@example.com'};
        email.subject = 'Test Email To Flow';
        email.replyTo = '';
        email.inReplyTo = '';
        email.messageId = 'testMessageId';
        email.references = new List<string>{''};
        email.htmlBody = 'Hello, <br/> World';
        email.plainTextBody = 'Hello, World';
        email.messageId = 'ABCDEFGHIJKL=5s03sP262OV+YG+pxA@mail.example.com';
        
        Test.startTest();
        
        //test without attachments
        EmailToFlow EmailToFlowObj = new EmailToFlow();
        EmailToFlowObj.handleInboundEmail(email, env);
        
        //create binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
        //create text attachment
        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
        
        //retest with Attachments
        Messaging.InboundEmailResult EmailToFlowResult = EmailToFlowObj.handleInboundEmail(email, env);
        system.assertEquals(True, EmailToFlowResult.success);
        Test.stopTest();
    }

}