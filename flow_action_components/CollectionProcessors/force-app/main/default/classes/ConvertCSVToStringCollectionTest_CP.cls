@isTest
public with sharing class ConvertCSVToStringCollectionTest_CP{
    
    @isTest
    public static void canConvertString(){
        //String testString = 'foo,bar,baz';
        ConvertCSVToStringCollection_CP.Request testReq = new ConvertCSVToStringCollection_CP.Request();
        testReq.csvString = 'foo,bar,baz';

        List<ConvertCSVToStringCollection_CP.Request> testReqList = new List<ConvertCSVToStringCollection_CP.Request>();
        testReqList.add(testReq);

        List<ConvertCSVToStringCollection_CP.Response> testResponseList = ConvertCSVToStringCollection_CP.execute(testReqList);
     
        System.assertEquals(testResponseList[0].stringCollection[0], 'foo');
    }

    @isTest
    public static void canConvertStringWithDelimiter(){
        //String testString = 'foo,bar,baz';
        ConvertCSVToStringCollection_CP.Request testReq = new ConvertCSVToStringCollection_CP.Request();
        testReq.csvString = 'foo;bar;baz';
        testReq.delimiter = ';';

        List<ConvertCSVToStringCollection_CP.Request> testReqList = new List<ConvertCSVToStringCollection_CP.Request>();
        testReqList.add(testReq);

        List<ConvertCSVToStringCollection_CP.Response> testResponseList = ConvertCSVToStringCollection_CP.execute(testReqList);
     
        System.assertEquals(testResponseList[0].stringCollection[0], 'foo');
    }

    @isTest
    public static void canConvertStringCollection(){
        List<String> stringCollection = new List<String>();
        stringCollection.add('foo');
        stringCollection.add('bar');
        stringCollection.add('baz');
        // testString = 'foo,bar,baz';
        ConvertStringCollectionToCSV_CP.Request testReq = new ConvertStringCollectionToCSV_CP.Request();
        testReq.stringCollection =  stringCollection; //'foo,bar,baz';

        List<ConvertStringCollectionToCSV_CP.Request> testReqList = new List<ConvertStringCollectionToCSV_CP.Request>();
        testReqList.add(testReq);

        List<ConvertStringCollectionToCSV_CP.Response> testResponseList = ConvertStringCollectionToCSV_CP.execute(testReqList);
     
        System.assertEquals(testResponseList[0].csvString, 'foo,bar,baz');
    }

    @isTest
    public static void canConvertStringCollectionWithDelimiter(){
        List<String> stringCollection = new List<String>();
        stringCollection.add('foo');
        stringCollection.add('bar');
        stringCollection.add('baz');
        // testString = 'foo,bar,baz';
        ConvertStringCollectionToCSV_CP.Request testReq = new ConvertStringCollectionToCSV_CP.Request();
        testReq.stringCollection =  stringCollection; //'foo,bar,baz';
        testReq.delimiter = ';';

        List<ConvertStringCollectionToCSV_CP.Request> testReqList = new List<ConvertStringCollectionToCSV_CP.Request>();
        testReqList.add(testReq);

        List<ConvertStringCollectionToCSV_CP.Response> testResponseList = ConvertStringCollectionToCSV_CP.execute(testReqList);
     
        System.assertEquals(testResponseList[0].csvString, 'foo;bar;baz');
    }
}
