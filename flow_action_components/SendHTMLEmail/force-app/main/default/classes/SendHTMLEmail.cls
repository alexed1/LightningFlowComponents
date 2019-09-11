public with sharing class SendHTMLEmail {

    @invocableMethod(label='Send HTML Email')
    public static List<Response>  numeralize(List<Request> requests) {
        Response response = new Response();
      
        String body = requests[0].body;
        String subject = requests[0].subject;
        
       
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
        //String[] toAddresses = new String[] {emailAddress}; 
        String[] toAddresses = BuildAddressList('TO', requests[0]); 
        System.debug('toAddresses is: ' + toAddresses);
        String[] ccAddresses = BuildAddressList('CC', requests[0]); 
        String[] bccAddresses = BuildAddressList('BCC', requests[0]);

        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setBccAddresses(bccAddresses);

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
        Messaging.SendEmailResult[] emailResponse = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        System.debug('emailResponse is: ' + emailResponse);
        //package up the response
        List<Response> responseList = new List<Response>();
        responseList.add(response);
        return responseList;
    }

    public static String[] BuildAddressList(string type, Request request) {
        //Request.SendTOthisOneEmailAddress testAddress = 'alex@edelstein.org';
        string propName = 'request.SendTOthisOneEmailAddress';
        string value = 'foo';
        System.debug ('value is: ' + value);
        String[] addressList = new List<String>();
        Map<String, Object> m = GenerateMap(request);
        //build To list
        if (m.get('SendTOthisOneEmailAddress') != null) {
            addressList.add((String)m.get('SendTOthisOneEmailAddress'));
            System.debug('address list is:' + addressList);
        }

        if (m.get('SendTOthisStringCollectionOfEmailAddresses') != null) {
            addressList.add((String)m.get('SendTOthisStringCollectionOfEmailAddresses'));
            System.debug('address list is:' + addressList);
        }

        if (m.get('SendTOtheEmailAddressesFromThisCollectionOfContacts') != null) {
            List<String> extractedEmailAddresses = new List<String>();
            List<Contact> curContacts = (List<Contact>)m.get('SendTOtheEmailAddressesFromThisCollectionOfContacts');
            String curEmail;
            for (Contact curContact : curContacts) {
                curEmail = curContact.email;
                if (curEmail != null) extractedEmailAddresses.add(curEmail);
            }
            addressList.addAll(extractedEmailAddresses);
            System.debug('address list is:' + addressList);
        }

        if (m.get('SendTOtheEmailAddressesFromThisCollectionOfUsers') != null) {
            List<String> extractedEmailAddresses = new List<String>();
            List<User> curUsers = (List<User>)m.get('SendTOtheEmailAddressesFromThisCollectionOfUsers');
            String curEmail;
            for (User curUser : curUsers) {
                curEmail = curUser.email;
                if (curEmail != null) extractedEmailAddresses.add(curEmail);
            }
            addressList.addAll(extractedEmailAddresses);
            System.debug('address list is:' + addressList);
        }


        return addressList;

    }

    private static Map<String, Object> GenerateMap(Request request) {
       
        Map<String, Object> m = new Map<String, Object>{
           'SendTOthisOneEmailAddress' => request.SendTOthisOneEmailAddress,
           'SendTOthisStringCollectionOfEmailAddresses'  => request.SendTOthisStringCollectionOfEmailAddresses,
           'SendTOtheEmailAddressesFromThisCollectionOfContacts' => request.SendTOtheEmailAddressesFromThisCollectionOfContacts,
           'SendTOtheEmailAddressesFromThisCollectionOfUsers' => request.SendTOtheEmailAddressesFromThisCollectionOfUsers,
           'SendCCthisOneEmailAddress' => request.SendCCthisOneEmailAddress,
           'SendCCthisStringCollectionOfEmailAddresses'  => request.SendCCthisStringCollectionOfEmailAddresses,
           'SendCCtheEmailAddressesFromThisCollectionOfContacts' => request.SendCCtheEmailAddressesFromThisCollectionOfContacts,
           'SendCCtheEmailAddressesFromThisCollectionOfUsers' => request.SendCCtheEmailAddressesFromThisCollectionOfUsers,
           'SendBCCthisOneEmailAddress' => request.SendBCCthisOneEmailAddress,
           'SendBCCthisStringCollectionOfEmailAddresses'  => request.SendBCCthisStringCollectionOfEmailAddresses,
           'SendBCCtheEmailAddressesFromThisCollectionOfContacts' => request.SendBCCtheEmailAddressesFromThisCollectionOfContacts,
           'SendBCCtheEmailAddressesFromThisCollectionOfUsers' => request.SendBCCtheEmailAddressesFromThisCollectionOfUsers

       
       };
       
       return m;


    }

    //example
    //addressType is "TO"
    //inputType is ["String", "StringCollection", "ContactCollection", "UserCollection"]
    // iterate over the four values. for example, StringCollection
    //assemble the property name: "Send" + addressType + "This" + inputType + "ofEmailAddresses"
    //

    //meanwhile, in the requests, we have request[0].SendTOThisStringCollectionOfEmailAddresses
    //we want to read this value.
    //request.get('')





    public class Request {
        @invocableVariable
        public String body;

        @invocableVariable
        public String subject;

        @invocableVariable
        public String SendTOthisOneEmailAddress;

        @invocableVariable
        public List<String> SendTOthisStringCollectionOfEmailAddresses;

        @invocableVariable
        public List<Contact> SendTOtheEmailAddressesFromThisCollectionOfContacts;

        @invocableVariable
        public List<User> SendTOtheEmailAddressesFromThisCollectionOfUsers;

        @invocableVariable
        public String SendCCthisOneEmailAddress;

        @invocableVariable
        public List<String>  SendCCthisStringCollectionOfEmailAddresses;

        @invocableVariable
        public List<Contact> SendCCtheEmailAddressesFromThisCollectionOfContacts;

        @invocableVariable
        public List<User> SendCCtheEmailAddressesFromThisCollectionOfUsers;

        @invocableVariable
        public String SendBCCthisOneEmailAddress;

        @invocableVariable
        public List<String>  SendBCCthisStringCollectionOfEmailAddresses;

        @invocableVariable
        public List<Contact> SendBCCtheEmailAddressesFromThisCollectionOfContacts;

        @invocableVariable
        public List<User> SendBCCtheEmailAddressesFromThisCollectionOfUsers;

    }

    public class Response {
        @invocableVariable
        public String outputStr;

    }

   
}
