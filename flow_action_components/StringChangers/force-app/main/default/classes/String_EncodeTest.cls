@isTest
public with sharing class String_EncodeTest {
    
    @isTest
    public static void encodeSimpleString () {
        string inputString = 'Acme Corporation';
        string curEncoding = 'UTF-8';

        String_Encode.Request testRequest = new String_Encode.Request();
        List<String_Encode.Request> testRequestList = new List<String_Encode.Request>();
        testRequest.inputStr = inputString;
        testRequest.curEncoding = curEncoding;
        testRequestList.add(testRequest);
        List<String_Encode.Response> testResponseList = String_Encode.encodeStringForURL(testRequestList);
        String outputString = testResponseList[0].outputStr;
       System.assertEquals('Acme+Corporation', outputString);

    }
}
