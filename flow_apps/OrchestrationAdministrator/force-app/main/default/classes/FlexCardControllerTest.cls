@isTest
public with sharing class FlexCardControllerTest {
    
    @isTest
    public static void CanCallFlexCardController() {
        List<String> dummyStrings = new List<String>();
        Map<String,String> results = FlexCardController.getFlowLabel(dummyStrings);
        
        System.assertEquals(0, results.size());
        
    }
}