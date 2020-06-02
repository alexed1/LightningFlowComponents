@isTest
private class SortCollectionTest {
    /* 
     * API Data Types and Salesforce Field Types
     * https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/api_ui_datatype_map.htm
     * 
     * Testing Notes
     * 
     * API Data Type    UI Field Types              Notes
     * =============    ==========================  ===========================
     * ID               Lookup                      Tested. ID, AccountId FROM Contact.
     * Boolean          Checkbox                    Tested. HasOptedOutOfEmail FROM Contact.
     * Double           Currency                    Tested. ExpectedRevenue FROM Campaign.
     * Double           Number                      Tested. Double__c FROM ZTest__c.
     * Double           Percent                     Tested. ExpectedResponse FROM Campaign
     * Date             Date                        Tested. Birthdate FROM Contact.
     * Datetime         Datetime                    Tested. Datetime__c FROM ZTest__c; CreatedDate FROM Contact.
     *                                              CreatedDate from Contact might not provide much variance in values.
     * String           Email                       Tested. Email FROM Contact.
     * String           Phone                       Tested. Phone FROM Contact.
     * String           Picklist                    Tested. LeadSource FROM Contact. 
     *                                              SortCollection sorts picklists by API Name and not picklist order.
     * String           Text                        Tested. FirstName, LastName, Department FROM Contact.
     * Time             Time                        Tested. Time__c FROM ZTest__c.
     * 
     * ID               Master-detail Relationship  Not tested.
     * Decimal          ---                         Not tested.
     * Integer          ---                         Not tested.
     * Long             ---                         Not tested.
     * String           Auto Number                 Not tested.
     * String           Text Area                   Not tested.
     * String           Long Text Area              Not tested.
     * String           Multi-select picklist       Not tested.
     * String           Rich Text Area              Not tested.
     * String           Data Category Group         Not tested.
     * String           URL                         Not tested.
     */
    
    /*
     * The following SObject must be in your Salesforce environment to maximize
     * test coverage. If it is not present, some tests will be skipped.
     * Name: ZTest
     *    * If you use a different name, change CUSTOM_OBJECT_NAME.
     *    * API Name: ZTest__c
     *    * Deployment Status: Deployed
     *    * Sharing Model: 'ReadWrite'
     * Fields:
     *  * Time
     *    * Type: Time
     *    * API Name: Time__c
     *  * Datetime
     *    * Type: Datetime
     *    * API Name: Datetime__c
     *  * Double
     *    * Type: Number (10,8)
     *    * API Name: Double__c
     * 
     */
    static final String CUSTOM_OBJECT_NAME = 'ZTest'; // Do not provide the __c.
    static final String CUSTOM_OBJECT_API_NAME = CUSTOM_OBJECT_NAME.trim() + '__c';

    static final Integer NUM_ACCOUNTS = 11;
    static final Integer NUM_CAMPAIGNS = 13;
    static final Integer NUM_CONTACTS = 23;
    static final Integer NUM_CUSTOM_OBJECTS = 17;

    static final Boolean[] CHECKBOX_CHOICES = new Boolean[] {null, true, false};
    static final String[] LEAD_SOURCE_CHOICES = new String[] {null, 'Web', 'Phone Inquiry', 'Partner Referral', 'Purchased List', 'Other'};

