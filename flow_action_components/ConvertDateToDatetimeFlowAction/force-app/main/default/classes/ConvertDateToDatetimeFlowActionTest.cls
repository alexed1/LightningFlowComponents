@isTest
public with sharing class ConvertDateToDatetimeFlowActionTest {
    
    static testMethod void test() {

        ConvertDateToDatetimeFlowAction.Requests testRequest = new ConvertDateToDatetimeFlowAction.Requests();

        testRequest.dateValue = Date.newInstance(1955, 5, 12);
        Datetime compareDT = Datetime.newInstance(1955, 5, 12, 0, 0, 0);

        List<ConvertDateToDatetimeFlowAction.Requests> testRequestList = new List<ConvertDateToDatetimeFlowAction.Requests>();
        testRequestList.add(testRequest);

        List<ConvertDateToDatetimeFlowAction.Results> testResponseList = ConvertDateToDatetimeFlowAction.convertDateToDatetime(testRequestList);
        system.assertEquals(compareDT, testResponseList[0].datetimeValue);


        testRequest.dateValue = Date.newInstance(1955, 5, 12);
        testRequest.hourValue = 1;
        testRequest.minuteValue = 2;
        testRequest.secondValue = 3;

        compareDT = Datetime.newInstance(1955, 5, 12, 1, 2, 3);

        testRequestList = new List<ConvertDateToDatetimeFlowAction.Requests>();
        testRequestList.add(testRequest);

        testResponseList = ConvertDateToDatetimeFlowAction.convertDateToDatetime(testRequestList);
        system.assertEquals(compareDT, testResponseList[0].datetimeValue);
    }

}
