@isTest
public with sharing class FilterCollectionTest {
  
    @isTest
    public static void TestFilterCollectionAccount() {
        FilterCollection.Requests testRequest = new FilterCollection.Requests();
        
        Account fixture1 = new Account();
        fixture1.Name = 'bank1';
        fixture1.Industry = 'Banking';
        System.debug('testRequest: ' + testRequest);
        testRequest.sourceAccountCollection.add(fixture1);
        System.debug('sourceAccountCollection: ' + testRequest.sourceAccountCollection);  
        
        Account fixture2= new Account();
        fixture2.Name = 'bank2';
        fixture2.Industry = 'Banking';
        System.debug('testRequest2: ' + testRequest);
        testRequest.sourceAccountCollection.add(fixture2);
		System.debug('sourceAccountCollection2: ' + testRequest.sourceAccountCollection);  
        
        Account fixture3 = new Account();
        fixture3.Name = 'chemicals1';
        fixture3.Industry = 'Chemicals';
        testRequest.sourceAccountCollection.add(fixture3);

        Account fixture4 = new Account();
        fixture4.Name = 'food1';
        fixture4.Industry = 'Food';
        testRequest.sourceAccountCollection.add(fixture4);

        testRequest.targetValuesCSVString = 'Banking,Chemicals';
        testRequest.filterField = 'Industry';

        List<FilterCollection.Requests> testRequestList = new List<FilterCollection.Requests>();  
		testRequestList.add(testRequest);
        System.debug('testRequestList is: ' + testRequestList);
        List<FilterCollection.Results> testResponse = FilterCollection.filter(testRequestList);
        System.debug('testResponse is: ' + testResponse);
        System.assertEquals(3, testResponse[0].filteredAccountCollection.size());
    }
    
    @isTest
    public static void TestFilterCollectionCase() {
        FilterCollection.Requests testRequest = new FilterCollection.Requests();
        
        Case fixture1 = new Case();
        fixture1.Subject = 'bank1';
        fixture1.Origin = 'Email';
        System.debug('testRequest: ' + testRequest);
        testRequest.sourceCaseCollection.add(fixture1);
        System.debug('sourceCaseCollection: ' + testRequest.sourceCaseCollection);  
        
        Case fixture2= new Case();
        fixture2.Subject = 'bank2';
        fixture2.Origin = 'Email';
        System.debug('testRequest2: ' + testRequest);
        testRequest.sourceCaseCollection.add(fixture2);
		System.debug('sourceCaseCollection2: ' + testRequest.sourceCaseCollection);  
        
        Case fixture3 = new Case();
        fixture3.Subject = 'chemicals1';
        fixture3.Origin = 'Web';
        testRequest.sourceCaseCollection.add(fixture3);

        Case fixture4 = new Case();
        fixture4.Subject = 'food1';
        fixture4.Origin = 'Web';
        testRequest.sourceCaseCollection.add(fixture4);

        testRequest.targetValuesCSVString = 'Email';
        testRequest.filterField = 'Origin';

        List<FilterCollection.Requests> testRequestList = new List<FilterCollection.Requests>();  
		testRequestList.add(testRequest);
        System.debug('testRequestList is: ' + testRequestList);
        List<FilterCollection.Results> testResponse = FilterCollection.filter(testRequestList);
        System.debug('testResponse is: ' + testResponse);
        System.assertEquals(2, testResponse[0].filteredCaseCollection.size());
    }
}