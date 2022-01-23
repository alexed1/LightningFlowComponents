@isTest
private class InvocableStringWizardTest {
  private static testMethod void testAbbreviate() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'abbreviate';
    curRequest1.mainString = 'Hello Maximillian';
    curRequest1.integer01 = 9;
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'abbreviate';
    curRequest2.mainString = 'Hello Maximillian';
    curRequest2.integer01 = 9;
    curRequest2.integer02 = 6;
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Hello ...', response[0].stringResult);
    System.AssertEquals('...Max...', response[1].stringResult);
    Test.stopTest();
  }
  private static testMethod void testCapitalize() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'capitalize';
    curRequest1.mainString = 'hello maximillian';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Hello maximillian', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testCenter() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'center';
    curRequest1.mainString = 'hello';
    curRequest1.integer01 = 9;
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'center';
    curRequest2.mainString = 'hello';
    curRequest2.integer01 = 9;
    curRequest2.string01 = '-';
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('  hello  ', response[0].stringResult);
    System.AssertEquals('--hello--', response[1].stringResult);
    Test.stopTest();
  }
  private static testMethod void testCharAt() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'charAt';
    curRequest1.mainString = 'Ω is Omega.';
    curRequest1.integer01 = 0;
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(937, response[0].integerResult);
    Test.stopTest();
  }
  private static testMethod void testCodePointAt() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'codePointAt';
    curRequest1.mainString =
      '\u03A9 is Ω (Omega), and \uD835\uDD0A ' + ' is Fraktur Capital G.';
    curRequest1.integer01 = 0;
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(937, response[0].integerResult);
    Test.stopTest();
  }
  private static testMethod void testCodePointBefore() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'codePointBefore';
    curRequest1.mainString =
      '\u03A9 is Ω (Omega), and \uD835\uDD0A ' + ' is Fraktur Capital G.';
    curRequest1.integer01 = 1;
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(937, response[0].integerResult);
    Test.stopTest();
  }
  private static testMethod void testCodePointCount() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'codePointCount';
    curRequest1.mainString = '\u03A9 and \uD835\uDD0A characters.';
    curRequest1.integer01 = 0;
    curRequest1.integer02 = 1;
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(1, response[0].integerResult);
    Test.stopTest();
  }
  private static testMethod void testCompareTo() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'compareTo';
    curRequest1.mainString = 'abcde';
    curRequest1.string01 = 'abcd';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(1, response[0].integerResult);
    Test.stopTest();
  }
  private static testMethod void testContains() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'contains';
    curRequest1.mainString = 'abcde';
    curRequest1.string01 = 'abcd';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testContainsAny() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'containsAny';
    curRequest1.mainString = 'hello';
    curRequest1.string01 = 'hx';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testContainsIgnoreCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'containsIgnoreCase';
    curRequest1.mainString = 'hello';
    curRequest1.string01 = 'HE';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testContainsNone() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'containsNone';
    curRequest1.mainString = 'abcde';
    curRequest1.string01 = 'fg';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testContainsOnly() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'containsOnly';
    curRequest1.mainString = 'abba';
    curRequest1.string01 = 'abcd';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testContainsWhitespace() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'containsWhitespace';
    curRequest1.mainString = 'HelloJane ';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testCountMatches() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'countMatches';
    curRequest1.mainString = 'Hello Jane ';
    curRequest1.string01 = 'Hello';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(1, response[0].integerResult);
    Test.stopTest();
  }
  private static testMethod void testDeleteWhitespace() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'deleteWhitespace';
    curRequest1.mainString = 'Hello Jane ';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('HelloJane', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testDifference() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'difference';
    curRequest1.mainString = 'Hello Jane';
    curRequest1.string01 = 'Hello Max';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Max', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testEndsWith() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'endsWith';
    curRequest1.mainString = 'Hello Jason';
    curRequest1.string01 = 'Jason';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testEndsWithIgnoreCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'endsWithIgnoreCase';
    curRequest1.mainString = 'Hello Jason';
    curRequest1.string01 = 'jason';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testEquals() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'equals';
    curRequest1.mainString = 'abcde';
    curRequest1.string01 = 'abcd';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(false, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testEqualsIgnoreCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'equalsIgnoreCase';
    curRequest1.mainString = 'abcde';
    curRequest1.string01 = 'ABCDE';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testEscapeCsv() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'escapeCsv';
    curRequest1.mainString = 'Max1, "Max2"';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('"Max1, ""Max2"""', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testEscapeEcmaScript() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'escapeEcmaScript';
    curRequest1.mainString = '"grade": 3.9/4.0';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('\\"grade\\": 3.9\\/4.0', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testEscapeHtml3() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'escapeHtml3';
    curRequest1.mainString = '"<Black&White>"';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(
      '&quot;&lt;Black&amp;White&gt;&quot;',
      response[0].stringResult
    );
    Test.stopTest();
  }
  private static testMethod void testEscapeHtml4() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'escapeHtml4';
    curRequest1.mainString = '"<Black&White>"';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(
      '&quot;&lt;Black&amp;White&gt;&quot;',
      response[0].stringResult
    );
    Test.stopTest();
  }
  private static testMethod void testEscapeJava() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'escapeJava';
    curRequest1.mainString = 'Company: "Salesforce.com"';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(
      'Company: \\"Salesforce.com\\"',
      response[0].stringResult
    );
    Test.stopTest();
  }
  private static testMethod void testEscapeSingleQuotes() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'escapeSingleQuotes';
    curRequest1.mainString = '\'Hello Jason\'';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('\\\'Hello Jason\\\'', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testEscapeUnicode() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'escapeUnicode';
    curRequest1.mainString = 'De onde você é?';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(
      'De onde voc\\u00EA \\u00E9?',
      response[0].stringResult
    );
    Test.stopTest();
  }
  private static testMethod void testEscapeXml() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'escapeXml';
    curRequest1.mainString = '"<Black&White>"';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.debug(response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testFromCharArray() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'fromCharArray';
    curRequest1.integerList = new List<Integer>{ 74 };
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('J', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testGetChars() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'getChars';
    curRequest1.mainString = 'Jane goes fishing.';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(74, response[0].integerListResult[0]);
    Test.stopTest();
  }
  private static testMethod void testGetCommonPrefix() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'getCommonPrefix';
    curRequest1.stringList = new List<String>{ 'SFDCApex', 'SFDCVisualforce' };
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('SFDC', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testGetLevenshteinDistance() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'getLevenshteinDistance';
    curRequest1.mainString = 'Hello Jane';
    curRequest1.string01 = 'Hello Max';
    curRequest1.integer01 = 2;
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'getLevenshteinDistance';
    curRequest2.mainString = 'Hello Jane';
    curRequest2.string01 = 'Hello Max';
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(-1, response[0].integerResult);
    System.AssertEquals(3, response[1].integerResult);
    Test.stopTest();
  }
  private static testMethod void testHashCode() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'hashCode';
    curRequest1.mainString = 'a';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(97, response[0].integerResult);
    Test.stopTest();
  }
  private static testMethod void testIndexOf() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'indexOf';
    curRequest1.mainString = 'abcdabcd';
    curRequest1.string01 = 'ab';
    curRequest1.integer01 = 1;
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'indexOf';
    curRequest2.mainString = 'abcde';
    curRequest2.string01 = 'cd';
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(4, response[0].integerResult);
    System.AssertEquals(2, response[1].integerResult);
    Test.stopTest();
  }
  private static testMethod void testIndexOfAny() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'indexOfAny';
    curRequest1.mainString = 'abcd';
    curRequest1.string01 = 'xc';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(2, response[0].integerResult);
    Test.stopTest();
  }
  private static testMethod void testIndexOfAnyBut() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'indexOfAnyBut';
    curRequest1.mainString = 'abcd';
    curRequest1.string01 = 'xc';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(0, response[0].integerResult);
    Test.stopTest();
  }
  private static testMethod void testIndexOfChar() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'indexOfChar';
    curRequest1.mainString = 'Ω and \\u03A9 and Ω';
    curRequest1.integer01 = 937;
    curRequest1.integer02 = 1;
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'indexOfChar';
    curRequest2.mainString = '\\u03A9 is Ω (Omega)';
    curRequest2.integer01 = 937;
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(17, response[0].integerResult);
    System.AssertEquals(10, response[1].integerResult);
    Test.stopTest();
  }
  private static testMethod void testIndexOfDifference() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'indexOfDifference';
    curRequest1.mainString = 'abcd';
    curRequest1.string01 = 'abxc';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(2, response[0].integerResult);
    Test.stopTest();
  }
  private static testMethod void testIndexOfIgnoreCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'indexOfIgnoreCase';
    curRequest1.mainString = 'abcd';
    curRequest1.string01 = 'BC';
    curRequest1.integer01 = 0;
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'indexOfIgnoreCase';
    curRequest2.mainString = 'abcd';
    curRequest2.string01 = 'BC';
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(1, response[0].integerResult);
    System.AssertEquals(1, response[1].integerResult);
    Test.stopTest();
  }
  private static testMethod void testIsAllLowerCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isAllLowerCase';
    curRequest1.mainString = 'abcde';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsAllUpperCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isAllUpperCase';
    curRequest1.mainString = 'ABCDE';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsAlpha() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isAlpha';
    curRequest1.mainString = 'abc 123';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(false, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsAlphaSpace() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isAlphaSpace';
    curRequest1.mainString = 'aA Bb';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsAlphanumeric() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isAlphanumeric';
    curRequest1.mainString = 'aA ';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(false, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsAlphanumericSpace() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isAlphanumericSpace';
    curRequest1.mainString = 'aA ';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsAsciiPrintable() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isAsciiPrintable';
    curRequest1.mainString = 'abcd1234!@#$%^&*()`~-_+={[}]|:<,>.?';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsBlank() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isBlank';
    curRequest1.mainString = null;
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsEmpty() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isEmpty';
    curRequest1.mainString = '';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsNotBlank() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isNotBlank';
    curRequest1.mainString = null;
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(false, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsNotEmpty() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isNotEmpty';
    curRequest1.mainString = '';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(false, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsNumeric() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isNumeric';
    curRequest1.mainString = '123';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsNumericSpace() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isNumericSpace';
    curRequest1.mainString = '123 456';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testIsWhitespace() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'isWhitespace';
    curRequest1.mainString = ' ';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testJoin() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    List<String> stringsInList = new List<String>{ 'a', 'b', 'c' };
    curRequest1.method = 'join';
    curRequest1.stringList = stringsInList;
    curRequest1.mainString = ',';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('a,b,c', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testLastIndexOf() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'lastIndexOf';
    curRequest1.mainString = 'abcdefgc';
    curRequest1.string01 = 'c';
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'lastIndexOf';
    curRequest2.mainString = 'abcdaacd';
    curRequest2.string01 = 'c';
    curRequest2.integer01 = 7;
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(7, response[0].integerResult);
    System.AssertEquals(6, response[1].integerResult);
    Test.stopTest();
  }
  private static testMethod void testLastIndexOfChar() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'lastIndexOfChar';
    curRequest1.mainString = '\u03A9 is Ω (Omega)';
    curRequest1.integer01 = 937;
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'lastIndexOfChar';
    curRequest2.mainString = 'Ω and \u03A9 and Ω';
    curRequest2.integer01 = 937;
    curRequest2.integer02 = 11;
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(5, response[0].integerResult);
    System.AssertEquals(6, response[1].integerResult);
    Test.stopTest();
  }
  private static testMethod void testLastIndexOfIgnoreCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'lastIndexOfIgnoreCase';
    curRequest1.mainString = 'abcdaacd';
    curRequest1.string01 = 'DAAC';
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'lastIndexOfIgnoreCase';
    curRequest2.mainString = 'abcdaacd';
    curRequest2.string01 = 'C';
    curRequest2.integer01 = 7;
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(3, response[0].integerResult);
    System.AssertEquals(6, response[1].integerResult);
    Test.stopTest();
  }
  private static testMethod void testLeft() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'left';
    curRequest1.mainString = 'abcdaacd';
    curRequest1.integer01 = 3;
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('abc', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testLeftPad() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'leftPad';
    curRequest1.mainString = 'abc';
    curRequest1.integer01 = 5;
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'leftPad';
    curRequest2.mainString = 'abc';
    curRequest2.integer01 = 7;
    curRequest2.string01 = 'xy';
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('  abc', response[0].stringResult);
    System.AssertEquals('xyxyabc', response[1].stringResult);
    Test.stopTest();
  }
  private static testMethod void testLength() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'length';
    curRequest1.mainString = 'abc';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(3, response[0].integerResult);
    Test.stopTest();
  }
  private static testMethod void testMid() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'mid';
    curRequest1.mainString = 'abcde';
    curRequest1.integer01 = 2;
    curRequest1.integer02 = 3;
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('cde', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testNormalizeSpace() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'normalizeSpace';
    curRequest1.mainString = 'Salesforce \t     force.com';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Salesforce force.com', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testOffsetByCodepoints() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'offsetByCodePoints';
    curRequest1.mainString = 'A \uD835\uDD0A BC';
    curRequest1.integer01 = 0;
    curRequest1.integer02 = 3;
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(4, response[0].integerResult);
    Test.stopTest();
  }
  private static testMethod void testRemove() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'remove';
    curRequest1.mainString = 'Salesforce and force.com';
    curRequest1.string01 = 'force';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Sales and .com', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testRemoveEnd() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'removeEnd';
    curRequest1.mainString = 'Salesforce and force.com';
    curRequest1.string01 = '.com';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Salesforce and force', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testRemoveEndIgnoreCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'removeEndIgnoreCase';
    curRequest1.mainString = 'Salesforce and force.com';
    curRequest1.string01 = '.COM';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Salesforce and force', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testRemoveStart() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'removeStart';
    curRequest1.mainString = 'Salesforce and force.com';
    curRequest1.string01 = 'Sales';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('force and force.com', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testRemoveStartIgnoreCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'removeStartIgnoreCase';
    curRequest1.mainString = 'Salesforce and force.com';
    curRequest1.string01 = 'SALES';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('force and force.com', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testRepeat() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'repeat';
    curRequest1.mainString = 'SFDC';
    curRequest1.integer01 = 2;
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'repeat';
    curRequest2.mainString = 'SFDC';
    curRequest2.integer01 = 2;
    curRequest2.string01 = '-';
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('SFDCSFDC', response[0].stringResult);
    System.AssertEquals('SFDC-SFDC', response[1].stringResult);
    Test.stopTest();
  }
  private static testMethod void testReplace() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'replace';
    curRequest1.mainString = 'abcdbca';
    curRequest1.string01 = 'bc';
    curRequest1.string02 = 'xy';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('axydxya', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testReplaceAll() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'replaceAll';
    curRequest1.mainString = 'a b c 5 xyz';
    curRequest1.string01 = '[a-zA-Z]';
    curRequest1.string02 = '1';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('1 1 1 5 111', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testReplaceFirst() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'replaceFirst';
    curRequest1.mainString = 'a b c 11 xyz';
    curRequest1.string01 = '[a-zA-Z]{2}';
    curRequest1.string02 = '2';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('a b c 11 2z', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testReverse() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'reverse';
    curRequest1.mainString = 'abc';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('cba', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testRight() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'right';
    curRequest1.mainString = 'Hello Max';
    curRequest1.integer01 = 3;
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Max', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testRightPad() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'rightPad';
    curRequest1.mainString = 'abc';
    curRequest1.integer01 = 5;
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'rightPad';
    curRequest2.mainString = 'abc';
    curRequest2.integer01 = 7;
    curRequest2.string01 = 'xy';
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('abc  ', response[0].stringResult);
    System.AssertEquals('abcxyxy', response[1].stringResult);
    Test.stopTest();
  }
  private static testMethod void testSplit() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'split';
    curRequest1.mainString = 'e:\\processed\\PPDSF100111.csv';
    curRequest1.string01 = '\\\\';
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'split';
    curRequest2.mainString = 'e:\\processed\\PPDSF100111.csv';
    curRequest2.integer01 = 2;
    curRequest2.string01 = '\\\\';
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('e:', response[0].stringListResult[0]);
    System.AssertEquals('e:', response[1].stringListResult[0]);
    Test.stopTest();
  }
  private static testMethod void testSplitByCharacterType() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'splitByCharacterType';
    curRequest1.mainString = 'Lightning.platform';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('L', response[0].stringListResult[0]);
    Test.stopTest();
  }
  private static testMethod void testSplitByCharacterTypeCamelCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'splitByCharacterTypeCamelCase';
    curRequest1.mainString = 'Lightning.platform';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Lightning', response[0].stringListResult[0]);
    Test.stopTest();
  }
  private static testMethod void testStartsWith() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'startsWith';
    curRequest1.mainString = 'AE86 vs EK9';
    curRequest1.string01 = 'AE86';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testStartsWithIgnoreCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'startsWithIgnoreCase';
    curRequest1.mainString = 'AE86 vs EK9';
    curRequest1.string01 = 'ae86';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals(true, response[0].booleanResult);
    Test.stopTest();
  }
  private static testMethod void testStripHtmlTags() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'stripHtmlTags';
    curRequest1.mainString = '<b>hello world</b>';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('hello world', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testSubstring() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'substring';
    curRequest1.mainString = 'hamburger';
    curRequest1.integer01 = 3;
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'substring';
    curRequest2.mainString = 'hamburger';
    curRequest2.integer01 = 4;
    curRequest2.integer02 = 8;
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('burger', response[0].stringResult);
    System.AssertEquals('urge', response[1].stringResult);
    Test.stopTest();
  }
  private static testMethod void testSubstringAfter() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'substringAfter';
    curRequest1.mainString = 'Salesforce.Lightning.platform';
    curRequest1.string01 = '.';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Lightning.platform', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testSubstringAfterLast() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'substringAfterLast';
    curRequest1.mainString = 'Salesforce.Lightning.platform';
    curRequest1.string01 = '.';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('platform', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testSubstringBefore() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'substringBefore';
    curRequest1.mainString = 'Salesforce.Lightning.platform';
    curRequest1.string01 = '.';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Salesforce', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testSubstringBeforeLast() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'substringBeforeLast';
    curRequest1.mainString = 'Salesforce.Lightning.platform';
    curRequest1.string01 = '.';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Salesforce.Lightning', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testSubstringBetween() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'substringBetween';
    curRequest1.mainString = 'tagYellowtag';
    curRequest1.string01 = 'tag';
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'substringBetween';
    curRequest2.mainString = 'xYellowy';
    curRequest2.string01 = 'x';
    curRequest2.string02 = 'y';
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Yellow', response[0].stringResult);
    System.AssertEquals('Yellow', response[1].stringResult);
    Test.stopTest();
  }
  private static testMethod void testSwapCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'swapCase';
    curRequest1.mainString = 'Force.com';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('fORCE.COM', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testToLowerCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'toLowerCase';
    curRequest1.mainString = 'ThIs iS hArD tO rEaD';
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'toLowerCase';
    curRequest2.mainString = 'KIYMETLİ';
    curRequest2.string01 = 'tr';
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('this is hard to read', response[0].stringResult);
    System.AssertEquals('kıymetli', response[1].stringResult);
    Test.stopTest();
  }
  private static testMethod void testToUpperCase() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'toUpperCase';
    curRequest1.mainString = 'abcd';
    requestList.add(curRequest1);
    InvocableStringWizard.Request curRequest2 = new InvocableStringWizard.Request();
    curRequest2.method = 'toUpperCase';
    curRequest2.mainString = 'imkansız';
    curRequest2.string01 = 'tr';
    requestList.add(curRequest2);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('ABCD', response[0].stringResult);
    System.AssertEquals('İMKANSIZ', response[1].stringResult);
    Test.stopTest();
  }
  private static testMethod void testTrim() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'trim';
    curRequest1.mainString = '   Hello!   ';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Hello!', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testUncapitalize() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'uncapitalize';
    curRequest1.mainString = 'Hello max';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('hello max', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testUnescapeCsv() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'unescapeCsv';
    curRequest1.mainString = '"Max1, ""Max2"""';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Max1, "Max2"', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testUnescapeEcmaScript() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'unescapeEcmaScript';
    curRequest1.mainString = '\"3.8\",\"3.9\"';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('"3.8","3.9"', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testUnescapeHtml3() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'unescapeHtml3';
    curRequest1.mainString = '&quot;&lt;Black&amp;White&gt;&quot;';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('"<Black&White>"', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testUnescapeHtml4() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'unescapeHtml4';
    curRequest1.mainString = '&quot;&lt;Black&amp;White&gt;&quot;';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('"<Black&White>"', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testUnescapeJava() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'unescapeJava';
    curRequest1.mainString = 'Company: \\"Salesforce.com\\"';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('Company: "Salesforce.com"', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testUnescapeUnicode() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'unescapeUnicode';
    curRequest1.mainString = 'De onde voc\u00EA \u00E9?';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('De onde você é?', response[0].stringResult);
    Test.stopTest();
  }
  private static testMethod void testUnescapeXml() {
    Test.startTest();
    List<InvocableStringWizard.Request> requestList = new List<InvocableStringWizard.Request>();
    InvocableStringWizard.Request curRequest1 = new InvocableStringWizard.Request();
    curRequest1.method = 'unescapeXml';
    curRequest1.mainString = '&quot;&lt;Black&amp;White&gt;&quot;';
    requestList.add(curRequest1);
    List<InvocableStringWizard.Response> response = InvocableStringWizard.Invoke(
      requestList
    );
    System.AssertEquals('"<Black&White>"', response[0].stringResult);
    Test.stopTest();
  }
}
