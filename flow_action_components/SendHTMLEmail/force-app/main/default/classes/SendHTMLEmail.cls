public with sharing class SendHTMLEmail {

    @invocableMethod(label='Send HTML Email')
    public static List<Response>  numeralize(List<Request> request) {
        Response response = new Response();
        String emailAddress = request[0].emailAddress;
        String body = request[0].body;
        String subject = request[0].subject;
       
        //from https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_forcecom_email_outbound.htm

        // First, reserve email capacity for the current Apex transaction to ensure
        // that we won't exceed our daily email limits when sending email after
        // the current transaction is committed.
        Messaging.reserveSingleEmailCapacity(2);

        // Processes and actions involved in the Apex transaction occur next,
        // which conclude with sending a single email.

        // Now create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        // Strings to hold the email addresses to which you are sending the email.
        String[] toAddresses = new String[] {emailAddress}; 
        String[] ccAddresses = new String[] {'aedelstein@salesforce.com'};
        

        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);

        // Specify the address used when the recipients reply to the email. 
        mail.setReplyTo('reply@edelstein.org');

        // Specify the name used as the display name.
        mail.setSenderDisplayName('Salesforce Flow Email HQ');

        // Specify the subject line for your email address.
        mail.setSubject(subject);

        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);

        // Optionally append the salesforce.com email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);

        // Specify the text content of the email.
        mail.setPlainTextBody('plaintext body placeholder');

        mail.setHtmlBody(body);

        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        //package up the response
        List<Response> responseList = new List<Response>();
        responseList.add(response);
        return responseList;
    }

    public class Request {
        @invocableVariable
        public String body;

        @invocableVariable
        public String subject;

        @invocableVariable
        public String emailAddress;

    }

    public class Response {
        @invocableVariable
        public String outputStr;

    }

   
}
