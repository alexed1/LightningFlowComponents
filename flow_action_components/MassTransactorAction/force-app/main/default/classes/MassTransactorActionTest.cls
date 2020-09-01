/**
 * @description       : 
 * @author            : Adam White, CapTech Consulting
 * @group             : 
 * @last modified on  : 08-18-2020
 * @last modified by  : Adam White, CapTech Consulting
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   08-18-2020   Adam White, CapTech Consulting		 Initial Version
**/
@IsTest
global with sharing class MassTransactorActionTest{

    @TestSetup
    static void makeData(){
        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York',
				billingcountry='USA',
        		billingState = 'Virginia',
				billingPostalCode = '23113',
				BillingStreet = '12345 Hello Lane'));
        }
        insert accounts;        
    }
    
@IsTest
    static void createRecords(){
        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York',
				billingcountry='USA',
        		billingState = 'Virginia',
           		billingPostalCode = '23113',
           		BillingStreet = '12345 Hello Lane'));
        }
        List<MassTransactorAction.InvocableApexAsyncBatchRequest> flowRequests = new List<MassTransactorAction.InvocableApexAsyncBatchRequest>();
        MassTransactorAction.InvocableApexAsyncBatchRequest flowRequest = new MassTransactorAction.InvocableApexAsyncBatchRequest();
        flowRequest.BatchSize = 220;
        flowRequest.OperationType = 'Create';
        flowRequest.RequestList = accounts;
        flowRequests.add(flowRequest);
        Test.startTest();
        MassTransactorAction.InvocableApexCreateAsyncController(flowRequests);
        Test.stopTest();
    }
@IsTest
    static void deleteRecords(){
        List<Account> accounts = [SELECT Id from Account Where Name like '%Account%'];
        List<MassTransactorAction.InvocableApexAsyncBatchRequest> flowRequests = new List<MassTransactorAction.InvocableApexAsyncBatchRequest>();
        MassTransactorAction.InvocableApexAsyncBatchRequest flowRequest = new MassTransactorAction.InvocableApexAsyncBatchRequest();
        flowRequest.BatchSize = 220;
        flowRequest.OperationType = 'Delete';
        flowRequest.RequestList = accounts;
        flowRequests.add(flowRequest);
        Test.startTest();
        MassTransactorAction.InvocableApexCreateAsyncController(flowRequests);
        Test.stopTest();
        
    }
@IsTest
    static void testBatchLimit(){
        List<Account> accounts = [SELECT Id from Account Where Name like '%Account%'];
        List<MassTransactorAction.InvocableApexAsyncBatchRequest> flowRequests = new List<MassTransactorAction.InvocableApexAsyncBatchRequest>();
        MassTransactorAction.InvocableApexAsyncBatchRequest flowRequest = new MassTransactorAction.InvocableApexAsyncBatchRequest();
        flowRequest.BatchSize = 2220;
        flowRequest.OperationType = 'Delete';
        flowRequest.RequestList = accounts;
        flowRequests.add(flowRequest);
        Test.startTest();
        MassTransactorAction.InvocableApexCreateAsyncController(flowRequests);
        Test.stopTest();
        
    }
@IsTest
    // Test creating some records where records already exist
    static void testBatchWrongDMLCreate(){
        List<Account> accounts = [SELECT Id from Account Where Name like '%Account%'];
        List<MassTransactorAction.InvocableApexAsyncBatchRequest> flowRequests = new List<MassTransactorAction.InvocableApexAsyncBatchRequest>();
        MassTransactorAction.InvocableApexAsyncBatchRequest flowRequest = new MassTransactorAction.InvocableApexAsyncBatchRequest();
        flowRequest.BatchSize = 200;
        flowRequest.OperationType = 'Create';
        flowRequest.RequestList = accounts;
        flowRequests.add(flowRequest);
        Test.startTest();
        MassTransactorAction.InvocableApexCreateAsyncController(flowRequests);
        Test.stopTest();
        
    }
@IsTest
    // Test creating some records where records dont exist
    static void testBatchWrongDMLDelete(){
		List<Account> accounts = new List<Account>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York',
				billingcountry='USA',
        		billingState = 'Virginia',
           		billingPostalCode = '23113',
           		BillingStreet = '12345 Hello Lane'));
        }
        List<MassTransactorAction.InvocableApexAsyncBatchRequest> flowRequests = new List<MassTransactorAction.InvocableApexAsyncBatchRequest>();
        MassTransactorAction.InvocableApexAsyncBatchRequest flowRequest = new MassTransactorAction.InvocableApexAsyncBatchRequest();
        flowRequest.BatchSize = 200;
        flowRequest.OperationType = 'Delete';
        flowRequest.RequestList = accounts;
        flowRequests.add(flowRequest);
        Test.startTest();
        MassTransactorAction.InvocableApexCreateAsyncController(flowRequests);
        Test.stopTest();
        
    }

        @IsTest
    // Test creating some records where records dont exist
    static void testBatchNull(){
		List<Account> accounts = new List<Account>();
        List<MassTransactorAction.InvocableApexAsyncBatchRequest> flowRequests = new List<MassTransactorAction.InvocableApexAsyncBatchRequest>();
        MassTransactorAction.InvocableApexAsyncBatchRequest flowRequest = new MassTransactorAction.InvocableApexAsyncBatchRequest();
        flowRequest.BatchSize = 200;
        flowRequest.OperationType = 'Delete';
        flowRequest.RequestList = accounts;
        flowRequests.add(flowRequest);
        Test.startTest();
        MassTransactorAction.InvocableApexCreateAsyncController(flowRequests);
        Test.stopTest();
    
		}
}