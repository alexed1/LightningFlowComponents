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
     * Double           Percent                     Tested. ExpectedResponse FROM Campaign.
     * Date             Date                        Tested. Birthdate FROM Contact.
     * Datetime         Datetime                    Tested. Datetime__c FROM Contract; CreatedDate FROM Contact.
     *                                              CreatedDate from Contact might not provide much variance in values.
     * Decimal          ---                         Tested. getComparable and DecimalComparable directly tested. SObject fields not tested.
     * Integer          ---                         Tested. getComparable and DoubleComparable directly tested. SObject fields not tested.
     * Long             ---                         Tested. getComparable and DoubleComparable directly tested. SObject fields not tested.
     * String           Email                       Tested. Email FROM Contact.
     * String           Phone                       Tested. Phone FROM Contact.
     * String           Picklist                    Tested. LeadSource FROM Contact. 
     *                                              SortCollection sorts picklists by API Name and not picklist order.
     * String           Text                        Tested. FirstName, LastName, Department FROM Contact.
     * Time             Time                        Tested. getComparable and TimeComparable directly tested. SObject fields not tested.
     * ---              ---                         -----------
     * ID               Master-detail Relationship  Not tested. However, ID (Lookup) was tested.
     * String           Auto Number                 Not tested. However, other String UI field types tested.
     * String           Text Area                   Not tested. However, other String UI field types tested.
     * String           Long Text Area              Not tested. However, other String UI field types tested.
     * String           Multi-select picklist       Not tested. However, other String UI field types tested.
     * String           Rich Text Area              Not tested. However, other String UI field types tested.
     * String           Data Category Group         Not tested. However, other String UI field types tested.
     * String           URL                         Not tested. However, other String UI field types tested.
     */

    static final Integer NUM_ACCOUNTS = 11;
    static final Integer NUM_CAMPAIGNS = 13;
    static final Integer NUM_CONTACTS = 23;
    static final Integer NUM_CONTRACTS = 7;
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
        // Make Contracts for DateTime tests
        List<Contract> testContracts = new List<Contract>();
        for(Integer i=0; i< NUM_CONTRACTS; i++) {
            String name = String.fromCharArray(new List<Integer> {aCharCode + Math.mod(i,26)}) + (1 + Math.rint(i/26));
            if (Math.mod(i,3) == 0) {
                testContracts.add(new Contract(Name=name,
                    AccountId = testAccounts[Math.mod(i,NUM_ACCOUNTS)].Id,
                    ContractTerm = i + 1,
                    Status = 'Draft'
                    ));
            } else {
                testContracts.add(new Contract(Name=name,
                    AccountId = testAccounts[Math.mod(i,NUM_ACCOUNTS)].Id,
                    ContractTerm = i+1,
                    Status = 'Draft'
                    ));
            }
        }
        insert testContracts;
        // Change the ActivatedDates
        for(Integer i=0; i< NUM_CONTRACTS; i++) {
            Datetime dt = Datetime.newInstance(2019, 1 + (Math.mod(i, 12)), 1 + Math.mod(i,29), 
                Math.mod(i,24), Math.mod(i,60), Math.mod(i,60));
            testContracts[i].Status = 'Activated';
            testContracts[i].ActivatedDate = dt;
        }
        upsert testContracts;
    }

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
    @isTest static void testSortDatetimeContractActivatedDateAsc() {
        List<SObject> inputCollection = [SELECT Id, ActivatedDate FROM Contract];
        testSortDatetimeField(inputCollection, 'ActivatedDate:ASC');
    }
    @isTest static void testSortDatetimeContractActivatedDateDesc() {
        List<SObject> inputCollection = [SELECT Id, ActivatedDate FROM Contract];
        testSortDatetimeField(inputCollection, 'ActivatedDate:DESC');
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
    // See testDoubleCompableIntegerFieldType

    /**************************************************************************
     * Time field type tests
     *************************************************************************/
    // See testTimeComparable

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

    /*
     * Further coverage
     */
    @isTest static void testBulkification() {
        Integer numRows;
        List<SortCollection.Requests> requestsList = new List<SortCollection.Requests>();

        for (Integer i; i < Math.min(7, NUM_CONTACTS); i++) {
            SortCollection.Requests requests = new SortCollection.Requests();
            numRows = i + 1;
            requests.inputCollection = [SELECT Id, LastName, FirstName FROM Contact LIMIT :numRows]; 
            // Have varying lengths to detect if results match up as expected
            requests.sortKeys = (Math.mod(i,3) == 0) ? 'LastName:ASC' : 'LastName:DESC';
            requestsList.add(requests);
        }
        testBulkSortStringField(requestsList);
    }

    @isTest static void testSortableWrapperCompareToUnsupportedType() {
        
        List<SObject> inputCollection = [SELECT Id, LastName, FirstName, Department FROM Contact LIMIT 2];
        System.debug('inputCollection.size() ' + inputCollection.size());
        Test.startTest();
        SortCollection.SortableWrapper sw0 = new SortCollection.SortableWrapper(inputCollection[0], 'LastName', 1, 'UnsupportedType');
        SortCollection.SortableWrapper sw1 = new SortCollection.SortableWrapper(inputCollection[1], 'LastName', 1, 'STRING');
        //sw0.orig = null;
        Integer retval = sw0.compareTo(sw1);
        Test.stopTest();

        System.assertEquals(0,retval);
    }
    @isTest static void testBooleanComparable () {
        Boolean t = true;
        Boolean f = false;
        List<Integer> actuals = new List<Integer>();
        List<Integer> expectations = new List<Integer>{0,0,1,-1,0,-1,-1,1,1};
        Test.startTest();
        Comparable tc = SortCollection.getComparable('BOOLEAN', (Object) t);
        Comparable fc = SortCollection.getComparable('BOOLEAN', (Object) f);
        Comparable nc = SortCollection.getComparable('BOOLEAN', null);
        actuals.add(tc.compareTo(t)); // expect 0, true = true
        actuals.add(fc.compareTo(f)); // expect 0, false = false
        actuals.add(tc.compareTo(false)); // expect 1, true > false
        actuals.add(fc.compareTo(true));  // expect -1, false < true
        actuals.add(nc.compareTo(null));  // expect 0, null = null
        actuals.add(nc.compareTo(f));  // expect -1, null < false
        actuals.add(nc.compareTo(t));  // expect 1-, null < true
        actuals.add(tc.compareTo(null));  // expect 1, true > null
        actuals.add(fc.compareTo(null));  // expect 1 false > null
        Test.stopTest();
        for (Integer i = 0; i < actuals.size(); i++) {
            System.assertEquals(expectations[i], actuals[i], 'Comparison #' + i);
        }
    }
    @isTest static void testDateimeComparable () {
        Datetime datetime0 = Datetime.newInstance(2020, 1, 1, 0, 0, 0); //year, month, day, hour, minute, second
        Datetime datetime1 = Datetime.newInstance(2020, 3, 14, 15, 9, 26); 
        Datetime datetime2 = Datetime.newInstance(2020, 6, 28, 30, 18,52);
        List<Integer> actuals = new List<Integer>();
        List<Integer> expectations = new List<Integer>{0,1,-1,0,1,-1};
        Test.startTest();
        Comparable dt1c = SortCollection.getComparable('DATETIME', (Object) datetime1);
        Comparable nc = SortCollection.getComparable('DATETIME', null);
        actuals.add(dt1c.compareTo(datetime1)); // expect 0, 
        actuals.add(dt1c.compareTo(datetime0)); // expect 1
        actuals.add(dt1c.compareTo(datetime2)); // expect -1
        actuals.add(nc.compareTo(null));   // expect 0, null = null
        actuals.add(dt1c.compareTo(null));  // expect 1, any datetime > null
        actuals.add(nc.compareTo(datetime1));  // expect -1 null < anydatetime
        Test.stopTest();
        for (Integer i = 0; i < actuals.size(); i++) {
            System.assertEquals(expectations[i], actuals[i], 'Comparison #' + i);
        }
    }
    @isTest static void testDecimalComparable () {
        Decimal value = 3.14159; // Apple
        List<Integer> actuals = new List<Integer>();
        List<Integer> expectations = new List<Integer>{0,1,-1,0,1,-1};
        Test.startTest();
        Comparable pi = SortCollection.getComparable('DECIMAL', (Object) value);
        Comparable n = SortCollection.getComparable('DECIMAL', null);
        actuals.add(pi.compareTo(value)); // expect 0, pi = pi
        actuals.add(pi.compareTo(2.71828));   // expect 1, pi > e
        actuals.add(pi.compareTo(22.4591));  // expect -1, pi < pi^e
        actuals.add(n.compareTo(null));   // expect 0, null = null
        actuals.add(pi.compareTo(null));  // expect 1, pi > null
        actuals.add(n.compareTo(value));  // expect -1 null < pi
        Test.stopTest();
        for (Integer i = 0; i < actuals.size(); i++) {
            System.assertEquals(expectations[i], actuals[i], 'Comparison #' + i);
        }
    }
    @isTest static void testDoubleComparableIntegerFieldType () {
        Integer value = 3;
        List<Integer> actuals = new List<Integer>();
        List<Integer> expectations = new List<Integer>{0,1,-1,0,1,-1};
        Test.startTest();
        Comparable pi = SortCollection.getComparable('INTEGER', (Object) value);
        Comparable n = SortCollection.getComparable('INTEGER', null);
        actuals.add(pi.compareTo(value)); // expect 0, pi = pi
        actuals.add(pi.compareTo(2));   // expect 1, pi > e
        actuals.add(pi.compareTo(22));  // expect -1, pi < pi^e
        actuals.add(n.compareTo(null));   // expect 0, null = null
        actuals.add(pi.compareTo(null));  // expect 1, pi > null
        actuals.add(n.compareTo(value));  // expect -1 null < pi
        Test.stopTest();
        for (Integer i = 0; i < actuals.size(); i++) {
            System.assertEquals(expectations[i], actuals[i], 'Comparison #' + i);
        }
    }
    @isTest static void testDoubleComparableLongFieldType () {
        Long value = 3141592653L;
        Long evalue  = 2718281828L;
                     
        List<Integer> actuals = new List<Integer>();
        List<Integer> expectations = new List<Integer>{0,1,-1,0,1,-1};
        Test.startTest();
        Comparable pi = SortCollection.getComparable('LONG', (Object) value);
        Comparable n = SortCollection.getComparable('LONG', null);
        actuals.add(pi.compareTo(value)); // expect 0, pi = pi
        actuals.add(pi.compareTo(2));   // expect 1, pi > e
        actuals.add(pi.compareTo(2*value));  // expect -1, pi < 2*pi
        actuals.add(n.compareTo(null));   // expect 0, null = null
        actuals.add(pi.compareTo(null));  // expect 1, pi > null
        actuals.add(n.compareTo(value));  // expect -1 null < pi
        Test.stopTest();
        for (Integer i = 0; i < actuals.size(); i++) {
            System.assertEquals(expectations[i], actuals[i], 'Comparison #' + i);
        }
    }
    @isTest static void testTimeComparable () {
        Time time0 = Time.newInstance(0, 0, 0, 0); //HH:mm:ss:S
        Time time1 = Time.newInstance(3, 14, 15, 926); //HH:mm:ss:S
        Time time2 = Time.newInstance(22, 45, 0, 0); //HH:mm:ss:S
        List<Integer> actuals = new List<Integer>();
        List<Integer> expectations = new List<Integer>{0,1,-1,0,1,-1};
        Test.startTest();
        Comparable t1 = SortCollection.getComparable('TIME', (Object) time1);
        Comparable n = SortCollection.getComparable('TIME', null);
        actuals.add(t1.compareTo(time1)); // expect 0, 3:14:15:926 = 3:14:15:000
        actuals.add(t1.compareTo(time0)); // expect 1, 3:14:15:926 > 00:00:00:000
        actuals.add(t1.compareTo(time2)); // expect -1, 3:14:15:926 < 22:45:00:000
        actuals.add(n.compareTo(null));   // expect 0, null = null
        actuals.add(t1.compareTo(null));  // expect 1, 3:14:15:926 > null
        actuals.add(n.compareTo(time1));  // expect -1 null < 3:14:15:926
        Test.stopTest();
        for (Integer i = 0; i < actuals.size(); i++) {
            System.assertEquals(expectations[i], actuals[i], 'Comparison #' + i);
        }
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

    static void testBulkSortStringField(List<SortCollection.Requests> requestsList) {
        //List<SObject> inputCollection, String sortKeys) {
        SortCollection.Requests requests = new SortCollection.Requests();
        List<SortCollection.Results> resultsList = new List<SortCollection.Results>();

        // Test
        Test.startTest();
        resultsList = SortCollection.sort(requestsList);
        Test.stopTest();
        
        // Validate
        System.assertNotEquals((List<SortCollection.Results>) null, resultsList, 'SortCollection.sort() returned null');
        System.assertEquals(requestsList.size(), resultsList.size(), 'resultList.size()');

        for (Integer i = 0; i < resultsList.size(); i++) {
            SortCollection.Results curResults = resultsList[i];
            SortCollection.Requests curRequests = requestsList[i];

            List<SObject> outputCollection = curResults.outputCollection;
            List<SObject> inputCollection = curRequests.inputCollection;
            System.assertEquals(outputCollection.size(), inputCollection.size(), 'Num sort results');

            String sortKeys = curRequests.sortKeys;
            List<String> tokens = sortKeys.split(':');
            String fieldName = tokens[0];
            Boolean isDescending = (tokens[1] == 'DESC');
            String msgTemplate = makeAssertMsgTemplate(fieldName, isDescending, sortKeys);
            SObject previous = null;
            for (Sobject current : outputCollection)  {
                //System.debug('testSortStringField() [' + i + '] current=' + JSON.serialize(current) + ', sortKeys=' + sortKeys);
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
            }
        }
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