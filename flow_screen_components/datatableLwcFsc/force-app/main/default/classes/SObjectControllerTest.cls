@isTest
public with sharing class SObjectControllerTest {

    static testMethod void test() {
		Account a1 = new Account(Name='Test1',
			AccountNumber='1',
            Website='https://trailblazer.me/id/ericsmith',
            Type='Type1',
			Description='D1');
        insert a1;
		Account a2 = new Account(Name='Test2',
			AccountNumber='2',
            Website='https://ericsplayground.wordpress.com/blog/',
            Type='Type2',
			Description='D2');
        insert a2;
        Account[] accts = [Select Id, Name, OwnerId from Account];
        String fieldnames = 'Name,Id,OwnerId,AccountNumber,Website,Type,Description,IsDeleted,CreatedDate,AnnualRevenue,NumberOfEmployees,Fax,LastActivityDate';
        String testResponse = SObjectController.getReturnResults(accts, fieldnames);
        System.assert(testResponse.contains('"noEditFieldList":["Type","Description"],"lookupFieldList":["OwnerId"]'));
    }

}
