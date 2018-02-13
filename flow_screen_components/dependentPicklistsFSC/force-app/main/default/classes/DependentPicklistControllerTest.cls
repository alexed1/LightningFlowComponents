@isTest
public with sharing class DependentPicklistControllerTest {
    

	@isTest
    public static void getSelectOptionsTest() {
    	String objectName = 'Account';
    	String fld = 'Industry';

		Test.startTest();
		List<String> curOptions = DependentPicklistController.getSelectOptions( objectName, fld);
		Test.stopTest();

		System.assertEquals(32, curOptions.size());
    }
}

