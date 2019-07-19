@isTest
public with sharing class String_NumeralizeTests {

    @isTest
    public static void numeralizeWithCommas () {
        string inputString = '2349034';
        string type = 'commas';

        String_Numeralize.Request testRequest = new String_Numeralize.Request();
        List<String_Numeralize.Request> testRequestList = new List<String_Numeralize.Request>();
        testRequest.inputStr = '2349034';
        testRequest.type = 'commas';
        testRequestList.add(testRequest);
        List<String_Numeralize.Response> testResponseList = String_Numeralize.numeralize(testRequestList);
        String outputString = testResponseList[0].outputStr;
        System.assertEquals('2,349,034', outputString);
    }
}
