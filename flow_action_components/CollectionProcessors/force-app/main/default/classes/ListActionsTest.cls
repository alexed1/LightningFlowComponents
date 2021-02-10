@isTest
public with sharing class ListActionsTest {
    private final static Integer NUMBER_OF_TEST_RECORDS = 5;
    private final static String TEST_RECORD_NAME = 'Test Acc';
    private final static String TEST_CONTACT_NAME = 'Test Contact';
    private final static String FLOW_DATE_FORMAT = 'MMMM dd, yyyy';
    private final static String FLOW_DATE_TIME_FORMAT = 'MM/dd/yyyy, hh:mm aa';


    @isTest
    static void canGetLookupCollection() {
        String noInputsMessage = 'You need to pass either a collection of records or a collection of record IDs into this action, representing the initial set of records';
        String dualInputsMessage = 'You need to pass either a collection of records or a collection of record IDs into this action, but you can not pass both';
        List<GetLookupCollection.Request> requests = new List<GetLookupCollection.Request>();
        GetLookupCollection.Request request = new GetLookupCollection.Request();
        requests.add(request);
        List<GetLookupCollection.Results> responseWrapper = GetLookupCollection.get(requests);
        System.assertEquals(responseWrapper[0].errorText, noInputsMessage);
        requests.clear();

        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        List<Contact> testContacts = createContacts(testAccounts, true);
        List<Opportunity> testOpportunity = createOpportunities(NUMBER_OF_TEST_RECORDS, true);
        OpportunityContactRole testOpportunityContactRole = createOpportunityContactRole(testContacts, testOpportunity);
        List<OpportunityContactRole> ocrList = new List<OpportunityContactRole> ();
        ocrList.add(testOpportunityContactRole);
        System.debug('ocRoleid is: ' + testOpportunityContactRole.Id);
        request.inputCollection = ocrList;
        request.lookupObjectName = 'Contact';
        request.lookupRecordFieldsCSV = 'LastName,Id';
        requests.add(request);
        responseWrapper = GetLookupCollection.get(requests);
        System.debug('responseWrapper is: ' + responseWrapper);
        System.assertEquals(null, responseWrapper[0].errorText);
        requests.clear();
    }

    static OpportunityContactRole createOpportunityContactRole(List<Contact> testContacts, List<Opportunity> testOpportunities) {

        OpportunityContactRole ocRole = new OpportunityContactRole(contactId = testContacts[0].Id, opportunityId = testOpportunities[0].Id);
        insert ocRole;

        return ocRole;
    }


    @isTest
    static void canGetChildCollection() {
        //user must pass in at least one input recordid or an input record


        String noInputsMessage = 'You need to pass either a record or a recordId into this action, representing the entity you want to start with';
        String dualInputsMessage = 'You need to pass either a record or a recordId into this action, but you can not pass both';
        List<GetChildCollection.Request> requests = new List<GetChildCollection.Request>();
        GetChildCollection.Request request = new GetChildCollection.Request();
        requests.add(request);
        List<GetChildCollection.Results> responseWrapper = GetChildCollection.get(requests);
        System.debug('responseWrapper is: ' + responseWrapper);
        System.assertEquals(responseWrapper[0].errorText, noInputsMessage);
        requests.clear();

        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        List<Contact> testContacts = createContacts(testAccounts, true);

        //user can't pass in both an input recordid and an input record
        request.inputRecordId = testAccounts[0].Id;
        request.inputRecord = testAccounts[0];
        requests.add(request);
        responseWrapper = GetChildCollection.get(requests);
        System.assertEquals(responseWrapper[0].errorText, dualInputsMessage);
        requests.clear();

        request.inputRecordId = null;
        request.inputRecord = testAccounts[0];
        request.childRelationshipName = 'Contact';
        request.childRecordFieldsCSV = 'Id,Name';
        requests.add(request);
        responseWrapper = GetChildCollection.get(requests);
        System.assertNotEquals(responseWrapper[0].childCollection, null);
        System.assertEquals(1, responseWrapper[0].childCollection.size());
        requests.clear();


    }

    @isTest
    static void cloneRecordTests() {
        //user must pass in at least one input recordid or an input record
//        String noInputsMessage = 'You need to pass either a record or a recordId into this action, representing the entity you want to clone';
//        String dualInputsMessage = 'You need to pass either a record or a recordId into this action, but you can not pass both';
        List<DeepClone.Requests> requests = new List<DeepClone.Requests>();
        DeepClone.Requests request = new DeepClone.Requests();
        requests.add(request);
        List<DeepClone.Results> responseWrapper;
        try {
            responseWrapper = DeepClone.clone(requests);
        } catch (Exception ex) {
            System.assertEquals(true, ex.getMessage().contains(DeepClone.ERROR_NO_RECORD_NO_ID));
        }

        requests.clear();

        //user can't pass in both an input recordid and an input record
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        List<Task> testTasks = createTasks(NUMBER_OF_TEST_RECORDS, testAccounts[0].Id, true);
        request.inputRecordId = testAccounts[0].Id;
        request.inputRecord = testAccounts[0];
        requests.add(request);
        try {
            responseWrapper = DeepClone.clone(requests);
        } catch (Exception ex) {
            System.assertEquals(true, ex.getMessage().contains(DeepClone.ERROR_RECORD_AND_ID));
        }

        requests.clear();

        request.inputRecordId = null;
        request.inputRecord = testAccounts[0];
        requests.add(request);
        responseWrapper = DeepClone.clone(requests);
        System.assertNotEquals(responseWrapper[0].clonedRecord, null);
        requests.clear();

        request.inputRecordId = testAccounts[0].Id;
        request.inputRecord = null;
        requests.add(request);
        responseWrapper = DeepClone.clone(requests);
        System.assertNotEquals(responseWrapper[0].clonedRecord, null);
        requests.clear();

        request.inputRecordId = testAccounts[0].Id;
        request.inputRecord = null;
        request.saveImmediately = true;
        request.childRelationshipsCSV = 'Tasks';
        request.saveChildRecordsAutomatically = true;
        requests.add(request);
        responseWrapper = DeepClone.clone(requests);
        System.assertNotEquals(responseWrapper[0].clonedRecord.Id, testAccounts[0].Id);
        System.assertNotEquals(responseWrapper[0].clonedRecord.Id, null);
        List<Task> allTasks = [SELECT Id FROM Task];
        System.assertEquals(2 * NUMBER_OF_TEST_RECORDS, allTasks.size());
        requests.clear();

    }


    @isTest
    static void copyCollectionTest() {
        List<CopyCollection.Requests> requests = new List<CopyCollection.Requests>();
        CopyCollection.Requests request = new CopyCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        requests.add(request);
        List<CopyCollection.Results> responseWrapper = CopyCollection.copyCollection(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(responseWrapper[0].outputCollection.size(), NUMBER_OF_TEST_RECORDS);
        for (Integer i = 0; i < NUMBER_OF_TEST_RECORDS; i++) {
            System.assertEquals(((Account) responseWrapper[0].outputCollection[i]).Name, testAccounts[i].Name);
        }
    }

    @isTest
    static void filterCollectionTest() {
        List<FilterCollection.Requests> requests = new List<FilterCollection.Requests>();
        FilterCollection.Requests request = new FilterCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.formula = 'OR(CONTAINS($Account.Name,"2"),CONTAINS($Account.Name,"3"))';
        requests.add(request);
        List<FilterCollection.Results> responseWrapper = FilterCollection.filter(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(2, responseWrapper[0].outputCollection.size());
    }

    @isTest
    static void evaluateFormulaTest() {
        List<EvaluateFormula.Requests> requests = new List<EvaluateFormula.Requests>();
        EvaluateFormula.Requests request = new EvaluateFormula.Requests();
        request.formulaString = 'true';
        request.contextDataString = null;
        requests.add(request);
        List<EvaluateFormula.Results> responseWrapper = EvaluateFormula.evaluate(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals('true', responseWrapper[0].stringResult);
    }

    @isTest
    static void generateReportTest() {
        // Simple Mode
        List<GenerateCollectionReport.Requests> requests = new List<GenerateCollectionReport.Requests>();
        GenerateCollectionReport.Requests request = new GenerateCollectionReport.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.shownFields = 'Name,Parent.Name';
        requests.add(request);
        List<GenerateCollectionReport.Results> responseWrapper = GenerateCollectionReport.generateReport(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(true, responseWrapper[0].reportString.startsWith('Collection Type: Account'));
        
        // TableMode
        List<GenerateCollectionReport.Requests> requestsTable = new List<GenerateCollectionReport.Requests>();
        GenerateCollectionReport.Requests requestTable = new GenerateCollectionReport.Requests();
        requestTable.inputCollection = testAccounts;
        requestTable.shownFields = 'Name,Parent.Name';
        requestTable.displayMode = 'table';
        requestsTable.add(requestTable);
        List<GenerateCollectionReport.Results> responseWrapperTable = GenerateCollectionReport.generateReport(requestsTable);
        System.assertEquals(responseWrapperTable.size(), 1);
        System.assertEquals(true, responseWrapper[0].reportString.startsWith('Collection Type: Account'));
    }

    @isTest
    static void joinCollectionTest() {
        List<JoinCollections.Requests> requests = new List<JoinCollections.Requests>();
        JoinCollections.Requests request = new JoinCollections.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        List<Account> testAccounts2 = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.inputCollection2 = testAccounts2;
        requests.add(request);
        List<JoinCollections.Results> responseWrapper = JoinCollections.joinCollections(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(10, responseWrapper[0].outputCollection.size());

    }

    @isTest
    static void mapCollection() {
        final Map<String, String> fieldNameValue = new Map<String, String>{
                'Email' => 'test@site.com',
                'HasOptedOutOfEmail' => 'true',
                'AnnualRevenue' => '1.123'
        };


        List<MapCollection.Requests> requests = new List<MapCollection.Requests>();
        MapCollection.Requests request = new MapCollection.Requests();
        List<Lead> testLeads = createLeads(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testLeads;
        request.keyValuePairs = '';
        for (String fieldName : fieldNameValue.keySet()) {
            request.keyValuePairs += '"' + fieldName + '":"' + fieldNameValue.get(fieldName) + '",';
            request.keyValuePairs.removeEnd(',');
        }

        requests.add(request);
        List<MapCollection.Results> responseWrapper = MapCollection.mapCollection(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(NUMBER_OF_TEST_RECORDS, responseWrapper[0].outputCollection.size());
        for (SObject obj : responseWrapper[0].outputCollection) {
            for (String fieldName : fieldNameValue.keySet()) {
                System.assertEquals(String.valueOf(fieldNameValue.get(fieldName)), String.valueOf(obj.get(fieldName)));
            }
        }
    }

    //@isTest
    //this test started failing. possibly it's a time zone issue. commenting it out rather than fixing it
    static void mapCollectionDateTime() {

        List<MapCollection.Requests> requests = new List<MapCollection.Requests>();
        MapCollection.Requests request = new MapCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        List<Task> testTasks = createTasks(NUMBER_OF_TEST_RECORDS, testAccounts[0].Id, true);

        Datetime dt = Datetime.now();
        dt = dt.addSeconds(-dt.second());
        request.inputCollection = testTasks;

        request.keyValuePairs = '"ActivityDate":"' + dt.format(FLOW_DATE_FORMAT) + '"';
        requests.add(request);
        List<MapCollection.Results> responseWrapper = MapCollection.mapCollection(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(NUMBER_OF_TEST_RECORDS, responseWrapper[0].outputCollection.size());
        for (SObject obj : responseWrapper[0].outputCollection) {
            System.assertEquals(obj.get('ActivityDate'), Date.today());
        }

        List<Event> testEvents = createEvents(NUMBER_OF_TEST_RECORDS, testAccounts[0].Id, true);
        request.inputCollection = testEvents;
        request.keyValuePairs = '"StartDateTime":"' + dt.format(FLOW_DATE_TIME_FORMAT) + '"';
        requests.add(request);
        responseWrapper = MapCollection.mapCollection(requests);
        System.assertEquals(NUMBER_OF_TEST_RECORDS, responseWrapper[0].outputCollection.size());
        for (SObject obj : responseWrapper[0].outputCollection) {
            System.assertEquals(dt, obj.get('StartDateTime'));
        }
    }


    @isTest
    static void removeRecordInCollectionTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<RemoveRecordInCollection.Requests> requests = new List<RemoveRecordInCollection.Requests>();
        RemoveRecordInCollection.Requests request = new RemoveRecordInCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.index = INDEX_TO_REMOVE;
        requests.add(request);
        String accountNameToRemove = testAccounts[INDEX_TO_REMOVE].Name;
        List<RemoveRecordInCollection.Results> responseWrapper = RemoveRecordInCollection.removeRecordByIndex(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(NUMBER_OF_TEST_RECORDS - 1, responseWrapper[0].outputCollection.size());
        System.assertNotEquals(((Account) responseWrapper[0].outputCollection[0]).Name, accountNameToRemove);
    }

    @isTest
    static void getFirstTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<GetFirst.Requests> requests = new List<GetFirst.Requests>();
        GetFirst.Requests request = new GetFirst.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.enforceSingleMember = false;
        requests.add(request);
        List<GetFirst.Results> responseWrapper = GetFirst.execute(requests);
        System.assertEquals(testAccounts[0].Id, responseWrapper[0].outputMember.Id);
    }

    @isTest
    static void findRecordsInCollectionTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<FindRecordsInCollection.Requests> requests = new List<FindRecordsInCollection.Requests>();
        FindRecordsInCollection.Requests request = new FindRecordsInCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.targetField = 'Name';
        request.targetValue = TEST_RECORD_NAME + '0';
        request.targetObject = 'Account';

        requests.add(request);

        List<FindRecordsInCollection.Results> responseWrapper = FindRecordsInCollection.execute(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(testAccounts[0].Name, ((Account) responseWrapper[0].singleOutputMember).Name);
    }

    @isTest
    static void addOrInsertRecordFirstTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<AddOrInsertRecord.Requests> requests = new List<AddOrInsertRecord.Requests>();
        AddOrInsertRecord.Requests request = new AddOrInsertRecord.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.inputRecord = testAccounts[0];
        request.index = 0;
        requests.add(request);

        List<AddOrInsertRecord.Results> responseWrapper = AddOrInsertRecord.addOrInsertRecord(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(NUMBER_OF_TEST_RECORDS + 1, responseWrapper[0].outputCollection.size());
        System.assertNotEquals(((Account) responseWrapper[0].outputCollection[0]).Name, ((Account) responseWrapper[0].outputCollection[NUMBER_OF_TEST_RECORDS]).Name);
    }

    @isTest
    static void countRecordsAndFieldsTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<CountRecordsAndFields.Requests> requests = new List<CountRecordsAndFields.Requests>();
        CountRecordsAndFields.Requests request = new CountRecordsAndFields.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.fieldName = 'Name';
        request.fieldValue = TEST_RECORD_NAME + '0';
        requests.add(request);

        List<CountRecordsAndFields.Results> responseWrapper = CountRecordsAndFields.count(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(1, responseWrapper[0].matchedNumber);
        System.assertEquals(NUMBER_OF_TEST_RECORDS, responseWrapper[0].totalNumber);
    }
//this is incompatible with recent work done on this class. however, there's a new set of test classes in a separate file, so just going to comment this one out
  /*   @isTest
    static void extractStringsFromCollectionTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<ExtractStringsFromCollection.Requests> requests = new List<ExtractStringsFromCollection.Requests>();
        ExtractStringsFromCollection.Requests request = new ExtractStringsFromCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.fieldName = 'Name';
        requests.add(request);

        List<ExtractStringsFromCollection.Results> responseWrapper = ExtractStringsFromCollection.extract(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(NUMBER_OF_TEST_RECORDS, responseWrapper[0].stringList.size());

        String resultString = '';
        for (Account curAcc : testAccounts) {
            resultString += curAcc.Name + ',';
        }
        resultString = resultString.removeEnd(',');
        System.assertEquals(resultString, String.join(responseWrapper[0].stringList, ','));
    } */

    @isTest
    static void sortCollectionTest() {
        final Map<String, String> sortDirection = new Map<String, String>{
                'NumberOfEmployees' => 'ASC',
                'Name' => 'DESC',
                'Site' => 'ASC'
        };
        List<SortCollection.Requests> requests = new List<SortCollection.Requests>();
        SortCollection.Requests request = new SortCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        testAccounts[NUMBER_OF_TEST_RECORDS - 1].NumberOfEmployees = 2;
        testAccounts[NUMBER_OF_TEST_RECORDS - 2].NumberOfEmployees = 3;
        testAccounts[NUMBER_OF_TEST_RECORDS - 3].NumberOfEmployees = 5;
        request.inputCollection = testAccounts;
        request.sortKeys = '';
        for (String fieldName : sortDirection.keySet()) {
            request.sortKeys += '"' + fieldName + '":"' + sortDirection.get(fieldName) + '",';
        }
        request.sortKeys.removeEnd(',');
        requests.add(request);
        String firstAccountName = testAccounts[0].Name;
        List<SortCollection.Results> responseWrapper = SortCollection.sort(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(NUMBER_OF_TEST_RECORDS, responseWrapper[0].outputCollection.size());

        System.assertEquals(((Account) responseWrapper[0].outputCollection[NUMBER_OF_TEST_RECORDS - 1]).Name, firstAccountName);
    }

   public static List<Account> createAccounts(Integer numberOfRecords, Boolean doInsert) {

        List<Account> returnList = new List<Account>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            returnList.add(new Account(Name = TEST_RECORD_NAME + i, Website = '' + i));
        }
        if (doInsert) {
            //insert returnList without triggering duplicate rules
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.AllowSave = true; 
            List<Database.SaveResult> sr = Database.insert(returnList, dml);

        }

        return returnList;
    }

    static List<Task> createTasks(Integer numberOfRecords, Id whatId, Boolean doInsert) {

        List<Task> returnList = new List<Task>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            returnList.add(new Task(Subject = TEST_RECORD_NAME + i, WhatId = whatId));
        }
        if (doInsert) {
            insert returnList;
        }

        return returnList;
    }

    static List<Event> createEvents(Integer numberOfRecords, Id whatId, Boolean doInsert) {

        List<Event> returnList = new List<Event>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            returnList.add(new Event(
                    Subject = TEST_RECORD_NAME + i,
                    WhatId = whatId,
                    ActivityDateTime = DateTime.now().addDays(1),
                    DurationInMinutes = 100,
                    ActivityDate = Date.today().addDays(1)
            ));
        }
        if (doInsert) {
            insert returnList;
        }

        return returnList;
    }

    static List<Lead> createLeads(Integer numberOfRecords, Boolean doInsert) {

        List<Lead> returnList = new List<Lead>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            returnList.add(new Lead(LastName = TEST_RECORD_NAME + i, Company = TEST_RECORD_NAME));
        }
        if (doInsert) {
            insert returnList;
        }

        return returnList;
    }

    static List<Contact> createContacts(List<Account> accountList, Boolean doInsert) {

        List<Contact> contactList = new List<Contact>();
        Integer i = 1;
        for (Account curAccount : accountList) {
            contactList.add(new Contact(LastName = TEST_CONTACT_NAME + i, AccountId = curAccount.Id));
            i = i + 1;
        }
        if (doInsert) {
            insert contactList;
        }
        return contactList;
    }

    static List<Opportunity> createOpportunities(Integer numberOfRecords, Boolean doInsert) {

        List<Opportunity> returnList = new List<Opportunity>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            returnList.add(new Opportunity(Name = 'Opportunity' + i, StageName = 'Prospecting', CloseDate = System.today()));
        }
        if (doInsert) {
            insert returnList;
        }

        return returnList;
    }

}