    /**************************************************************************
     * Test Setup
     *************************************************************************/
    @testSetup static void makeData(){
        
        String character = 'A';
        Integer[] charCodes = character.getChars(); // [65]
        Integer aCharCode = charCodes[0];
        Integer zCharCode = 'Z'.getChars()[0];
        String nextCharacter = String.fromCharArray(new List<Integer> {aCharCode + 1}); // 66 = 'B'

        // Make Accounts
        List<Account> testAccounts = new List<Account>();
        for(Integer i=0; i < NUM_ACCOUNTS; i++) {
            String name = String.fromCharArray(new List<Integer> {aCharCode + Math.mod(i,26)});
            name = name + name; // AA, BB, CC, ...

            if (Math.mod(i,3) == 0) {
                testAccounts.add(new Account(Name = name));
            } else {
                testAccounts.add(new Account(Name = name,
                BillingStreet = i + ' Main St',
                BillingCity = 'San Narciso',
                BillingState = 'CA',
                BillingPostalCode = '92311',
                BillingLatitude = 34.9 + i/1000,
                BillingLongitude = -117.016667 + i/1000
                ));
            }
        }
        insert testAccounts;
        // Make Contacts
        List<Contact> testContacts = new List<Contact>();
        for(Integer i=0;i<NUM_CONTACTS;i++) { // best to limit i to 26 until better naming is created
            String firstNameCharacter = String.fromCharArray(new List<Integer> {aCharCode + Math.mod(i,26)});
            String lastNameCharacter = String.fromCharArray(new List<Integer> {zCharCode - Math.mod(i,26)});
            if (Math.mod(i,3) == 0) {
                testContacts.add(new Contact(LastName = lastNameCharacter));
            } else {
                testContacts.add(new Contact(LastName = lastNameCharacter, 
                    FirstName = 'John ' + firstNameCharacter,
                    AccountId = testAccounts[Math.mod(i,testAccounts.size())].Id,
                    Birthdate = Date.newInstance(1938, 1 + (Math.mod(i, 12)), 1 + Math.mod(i,29)),
                    Email = firstNameCharacter + '.' + lastNameCharacter + '@example.com',
                    HasOptedOutOfEmail = CHECKBOX_CHOICES[Math.mod(i,CHECKBOX_CHOICES.size())],
                    Phone= '1999' + String.valueOf(i).leftPad(7,'0'),
                    LeadSource = LEAD_SOURCE_CHOICES[Math.mod(i,LEAD_SOURCE_CHOICES.size())]
               ));
            }
        }
        insert testContacts;
        // Make Campaigns
        List<Campaign> testCampaigns = new List<Campaign>();
        for(Integer i=0; i< NUM_CAMPAIGNS; i++) {
            String name = String.fromCharArray(new List<Integer> {aCharCode + Math.mod(i,26)}) + (1 + Math.rint(i/26));
            if (Math.mod(i,3) == 0) {
                testCampaigns.add(new Campaign(Name=name));
            } else {
                testCampaigns.add(new Campaign(Name=name,
                ExpectedRevenue = i * 100, // Currency(18,0)
                ExpectedResponse = Math.mod(i,10) * 10 +  Math.mod(i,100)/100 // Percent(8,2)
                ));
            }
        }
        insert testCampaigns;

        // Make Test Objects for field types not covered above
        String customObjectApiName = CUSTOM_OBJECT_API_NAME;
        Schema.SObjectType t = Schema.getGlobalDescribe().get(customObjectApiName);
        System.debug('makeData() Schema.SObjectType t=' + t);

        if (t != null) {
            List<SObject> testSObjects = new List<SObject>();
            for (Integer i=0; i < NUM_CUSTOM_OBJECTS; i++) {
                String name = String.fromCharArray(new List<Integer> {aCharCode + Math.mod(i,26)}) + (1 + Math.rint(i/26));
                Double doub = i + i/1000 + i/100000;
                Datetime dt = Datetime.newInstance(2000, 1 + (Math.mod(i, 12)), 1 + Math.mod(i,29), 
                    Math.mod(i,24), Math.mod(i,60), Math.mod(i,60));
                SObject so = t.newSObject();
                so.put('Name',name);
                if (Math.mod(i,3) != 0) {
                    Time timeVal = Time.newInstance(Math.mod(i,24), Math.mod(i,60), Math.mod(i,60), Math.mod(i,1000)); //HH:mm:ss:S
                    so.put('Time__c', timeVal);
                    so.put('Double__c', doub);
                    so.put('Datetime__c', dt);
                }
                testSObjects.add(so);
            }
            insert testSObjects;
        }
    }

