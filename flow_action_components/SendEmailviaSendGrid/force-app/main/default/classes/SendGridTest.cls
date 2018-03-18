@isTest
private class SendGridTest {

  private static final String USERNAME = 'username';
  private static final String PASSWORD = 'password';
  private static final String ENCODING = 'UTF-8';

  @isTest static void credentialsToWebFormat() {
    Sendgrid sendgrid = new SendGrid('username', 'password');
    
    String correct = 'api_user=username&api_key=password';
    system.assertEquals(correct, sendgrid.credentialsToWebFormat());
  }

  @isTest static void testSend() {
    SendGrid sendgrid = new SendGrid('username', 'password');
    SendGrid.Email email = new SendGrid.Email();
    email.addTo('to@mailinator.com');
    email.setFrom('from@mailinator.com');
    email.setSubject('Example');
    email.setText('Example text');

    Test.setMock(HttpCalloutMock.class, new SendGridResponseMock());
    SendGrid.SendGridResponse response = sendgrid.send(email);
    //system.assertEquals()
  }

  @isTest static void testAddTo() {
    SendGrid.Email email = new SendGrid.Email();

    String address = 'email@example.com';
    String address2 = 'email2@example.com';
    email.addTo(address);
    email.addTo(address2);

    String correct = '&x-smtpapi='+EncodingUtil.urlEncode('{"to":["email@example.com","email2@example.com"]}', ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testSetTos() {
    SendGrid.Email email = new SendGrid.Email();

    List<String> tos = new List<String> { 'setTos@mailinator.com' };
    email.setTos(tos);

    String correct = '&x-smtpapi='+EncodingUtil.urlEncode('{"to":["setTos@mailinator.com"]}', ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testAddToWithAFrom() {
    SendGrid.Email email = new SendGrid.Email();

    String address = 'email@example.com';
    String fromaddress = 'from@mailinator.com';
    email.addTo(address);
    email.setFrom(fromaddress);

    String correct = '&to=' + EncodingUtil.urlEncode(fromaddress, ENCODING) + '&from='+EncodingUtil.urlEncode(fromaddress, ENCODING)+'&x-smtpapi='+EncodingUtil.urlEncode('{"to":["email@example.com"]}', ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testSetFrom() {
    SendGrid.Email email = new SendGrid.Email();

    String address = 'email@example.com';
    email.setFrom(address);

    String correct = '&from='+EncodingUtil.urlEncode(address, ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testSetFromName() {
    SendGrid.Email email = new SendGrid.Email();

    String name = 'Example Lady';
    email.setFromName(name);

    String correct = '&fromname='+EncodingUtil.urlEncode(name, ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testSetReplyTo() {
    SendGrid.Email email = new SendGrid.Email();

    String address = 'email@example.com';
    email.setReplyTo(address);

    String correct = '&replyto='+EncodingUtil.urlEncode(address, ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testSetBcc() {
    SendGrid.Email email = new SendGrid.Email();

    String address = 'email@example.com';
    String address2 = 'email2@example.com';
    email.addBcc(address);
    email.addBcc(address2);

    String correct = '&bcc[]='+EncodingUtil.urlEncode(address, ENCODING)+'&bcc[]='+EncodingUtil.urlEncode(address2, ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testSetSubject() {
    SendGrid.Email email = new SendGrid.Email();

    String subject = 'A Subject';
    email.setSubject(subject);

    String correct = '&subject='+EncodingUtil.urlEncode(subject, ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testSetText() {
    SendGrid.Email email = new SendGrid.Email();

    String text = 'A message of an email.';
    email.setText(text);

    String correct = '&text='+EncodingUtil.urlEncode(text, ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testSetHtml() {
    SendGrid.Email email = new SendGrid.Email();

    String html = '<h1>This is an html email</h1>';
    email.setHtml(html);

    String correct = '&html='+EncodingUtil.urlEncode(html, ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testAddSubstitution() {
    SendGrid.Email email = new SendGrid.Email();

    List<String> vals = new List<String> { 'val' };
    email.addSubstitution('sub', vals);

    String correct = '&x-smtpapi='+EncodingUtil.urlEncode('{"sub":{"sub":["val"]}}', ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testAddUniqueArg() {
    SendGrid.Email email = new SendGrid.Email();

    email.addUniqueArg('add_unique_argument_key', 'add_unique_argument_value');
    email.addUniqueArg('add_unique_argument_key_2', 'add_unique_argument_value_2');

    String correct = '&x-smtpapi='+EncodingUtil.urlEncode('{"unique_args":{"add_unique_argument_key_2":"add_unique_argument_value_2","add_unique_argument_key":"add_unique_argument_value"}}', ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testAddCategory() {
    SendGrid.Email email = new SendGrid.Email();

    email.addCategory('Category 1');
    email.addCategory('Category 2');

    String correct = '&x-smtpapi='+EncodingUtil.urlEncode('{"category":["Category 1","Category 2"]}', ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testAddSection() {
    SendGrid.Email email = new SendGrid.Email();

    email.addSection('set_section_key', 'set_section_value');
    email.addSection('set_section_key_2', 'set_section_value_2');

    String correct = '&x-smtpapi='+EncodingUtil.urlEncode('{"section":{"set_section_key":"set_section_value","set_section_key_2":"set_section_value_2"}}', ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testAddFilter() {
    SendGrid.Email email = new SendGrid.Email();

    email.addFilter('footer', 'text/html', '<strong>boo</strong>');

    String correct = '&x-smtpapi='+EncodingUtil.urlEncode('{"filters":{"footer":{"settings":{"text/html":"<strong>boo</strong>"}}}}', ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testAddHeader() {
    SendGrid.Email email = new SendGrid.Email();

    email.addHeader('key', 'value');
    email.addHeader('other', 'other-value');

    String correct = '&headers='+EncodingUtil.urlEncode('{"key":"value","other":"other-value"}', ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testAddAttachmentStream() {
    SendGrid.Email email = new SendGrid.Email();

    String text = '{"key":"value","other":"other-value"}';
    email.addAttachmentStream('text.txt', text);

    String correct = '&files[text.txt]='+EncodingUtil.urlEncode(text, ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }

  @isTest static void testAddAttachmentStreamAsBlob() {
    SendGrid.Email email = new SendGrid.Email();

    String text = 'This is an attachment.';
    Blob as_blob = Blob.valueof(text);

    email.addAttachmentStream('text.txt', as_blob);

    String correct = '&files[text.txt]='+EncodingUtil.urlEncode(text, ENCODING);
    system.assertEquals(correct, email.toWebFormat());
  }
}