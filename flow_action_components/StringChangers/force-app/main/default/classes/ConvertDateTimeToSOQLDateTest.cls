@isTest
public with sharing class ConvertDateTimeToSOQLDateTest {
    
    @isTest
    public static void CanConvertDate () {
        Datetime startDateTime = DateTime.newInstance(1993, 6, 6, 3, 3, 3);


        ConvertDateTimeToSOQLDate.Request testRequest = new ConvertDateTimeToSOQLDate.Request();
        List<ConvertDateTimeToSOQLDate.Request> testRequestList = new List<ConvertDateTimeToSOQLDate.Request>();
        
        testRequest.flowDateTime = startDateTime;
   
        testRequestList.add(testRequest);
        List<ConvertDateTimeToSOQLDate.Response> testResponseList = ConvertDateTimeToSOQLDate.convert(testRequestList);
        
        String outputString = testResponseList[0].soqlDateTimeString;
        //soql expects this format YYYY-MM-DDThh:mm:ss-hh:mm
        System.assertEquals('1993-06-06T03:03:03Z', outputString);

    }
}
