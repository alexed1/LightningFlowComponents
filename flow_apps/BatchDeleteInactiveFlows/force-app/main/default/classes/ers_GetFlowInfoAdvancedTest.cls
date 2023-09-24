@isTest
public with sharing class ers_GetFlowInfoAdvancedTest {

    static testMethod void test() {

        ers_GetFlowInfoAdvanced.Requests testRequest = new ers_GetFlowInfoAdvanced.Requests();

        testRequest.typeSelection = 'Both';
        testRequest.statusSelection = 'Both';
        testRequest.lowerBoundary = '';
        testRequest.upperBoundary = '';
        testRequest.activeRowTheme = 'warning';

        List<ers_GetFlowInfoAdvanced.Requests> testRequestList = new List<ers_GetFlowInfoAdvanced.Requests>();
        testRequestList.add(testRequest);

        List<ers_GetFlowInfoAdvanced.Results> testResponseList = ers_GetFlowInfoAdvanced.getFlowDetails(testRequestList);
        system.debug('RESPONSE - '+testResponseList);
        
    }

}