    /**************************************************************************
     * New Stuff field type tests
     * DECIMAL, INTEGER
     *************************************************************************/
   /*  @isTest static void testSortContactAccountIdDesc() {
        List<SObject> inputCollection = [SELECT Id, LastName, AccountId FROM Contact];
        testSortDoubleField(inputCollection, 'AccountId:DESC');
    } */
    /**************************************************************************
     * Checkbox field type tests
     ************************************D*************************************/
     /**
     * Email opt out fields will be null, true, and false
     */
    @isTest static void testSortBooleanContactEmailOptOutAsc() {
        List<SObject> inputCollection = [SELECT Id, LastName, HasOptedOutOfEmail FROM Contact];
        testSortBooleanField(inputCollection, 'HasOptedOutOfEmail:ASC');
    }
    @isTest static void testSortBooleanContactEmailOptOutDesc() {
        List<SObject> inputCollection = [SELECT Id, LastName, HasOptedOutOfEmail FROM Contact];
        testSortBooleanField(inputCollection, 'HasOptedOutOfEmail:DESC');
    }

    /**************************************************************************
     * Currency field type tests
     *************************************************************************/
    @isTest static void testSortCurrencyCampaignExpectedRevenueAsc() {
        List<SObject> inputCollection = [SELECT Id, Name, ExpectedRevenue FROM Campaign];
        testSortDecimalField(inputCollection, 'ExpectedRevenue:ASC');
    }
    @isTest static void testSortCurrencyCampaignExpectedRevenueDesc() {
        List<SObject> inputCollection = [SELECT Id, Name, ExpectedRevenue FROM Campaign];
        testSortDecimalField(inputCollection, 'ExpectedRevenue:DESC');
    }

