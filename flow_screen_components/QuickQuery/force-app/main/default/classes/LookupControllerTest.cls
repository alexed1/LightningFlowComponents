@isTest
public with sharing class LookupControllerTest {
    
    @isTest
    static void constructorCoverage(){
        List<String> inputListOfFileds = new List<String>();
        inputListOfFileds.add('FirstName');
        inputListOfFileds.add('LastName');
        new LookupSearchResult('String id', 'String sObjectType', 'String icon', 'String title', inputListOfFileds);
        LookupSearchResult toCompareFour = new LookupSearchResult('String id', 'String sObjectType', 'String icon', null, 'String title');
        LookupSearchResult toCompareThree = new LookupSearchResult('String id', 'String sObjectType', 'String icon', 'Set', 'String title');
        LookupSearchResult toCompareTwo = new LookupSearchResult('String id', 'String sObjectType', 'String icon', 'String titles', 'String title');
        LookupSearchResult toCompare = new LookupSearchResult('String id', 'String sObjectType', 'String icon', 'String title', 'String title', 'Custom value');
        LookupSearchResult maintest = new LookupSearchResult('String id', 'String sObjectType', 'String icon', 'String title', 'String subtitle', 'Custom value', inputListOfFileds);
        System.assertEquals('String id', maintest.getId());
        System.assertEquals('String sObjectType', maintest.getSObjectType());
        System.assertEquals('String icon', maintest.getIcon());
        System.assertEquals('String title', maintest.getTitle());
        System.assertEquals('String subtitle', maintest.getSubtitle());
        System.assertEquals('Custom value', maintest.getCustomValue()); 
        System.assertEquals(inputListOfFileds, maintest.getListOfFileds());
    }

    @isTest
    static void seachExistionObject() {
        List<String> selectedIds = new List<String>();
        List<LookupSearchResult> result = LookupController.search('Case', selectedIds);
    }

    @isTest
    static void seachNotExistionObject() {
        List<String> selectedIds = new List<String>();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        List<LookupSearchResult> result = LookupController.search('Casr', selectedIds);
        System.assertEquals(results, result);
    }

    @isTest
    static void seachNullExistionObject() {
        List<String> selectedIds = new List<String>();
        List<LookupSearchResult> result = LookupController.search(null, selectedIds);
        System.assertEquals(null, result);
    }
}