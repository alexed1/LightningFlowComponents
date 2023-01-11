@isTest
public with sharing class FlowsSelecterControllerTest {
    @isTest
    static void testGetFlowVersions() {
        List<FlowVersionView> flowList = FlowsSelecterController.getFlowVersions('Analyze_Flows');
        System.assert(flowList.size() > 0 );
    }
}