    /**************************************************************************
     * Date field type tests
     *************************************************************************/
    @isTest static void testSortDateContactBirthdateAsc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, BirthDate FROM Contact];
        testSortDateField(inputCollection, 'Birthdate:ASC');
    }
    @isTest static void testSortDateContactBirthdateDesc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, BirthDate FROM Contact];
        testSortDateField(inputCollection, 'Birthdate:DESC');
    }

    /**************************************************************************
     * Datetime field type tests
     *************************************************************************/
    @isTest static void testSortCustomObjectDatetimeAsc() {
        System.assert(customSObjectExists(CUSTOM_OBJECT_API_NAME), 
            'MISSING_CUSTOM_SOBJECT - ' + CUSTOM_OBJECT_API_NAME + ' needed for testSortCustomObjectDatetimeAsc().');
        String query = String.format('SELECT Id, Name, Datetime__c FROM {0}', new List<Object>{CUSTOM_OBJECT_API_NAME});
        System.debug('testSortCustomObjectDoubleAsc.query=' + query);
        List<SObject> inputCollection = Database.query(query);
        testSortDatetimeField(inputCollection, 'Datetime__c:Asc');
    }
     @isTest static void testSortCustomObjectDatetimeDesc() {
        System.assert(customSObjectExists(CUSTOM_OBJECT_API_NAME), 
            'MISSING_CUSTOM_SOBJECT - ' + CUSTOM_OBJECT_API_NAME + ' needed for testSortCustomObjectDatetimeDesc().');
        String query = String.format('SELECT Id, Name, Datetime__c FROM {0}', new List<Object>{CUSTOM_OBJECT_API_NAME});
        System.debug('testSortCustomObjectDoubleAsc.query=' + query);
        List<SObject> inputCollection = Database.query(query);
        testSortDatetimeField(inputCollection, 'Datetime__c:DESC');
    }

    // CreatedDates will likely all be all be the same.
    @isTest static void testSortDatetimeContactCreatedDateAsc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, CreatedDate FROM Contact];
        testSortDatetimeField(inputCollection, 'CreatedDate:ASC');
    }
    // CreatedDates will likely all be all be the same.
    @isTest static void testSortDatetimeContactCreatedDateDesc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, CreatedDate FROM Contact];
        testSortDatetimeField(inputCollection, 'CreatedDate:DESC');
    }

    /**************************************************************************
     * Email Field Tests
     *************************************************************************/
    @isTest static void testSortStringContactEmailAscSomeNull() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, Email FROM Contact];
        testSortStringField(inputCollection, 'Email:ASC');
    }
    @isTest static void testSortStringContactEmailDescSomeNull() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, Email FROM Contact];
        testSortStringField(inputCollection, 'Email:DESC');
    }

    /**************************************************************************
     * Fax field type tests
     * The Fax opt out fields will all be null. 
     *************************************************************************/
    @isTest static void testSortBooleanContactFaxOptOutAscAllNull() {
        List<SObject> inputCollection = [SELECT Id, LastName, HasOptedOutOfFax FROM Contact];
        testSortBooleanField(inputCollection, 'HasOptedOutOfFax:ASC');
    }

    /**************************************************************************
     * Id field type tests - Ids are sorted as string; see string test.
     *************************************************************************/
    @isTest static void testSortStringContactIdAsc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName FROM Contact];
        testSortStringField(inputCollection, 'Id:ASC');
    }
    @isTest static void testSortIdContactIdDesc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName FROM Contact];
        testSortStringField(inputCollection, 'Id:DESC');
    }

    /**************************************************************************
     * Lookup (Reference) field type tests.
     *************************************************************************/
    @isTest static void testSortLookupContactIdDesc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, AccountId FROM Contact];
        testSortStringField(inputCollection, 'AccountId:DESC');
    }

    /**************************************************************************
     * Number(x,y) (Double) field type tests.
     *************************************************************************/
    @isTest static void testSortCustomObjectDoubleDesc() {
        System.assert(customSObjectExists(CUSTOM_OBJECT_API_NAME), 
            'MISSING_CUSTOM_SOBJECT - ' + CUSTOM_OBJECT_API_NAME + ' needed for testSortCustomObjectDoubleDesc().');
        String query = String.format('SELECT Id, Name, Double__c FROM {0}', new List<Object>{CUSTOM_OBJECT_API_NAME});
        System.debug('testSortCustomObjectDoubleAsc.query=' + query);
        List<SObject> inputCollection = Database.query(query);
        testSortDoubleField(inputCollection, 'Double__c:DESC');
    }

    /**************************************************************************
     * Time field type tests
     *************************************************************************/
    @isTest static void testSortCustomObjectTimeAsc() {
        System.assert(customSObjectExists(CUSTOM_OBJECT_API_NAME), 
            'MISSING_CUSTOM_SOBJECT - ' + CUSTOM_OBJECT_API_NAME + ' needed for testSortCustomObjectTimeAsc().');
        String query = String.format('SELECT Id, Time__c FROM {0}', new List<Object>{CUSTOM_OBJECT_API_NAME});
        System.debug('testSortCustomObjectTimeAsc.query=' + query);
        List<SObject> inputCollection = Database.query(query);
        testSortTimeField(inputCollection, 'Time__c:ASC');
    }
    @isTest static void testSortCustomObjectTimeDesc() {
        System.assert(customSObjectExists(CUSTOM_OBJECT_API_NAME), 
            'MISSING_CUSTOM_SOBJECT - ' + CUSTOM_OBJECT_API_NAME + ' needed for testSortCustomObjectTimeDesc().');
        String query = String.format('SELECT Id, Time__c FROM {0}', new List<Object>{CUSTOM_OBJECT_API_NAME});
        List<SObject> inputCollection = Database.query(query);
        testSortTimeField(inputCollection, 'Time__c:DESC');
    }

    /**************************************************************************
     * Percentage field type tests
     *************************************************************************/
    @isTest static void testSortPercentageCampaignExpectedResponseAsc() {
        List<SObject> inputCollection = [SELECT Id, Name, ExpectedResponse FROM Campaign];
        testSortDoubleField(inputCollection, 'ExpectedResponse:ASC');
    }
    @isTest static void testSortPercentageCampaignExpectedResponseDesc() {
        List<SObject> inputCollection = [SELECT Id, Name, ExpectedResponse FROM Campaign];
        testSortDoubleField(inputCollection, 'ExpectedResponse:DESC');
    }

    /**************************************************************************
     * Picklist field type tests
     *************************************************************************/
    @isTest static void testSortPicklistContactLeadAsc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, LeadSource FROM Contact];
        testSortStringField(inputCollection, 'LeadSource:ASC');
    }
    @isTest static void testSortPicklistContactLeadDesc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, LeadSource FROM Contact];
        testSortStringField(inputCollection, 'LeadSource:DESC');
    }

    /**************************************************************************
     * Phone Field Tests
     * The underlying data type of Phone is string; we will test anyways even
     * we already test strings with FirstName and LastName tests.
     *************************************************************************/
    @isTest static void testSortStringContactPhoneAsc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, Phone FROM Contact];
        testSortStringField(inputCollection, 'Phone:ASC');
    }
    @isTest static void testSortStringContactPhoneDesc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, Phone FROM Contact];
        testSortStringField(inputCollection, 'Phone:DESC');
    }

    /**************************************************************************
     * Text Field Tests
     *************************************************************************/
    /**
     * Every 3rd Contact FirstName should be null.
     */    
    @isTest static void testSortStringContactFirstNameAscSomeNull() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName FROM Contact];
        testSortStringField(inputCollection, 'FirstName:ASC');
    }
    /**
     * All the Contact's Department fields should be null since they are not set during the test setup.
     */
    @isTest static void testSortStringContactDepartmentAscAllNull() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, Department FROM Contact];
        testSortStringField(inputCollection, 'Department:ASC');
    }
    @isTest static void testSortStringContactLastNameAsc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName FROM Contact];
        testSortStringField(inputCollection, 'LastName:ASC');
    }
    @isTest static void testSortStringContactLastNameDesc() {
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName FROM Contact];
        testSortStringField(inputCollection, 'LastName:DESC');
    }

    /**************************************************************************
     * Test helpers
     *************************************************************************/
    static Boolean customSObjectExists (String apiName) {
        Schema.SObjectType t = Schema.getGlobalDescribe().get(apiName);
        return (t != null);
    }

    Time makeTime (String s) { 
        Time t = null;
        if (s != null) {
            List<String> timeTokens = s.split(':'); // Max 4 tokens
            t = Time.newInstance(timeTokens.size() >= 1 ? Integer.valueOf(timeTokens[0]) : 0, //hour
                                 timeTokens.size() >= 3 ? Integer.valueOf(timeTokens[1]) : 0, //min
                                 timeTokens.size() >= 3 ? Integer.valueOf(timeTokens[2]) : 0, //sec
                                 timeTokens.size() >= 4 ? Integer.valueOf(timeTokens[3]) : 0);//ms
        }
        return t;
    }

    static String makeAssertMsgTemplate (String fieldName, Boolean isDescending, String sortKey) {
        return String.format('previous.{0} ({3}) {1} current.{0} ({4}), sortKeys={2}.',
        new List<String> {fieldName,
            (isDescending ? '>=' : '<='), 
            sortKey,
            '{0}', 
            '{1}'});
    }

    static void testSortBooleanField(List<SObject> inputCollection, String sortKeys) {
        SortCollection.Requests requests = new SortCollection.Requests();
        List<SortCollection.Requests> requestsList = new List<SortCollection.Requests>();
        List<SortCollection.Results> resultsList = new List<SortCollection.Results>();

        // Configuration
        SObject previous = null;
        List<String> tokens = sortKeys.split(':');
        String fieldName = tokens[0];
        Boolean isDescending = (tokens[1] == 'DESC');
        String msgTemplate = makeAssertMsgTemplate(fieldName, isDescending, sortKeys);

        // Setup
        requests.inputCollection = inputCollection;
        requests.sortKeys = sortKeys;
        requestsList.add(requests);
        
        // Test
        Test.startTest();
        resultsList = SortCollection.sort(requestsList);
        Test.stopTest();
        
        // Validate
        System.assertNotEquals((List<SortCollection.Results>) null, resultsList, 'SortCollection.sort() returned null');
        System.assertEquals(1, resultsList.size(), 'SortCollection.sort().size() should 1, instead got ' + resultsList.size());
        List<SObject> outputCollection = resultsList[0].outputCollection;
        Integer i = 0;
        for (Sobject current : outputCollection)  {
            System.debug('testSortBooleanField() [' + i + '] current=' + JSON.serialize(current) + ', sortKeys=' + sortKeys);
            if (i == 0) {
                previous = current;
            } else {
                Boolean prevValue = previous.get(fieldName) == null ?
                    null : (Boolean) previous.get(fieldName); 
                Boolean curValue = current.get(fieldName) == null ? 
                   null : (Boolean) current.get(fieldName);
                List<Boolean> values = new List<Boolean> {prevValue,curValue};
                if (isDescending) {
                    System.assert((prevValue == curValue || curValue == null || prevValue && !curValue), 
                    String.format(msgTemplate, values));
                } else {
                    System.assert((prevValue == curValue || prevValue == null || !prevValue && curValue), 
                    String.format(msgTemplate, values));                    
                }
                previous = current;
            }
            i++;
        }
    }
 
    static void testSortDateField(List<SObject> inputCollection, String sortKeys) {
        SortCollection.Requests requests = new SortCollection.Requests();
        List<SortCollection.Requests> requestsList = new List<SortCollection.Requests>();
        List<SortCollection.Results> resultsList = new List<SortCollection.Results>();

        // Configuration
        SObject previous = null;
        List<String> tokens = sortKeys.split(':');
        String fieldName = tokens[0];
        Boolean isDescending = (tokens[1] == 'DESC');
        String msgTemplate = makeAssertMsgTemplate(fieldName, isDescending, sortKeys);

        // Setup
        requests.inputCollection = inputCollection;
        requests.sortKeys = sortKeys;
        requestsList.add(requests);
        
        // Test
        Test.startTest();
        resultsList = SortCollection.sort(requestsList);
        Test.stopTest();
        
        // Validate
        System.assertNotEquals((List<SortCollection.Results>) null, resultsList, 'SortCollection.sort() returned null');
        System.assertEquals(1, resultsList.size(), 'SortCollection.sort().size() should 1, instead got ' + resultsList.size());
        List<SObject> outputCollection = resultsList[0].outputCollection;
        Integer i = 0;
        for (Sobject current : outputCollection)  {
            System.debug('testSortDateField() [' + i + '] current=' + JSON.serialize(current) + ', sortKeys=' + sortKeys);
            if (i == 0) {
                previous = current;
            } else {
                Date prevValue = previous.get(fieldName) == null ?
                    null : (Date) previous.get(fieldName); 
                Date curValue = current.get(fieldName) == null ? 
                   null : (Date) current.get(fieldName);
                List<Date> values = new List<Date> {prevValue,curValue};
                if (isDescending) {
                    System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                    String.format(msgTemplate, values));
                } else {
                    System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                    String.format(msgTemplate, values));                    
                }
                previous = current;
            }
            i++;
        }
    }

    static void testSortDatetimeField(List<SObject> inputCollection, String sortKeys) {
        SortCollection.Requests requests = new SortCollection.Requests();
        List<SortCollection.Requests> requestsList = new List<SortCollection.Requests>();
        List<SortCollection.Results> resultsList = new List<SortCollection.Results>();

        // Configuration
        SObject previous = null;
        List<String> tokens = sortKeys.split(':');
        String fieldName = tokens[0];
        Boolean isDescending = (tokens[1] == 'DESC');
        String msgTemplate = makeAssertMsgTemplate(fieldName, isDescending, sortKeys);

        // Setup
        requests.inputCollection = inputCollection;
        requests.sortKeys = sortKeys;
        requestsList.add(requests);
        
        // Test
        Test.startTest();
        resultsList = SortCollection.sort(requestsList);
        Test.stopTest();
        
        // Validate
        System.assertNotEquals((List<SortCollection.Results>) null, resultsList, 'SortCollection.sort() returned null');
        System.assertEquals(1, resultsList.size(), 'SortCollection.sort().size() should 1, instead got ' + resultsList.size());
        List<SObject> outputCollection = resultsList[0].outputCollection;
        Integer i = 0;
        for (Sobject current : outputCollection)  {
            System.debug('testSortDatetimeField() [' + i + '] current=' + JSON.serialize(current) + ', sortKeys=' + sortKeys);
            if (i == 0) {
                previous = current;
            } else {
                Datetime prevValue = previous.get(fieldName) == null ?
                    null : (Datetime) previous.get(fieldName); 
                Datetime curValue = current.get(fieldName) == null ? 
                   null : (Datetime) current.get(fieldName);
                List<Datetime> values = new List<Datetime> {prevValue,curValue};
                if (isDescending) {
                    System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                    String.format(msgTemplate, values));
                } else {
                    System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                    String.format(msgTemplate, values));                    
                }
                previous = current;
            }
            i++;
        }
    }

    static void testSortDecimalField(List<SObject> inputCollection, String sortKeys) {
        SortCollection.Requests requests = new SortCollection.Requests();
        List<SortCollection.Requests> requestsList = new List<SortCollection.Requests>();
        List<SortCollection.Results> resultsList = new List<SortCollection.Results>();

        // Configuration
        SObject previous = null;
        List<String> tokens = sortKeys.split(':');
        String fieldName = tokens[0];
        Boolean isDescending = (tokens[1] == 'DESC');
        String msgTemplate = makeAssertMsgTemplate(fieldName, isDescending, sortKeys);

        // Setup
        requests.inputCollection = inputCollection;
        requests.sortKeys = sortKeys;
        requestsList.add(requests);
        
        // Test
        Test.startTest();
        resultsList = SortCollection.sort(requestsList);
        Test.stopTest();
        
        // Validate
        System.assertNotEquals((List<SortCollection.Results>) null, resultsList, 'SortCollection.sort() returned null');
        System.assertEquals(1, resultsList.size(), 'SortCollection.sort().size() should 1, instead got ' + resultsList.size());
        List<SObject> outputCollection = resultsList[0].outputCollection;
        Integer i = 0;
        for (Sobject current : outputCollection)  {
            System.debug('testSortDecimalField() [' + i + '] current=' + JSON.serialize(current) + ', sortKeys=' + sortKeys);
            if (i == 0) {
                previous = current;
            } else {
                Decimal prevValue = previous.get(fieldName) == null ?
                    null : (Decimal) previous.get(fieldName); 
                Decimal curValue = current.get(fieldName) == null ? 
                   null : (Decimal) current.get(fieldName);
                List<Decimal> values = new List<Decimal> {prevValue,curValue};
                if (isDescending) {
                    System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                    String.format(msgTemplate, values));
                } else {
                    System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                    String.format(msgTemplate, values));                    
                }
                previous = current;
            }
            i++;
        }
    }

    static void testSortDoubleField(List<SObject> inputCollection, String sortKeys) {
        SortCollection.Requests requests = new SortCollection.Requests();
        List<SortCollection.Requests> requestsList = new List<SortCollection.Requests>();
        List<SortCollection.Results> resultsList = new List<SortCollection.Results>();

        // Configuration
        SObject previous = null;
        List<String> tokens = sortKeys.split(':');
        String fieldName = tokens[0];
        Boolean isDescending = (tokens[1] == 'DESC');
        String msgTemplate = makeAssertMsgTemplate(fieldName, isDescending, sortKeys);

        // Setup
        requests.inputCollection = inputCollection;
        requests.sortKeys = sortKeys;
        requestsList.add(requests);
        
        // Test
        Test.startTest();
        resultsList = SortCollection.sort(requestsList);
        Test.stopTest();
        
        // Validate
        System.assertNotEquals((List<SortCollection.Results>) null, resultsList, 'SortCollection.sort() returned null');
        System.assertEquals(1, resultsList.size(), 'SortCollection.sort().size() should 1, instead got ' + resultsList.size());
        List<SObject> outputCollection = resultsList[0].outputCollection;
        Integer i = 0;
        for (Sobject current : outputCollection)  {
            System.debug('testSortDoubleField() [' + i + '] current=' + JSON.serialize(current) + ', sortKeys=' + sortKeys);
            if (i == 0) {
                previous = current;
            } else {
                Double prevValue = previous.get(fieldName) == null ?
                    null : (Double) previous.get(fieldName); 
                Double curValue = current.get(fieldName) == null ? 
                   null : (Double) current.get(fieldName);
                List<Double> values = new List<Double> {prevValue,curValue};
                if (isDescending) {
                    System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                    String.format(msgTemplate, values));
                } else {
                    System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                    String.format(msgTemplate, values));                    
                }
                previous = current;
            }
            i++;
        }
    }

    static void testSortStringField(List<SObject> inputCollection, String sortKeys) {
        SortCollection.Requests requests = new SortCollection.Requests();
        List<SortCollection.Requests> requestsList = new List<SortCollection.Requests>();
        List<SortCollection.Results> resultsList = new List<SortCollection.Results>();

        // Configuration
        SObject previous = null;
        List<String> tokens = sortKeys.split(':');
        String fieldName = tokens[0];
        Boolean isDescending = (tokens[1] == 'DESC');
        String msgTemplate = makeAssertMsgTemplate(fieldName, isDescending, sortKeys);

        // Setup
        requests.inputCollection = inputCollection;
        requests.sortKeys = sortKeys;
        requestsList.add(requests);
        
        // Test
        Test.startTest();
        resultsList = SortCollection.sort(requestsList);
        Test.stopTest();
        
        // Validate
        System.assertNotEquals((List<SortCollection.Results>) null, resultsList, 'SortCollection.sort() returned null');
        System.assertEquals(1, resultsList.size(), 'SortCollection.sort().size() should 1, instead got ' + resultsList.size());
        List<SObject> outputCollection = resultsList[0].outputCollection;
        Integer i = 0;
        for (Sobject current : outputCollection)  {
            System.debug('testSortStringField() [' + i + '] current=' + JSON.serialize(current) + ', sortKeys=' + sortKeys);
            if (i == 0) {
                previous = current;
            } else {
                String prevValue = previous.get(fieldName) == null ?
                    null : (String) previous.get(fieldName); 
                    String curValue = current.get(fieldName) == null ? 
                   null : (String) current.get(fieldName);
                List<String> values = new List<String> {prevValue,curValue};
                if (isDescending) {
                    System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                    String.format(msgTemplate, values));
                } else {
                    System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                    String.format(msgTemplate, values));                    
                }
                previous = current;
            }
            i++;
        }
    }

    static void testSortTimeField(List<SObject> inputCollection, String sortKeys) {
        SortCollection.Requests requests = new SortCollection.Requests();
        List<SortCollection.Requests> requestsList = new List<SortCollection.Requests>();
        List<SortCollection.Results> resultsList = new List<SortCollection.Results>();

        // Configuration
        SObject previous = null;
        List<String> tokens = sortKeys.split(':');
        String fieldName = tokens[0];
        Boolean isDescending = (tokens[1] == 'DESC');
        String msgTemplate = makeAssertMsgTemplate(fieldName, isDescending, sortKeys);

        // Setup
        requests.inputCollection = inputCollection;
        requests.sortKeys = sortKeys;
        requestsList.add(requests);
        
        // Test
        Test.startTest();
        resultsList = SortCollection.sort(requestsList);
        Test.stopTest();
        
        // Validate
        System.assertNotEquals((List<SortCollection.Results>) null, resultsList, 'SortCollection.sort() returned null');
        System.assertEquals(1, resultsList.size(), 'SortCollection.sort().size() should 1, instead got ' + resultsList.size());
        List<SObject> outputCollection = resultsList[0].outputCollection;
        Integer i = 0;
        for (Sobject current : outputCollection)  {
            System.debug('testSortTimeField() [' + i + '] current=' + JSON.serialize(current) + ', sortKeys=' + sortKeys);
            if (i == 0) {
                previous = current;
            } else {
                Time prevValue = previous.get(fieldName) == null ?
                    null : (Time) previous.get(fieldName); 
                Time curValue = current.get(fieldName) == null ? 
                   null : (Time) current.get(fieldName);
                List<Time> values = new List<Time> {prevValue,curValue};
                if (isDescending) {
                    System.assert((prevValue == curValue || curValue == null || prevValue > curValue), 
                    String.format(msgTemplate, values));
                } else {
                    System.assert((prevValue == curValue || prevValue == null || prevValue < curValue), 
                    String.format(msgTemplate, values));                    
                }
                previous = current;
            }
            i++;
        }
    }
}
