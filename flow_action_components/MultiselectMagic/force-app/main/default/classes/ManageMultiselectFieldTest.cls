@isTest
public with sharing class ManageMultiselectFieldTest {

    

        private static ManageMultiselectField.Request initRequest() {
        //create an account. populate its fruit field. 
        //pass it to the invocable action as a record

        ManageMultiselectField.Request testRequest = new ManageMultiselectField.Request();
        List<ManageMultiselectField.Request> testRequestList = new List<ManageMultiselectField.Request>();

        Account testAcct1 = new Account();
        testAcct1.Name = 'testAcct1';
        testAcct1.Description = 'Apple;Strawberry;Rasberry';
        insert testAcct1;

        System.debug('fruit is: ' + testAcct1.Description);
        //instead Multipicklist field unit test use text type field to avoid dependence on custom fields
        testRequest.objectApiName='Account';
        testRequest.fieldApiName='Description';
        testRequest.curRecord = testAcct1;
        testRequest.operation = 'CheckForValue';
        testRequest.targetValue = 'Strawberry';

        return testRequest;
    }
    private static ManageMultiselectField.Response execute(ManageMultiselectField.Request testRequest) {
        List<ManageMultiselectField.Request> testRequestList = new List<ManageMultiselectField.Request>();
        testRequestList.add(testRequest);

        List<ManageMultiselectField.Response> testResponseList = ManageMultiselectField.execute(testRequestList);
        return testResponseList[0];
    }
    
    @isTest
    public static void canCheckForContainedValue() {
       
        ManageMultiselectField.Request testRequest = initRequest();
        ManageMultiselectField.Response testResponse = execute(testRequest);

        System.assertEquals(true, testResponse.targetPresent);

      
        testRequest.targetValue = 'foobar';
        testResponse = execute(testRequest);
        
        System.assertEquals(false, testResponse.targetPresent);


    }

    @isTest
    public static void canAddAValue() { 
        ManageMultiselectField.Request testRequest = initRequest();
        testRequest.targetValue = 'Pear';
        testRequest.operation = 'AddValue';
        ManageMultiselectField.Response testResponse = execute(testRequest);

        System.assertEquals('Apple;Strawberry;Rasberry;Pear', testResponse.selectedValuesSemicolonString);
        testRequest.targetValue = 'Foobar';
        try {
            testResponse = execute(testRequest);
        } catch(ManageMultiselectField.InvocableActionException e) {
            System.assert( e.getMessage().contains('The value: Foobaris not an allowed value for the picklist: Fruit__c in object: Account'), 
            e.getMessage() );
        }

    }

    @isTest
    public static void canRemoveAValue() { 
        ManageMultiselectField.Request testRequest = initRequest();
        testRequest.targetValue = 'Rasberry';
        testRequest.operation = 'RemoveValue';
        ManageMultiselectField.Response testResponse = execute(testRequest);

        System.assertEquals('Apple;Strawberry', testResponse.selectedValuesSemicolonString);
    }
}