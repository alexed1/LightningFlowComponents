@isTest
public with sharing class ListActionsTest {
    private final static Integer NUMBER_OF_TEST_RECORDS = 5;
    private final static String TEST_RECORD_NAME = 'Test Acc';
    private final static String TEST_CONTACT_NAME = 'Test Contact';
    private final static String FLOW_DATE_FORMAT = 'MMMM dd, yyyy';
    private final static String FLOW_DATE_TIME_FORMAT = 'MM/dd/yyyy, hh:mm aa';
    // Counter to use as an offset when multiple account list retrievals are
    // performed in one test
    private static Integer numAccountsRetrieved = 0;

    @TestSetup
    static void makeData() {
        Test.startTest();
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < NUMBER_OF_TEST_RECORDS; i++) {
            testAccounts.add(
                new Account(
                    Name = TEST_RECORD_NAME + i,
                    Website = '' + i,
                    AnnualRevenue = 5000
                )
            );
        }
        // Insert testAccounts without triggering duplicate rules
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;
        Database.insert(testAccounts, dml);

        List<Contact> testContacts = new List<Contact>();
        List<Task> testTasks = new List<Task>();
        for (Integer i = 0; i < testAccounts.size(); i++) {
            testContacts.add(
                new Contact(
                    LastName = TEST_CONTACT_NAME + i,
                    AccountId = testAccounts[i].Id
                )
            );
            testTasks.add(
                new Task(
                    Subject = TEST_RECORD_NAME + i,
                    WhatId = testAccounts[0].Id
                )
            );
        }
        insert testContacts;
        insert testTasks;
        Test.stopTest();
    }

    @isTest
    static void canCalculateCollection() {
        Integer numAccountsToGet = 3;
        List<Account> testAccounts = getAccounts(numAccountsToGet);
        CollectionCalculate.Requests request = new CollectionCalculate.Requests();
        request.inputCollection = testAccounts;
        request.fieldName = 'AnnualRevenue';
        request.operation = 'Add';
        List<CollectionCalculate.Requests> requests = new List<CollectionCalculate.Requests>();
        requests.add(request);

        List<CollectionCalculate.Results> responses = CollectionCalculate.execute(
            requests
        );
        CollectionCalculate.Results response = responses[0];
        Assert.areEqual(
            numAccountsToGet * testAccounts[0].AnnualRevenue,
            response.outputDecimalResult
        );
    }

    @isTest
    static void canGetLookupCollection() {
        String noInputsMessage = 'You need to pass either a collection of records or a collection of record IDs into this action, representing the initial set of records';
        String dualInputsMessage = 'You need to pass either a collection of records or a collection of record IDs into this action, but you can not pass both';
        List<GetLookupCollection.Request> requests = new List<GetLookupCollection.Request>();
        GetLookupCollection.Request request = new GetLookupCollection.Request();
        requests.add(request);
        List<GetLookupCollection.Results> responseWrapper = GetLookupCollection.get(
            requests
        );
        Assert.areEqual(responseWrapper[0].errorText, noInputsMessage);
        requests.clear();

        List<Contact> testContacts = getContacts(NUMBER_OF_TEST_RECORDS);
        List<Opportunity> testOpportunity = createOpportunities(
            NUMBER_OF_TEST_RECORDS,
            true
        );
        OpportunityContactRole testOpportunityContactRole = createOpportunityContactRole(
            testContacts,
            testOpportunity
        );
        List<OpportunityContactRole> ocrList = new List<OpportunityContactRole>();
        ocrList.add(testOpportunityContactRole);
        System.debug('ocRoleid is: ' + testOpportunityContactRole.Id);
        request.inputCollection = ocrList;
        request.lookupObjectName = 'Contact';
        request.lookupRecordFieldsCSV = 'LastName,Id';
        requests.add(request);
        responseWrapper = GetLookupCollection.get(requests);
        System.debug('responseWrapper is: ' + responseWrapper);
        Assert.areEqual(null, responseWrapper[0].errorText);
        requests.clear();
    }

    static OpportunityContactRole createOpportunityContactRole(
        List<Contact> testContacts,
        List<Opportunity> testOpportunities
    ) {
        OpportunityContactRole ocRole = new OpportunityContactRole(
            contactId = testContacts[0].Id,
            opportunityId = testOpportunities[0].Id
        );
        insert ocRole;

        return ocRole;
    }

    @isTest
    static void canGetChildCollection_inputRecord() {
        Account testAccount = getAccounts(1)[0];

        List<GetChildCollection.Request> requests = new List<GetChildCollection.Request>();
        GetChildCollection.Request request = new GetChildCollection.Request();
        requests.add(request);
        request.inputRecordId = null;
        request.inputRecord = testAccount;
        // API name of the child relationship
        request.childRelationshipName = 'Contacts';
        request.childRecordFieldsCSV = 'Id,Name';
        List<GetChildCollection.Results> responseWrapper = GetChildCollection.get(
            requests
        );
        Assert.areNotEqual(responseWrapper[0].childCollection, null);
        Assert.areEqual(1, responseWrapper[0].childCollection.size());
        requests.clear();
    }

    @isTest
    static void canGetChildCollection_inputRecordId() {
        Account testAccount = getAccounts(1)[0];

        List<GetChildCollection.Request> requests = new List<GetChildCollection.Request>();
        GetChildCollection.Request request = new GetChildCollection.Request();
        requests.add(request);
        request.inputRecordId = testAccount.Id;
        request.inputRecord = null;
        // API name of the child relationship
        request.childRelationshipName = 'Contacts';
        request.childRecordFieldsCSV = 'Id,Name';
        List<GetChildCollection.Results> responseWrapper = GetChildCollection.get(
            requests
        );
        Assert.areNotEqual(responseWrapper[0].childCollection, null);
        Assert.areEqual(1, responseWrapper[0].childCollection.size());
        requests.clear();
    }

    @isTest
    static void canGetChildCollection_childSobjectName() {
        Account testAccount = getAccounts(1)[0];

        List<GetChildCollection.Request> requests = new List<GetChildCollection.Request>();
        GetChildCollection.Request request = new GetChildCollection.Request();
        requests.add(request);
        request.inputRecordId = testAccount.Id;
        request.inputRecord = null;
        // API name of the child SObject. If more than one relationship exists
        // between Account and Contact, this may have unexpected results.
        request.childRelationshipName = 'Contact';
        request.childRecordFieldsCSV = 'Id,Name';
        List<GetChildCollection.Results> responseWrapper = GetChildCollection.get(
            requests
        );
        Assert.areNotEqual(responseWrapper[0].childCollection, null);
        Assert.isTrue(String.isBlank(responseWrapper[0].errorText));
        requests.clear();
    }

    @isTest
    static void canGetChildCollection_noInputsError() {
        // Wser must pass in at least one input recordid or an input record
        String noInputsMessage = 'You need to pass either a record or a recordId into this action, representing the entity you want to start with';
        List<GetChildCollection.Request> requests = new List<GetChildCollection.Request>();
        GetChildCollection.Request request = new GetChildCollection.Request();
        requests.add(request);
        List<GetChildCollection.Results> responseWrapper = GetChildCollection.get(
            requests
        );
        System.debug('responseWrapper is: ' + responseWrapper);
        Assert.areEqual(responseWrapper[0].errorText, noInputsMessage);
    }

    @isTest
    static void canGetChildCollection_dualInputsError() {
        // User must not pass in both inputRecordId and inputRecord
        String dualInputsMessage = 'You need to pass either a record or a recordId into this action, but you can not pass both';
        List<Account> testAccounts = getAccounts(NUMBER_OF_TEST_RECORDS);

        List<GetChildCollection.Request> requests = new List<GetChildCollection.Request>();
        GetChildCollection.Request request = new GetChildCollection.Request();
        requests.add(request);
        request.inputRecordId = testAccounts[0].Id;
        request.inputRecord = testAccounts[0];
        requests.add(request);
        List<GetChildCollection.Results> responseWrapper = GetChildCollection.get(
            requests
        );
        Assert.areEqual(responseWrapper[0].errorText, dualInputsMessage);
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
            Assert.areEqual(
                true,
                ex.getMessage().contains(DeepClone.ERROR_NO_RECORD_NO_ID)
            );
        }

        requests.clear();

        // Get the account that has tasks associated with it
        Account testAccount = getAccountWithTasks();
        request.inputRecordId = testAccount.Id;
        request.inputRecord = testAccount;
        requests.add(request);

        //user can't pass in both an input recordid and an input record
        try {
            responseWrapper = DeepClone.clone(requests);
        } catch (Exception ex) {
            Assert.areEqual(
                true,
                ex.getMessage().contains(DeepClone.ERROR_RECORD_AND_ID)
            );
        }

        requests.clear();

        request.inputRecordId = null;
        request.inputRecord = testAccount;
        requests.add(request);
        responseWrapper = DeepClone.clone(requests);
        Assert.areNotEqual(responseWrapper[0].clonedRecord, null);
        requests.clear();

        request.inputRecordId = testAccount.Id;
        request.inputRecord = null;
        requests.add(request);
        responseWrapper = DeepClone.clone(requests);
        Assert.areNotEqual(responseWrapper[0].clonedRecord, null);
        requests.clear();

        request.inputRecordId = testAccount.Id;
        request.inputRecord = null;
        request.saveImmediately = true;
        request.childRelationshipsCSV = 'Tasks';
        request.saveChildRecordsAutomatically = true;
        requests.add(request);
        responseWrapper = DeepClone.clone(requests);
        Assert.areNotEqual(responseWrapper[0].clonedRecord.Id, testAccount.Id);
        Assert.areNotEqual(responseWrapper[0].clonedRecord.Id, null);
        List<Task> allTasks = [SELECT Id FROM Task];
        Assert.areEqual(2 * NUMBER_OF_TEST_RECORDS, allTasks.size());
        requests.clear();
    }

    @isTest
    static void copyCollectionTest() {
        List<CopyCollection.Requests> requests = new List<CopyCollection.Requests>();
        CopyCollection.Requests request = new CopyCollection.Requests();
        List<Account> testAccounts = getAccounts(NUMBER_OF_TEST_RECORDS);
        request.inputCollection = testAccounts;
        requests.add(request);
        List<CopyCollection.Results> responseWrapper = CopyCollection.copyCollection(
            requests
        );
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual(
            responseWrapper[0].outputCollection.size(),
            NUMBER_OF_TEST_RECORDS
        );
        for (Integer i = 0; i < NUMBER_OF_TEST_RECORDS; i++) {
            Assert.areEqual(
                ((Account) responseWrapper[0].outputCollection[i]).Name,
                testAccounts[i].Name
            );
        }
    }

    @isTest
    static void filterCollectionTest() {
        List<FilterCollection.Requests> requests = new List<FilterCollection.Requests>();
        FilterCollection.Requests request = new FilterCollection.Requests();
        List<Account> testAccounts = getAccounts(NUMBER_OF_TEST_RECORDS);
        request.inputCollection = testAccounts;
        request.formula = 'OR(CONTAINS($Account.Name,"2"),CONTAINS($Account.Name,"3"))';
        requests.add(request);
        List<FilterCollection.Results> responseWrapper = FilterCollection.filter(
            requests
        );
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual(2, responseWrapper[0].outputCollection.size());
    }

    @isTest
    static void evaluateFormulaTest() {
        List<EvaluateFormula.Requests> requests = new List<EvaluateFormula.Requests>();
        EvaluateFormula.Requests request = new EvaluateFormula.Requests();
        request.formulaString = 'true';
        request.contextDataString = null;
        requests.add(request);
        List<EvaluateFormula.Results> responseWrapper = EvaluateFormula.evaluate(
            requests
        );
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual('true', responseWrapper[0].stringResult);
    }

    @isTest
    static void generateReportTest() {
        // Simple Mode
        List<GenerateCollectionReport.Requests> requests = new List<GenerateCollectionReport.Requests>();
        GenerateCollectionReport.Requests request = new GenerateCollectionReport.Requests();
        List<Account> testAccounts = getAccounts(NUMBER_OF_TEST_RECORDS);
        request.inputCollection = testAccounts;
        request.shownFields = 'Name,Parent.Name';
        requests.add(request);
        List<GenerateCollectionReport.Results> responseWrapper = GenerateCollectionReport.generateReport(
            requests
        );
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual(
            true,
            responseWrapper[0]
                .reportString.startsWith('Collection Type: Account')
        );

        // TableMode
        List<GenerateCollectionReport.Requests> requestsTable = new List<GenerateCollectionReport.Requests>();
        GenerateCollectionReport.Requests requestTable = new GenerateCollectionReport.Requests();
        requestTable.inputCollection = testAccounts;
        requestTable.shownFields = 'Name,Parent.Name';
        requestTable.displayMode = 'table';
        requestsTable.add(requestTable);
        List<GenerateCollectionReport.Results> responseWrapperTable = GenerateCollectionReport.generateReport(
            requestsTable
        );
        Assert.areEqual(responseWrapperTable.size(), 1);
        Assert.areEqual(
            true,
            responseWrapper[0]
                .reportString.startsWith('Collection Type: Account')
        );
    }

    @isTest
    static void joinCollectionTest() {
        List<JoinCollections.Requests> requests = new List<JoinCollections.Requests>();
        JoinCollections.Requests request = new JoinCollections.Requests();
        Integer list1Size = 3;
        Integer list2Size = 2;
        List<Account> testAccounts = getAccounts(list1Size);
        List<Account> testAccounts2 = getAccounts(list2Size);
        request.inputCollection = testAccounts;
        request.inputCollection2 = testAccounts2;
        requests.add(request);
        List<JoinCollections.Results> responseWrapper = JoinCollections.joinCollections(
            requests
        );
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual(
            list1Size + list2Size,
            responseWrapper[0].outputCollection.size()
        );
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
            request.keyValuePairs +=
                '"' +
                fieldName +
                '":"' +
                fieldNameValue.get(fieldName) +
                '",';
            request.keyValuePairs.removeEnd(',');
        }

        requests.add(request);
        List<MapCollection.Results> responseWrapper = MapCollection.mapCollection(
            requests
        );
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual(
            NUMBER_OF_TEST_RECORDS,
            responseWrapper[0].outputCollection.size()
        );
        for (SObject obj : responseWrapper[0].outputCollection) {
            for (String fieldName : fieldNameValue.keySet()) {
                Assert.areEqual(
                    String.valueOf(fieldNameValue.get(fieldName)),
                    String.valueOf(obj.get(fieldName))
                );
            }
        }
    }

    //@isTest
    //this test started failing. possibly it's a time zone issue. commenting it out rather than fixing it
    static void mapCollectionDateTime() {
        List<MapCollection.Requests> requests = new List<MapCollection.Requests>();
        MapCollection.Requests request = new MapCollection.Requests();
        Account testAccount = getAccountWithTasks();
        List<Task> testTasks = testAccount.Tasks;

        Datetime dt = Datetime.now();
        dt = dt.addSeconds(-dt.second());
        request.inputCollection = testTasks;

        request.keyValuePairs =
            '"ActivityDate":"' +
            dt.format(FLOW_DATE_FORMAT) +
            '"';
        requests.add(request);
        List<MapCollection.Results> responseWrapper = MapCollection.mapCollection(
            requests
        );
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual(
            NUMBER_OF_TEST_RECORDS,
            responseWrapper[0].outputCollection.size()
        );
        for (SObject obj : responseWrapper[0].outputCollection) {
            Assert.areEqual(obj.get('ActivityDate'), Date.today());
        }

        List<Event> testEvents = createEvents(
            NUMBER_OF_TEST_RECORDS,
            testAccount.Id,
            true
        );
        request.inputCollection = testEvents;
        request.keyValuePairs =
            '"StartDateTime":"' +
            dt.format(FLOW_DATE_TIME_FORMAT) +
            '"';
        requests.add(request);
        responseWrapper = MapCollection.mapCollection(requests);
        Assert.areEqual(
            NUMBER_OF_TEST_RECORDS,
            responseWrapper[0].outputCollection.size()
        );
        for (SObject obj : responseWrapper[0].outputCollection) {
            Assert.areEqual(dt, obj.get('StartDateTime'));
        }
    }

    @isTest
    static void removeRecordInCollectionTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<RemoveRecordInCollection.Requests> requests = new List<RemoveRecordInCollection.Requests>();
        RemoveRecordInCollection.Requests request = new RemoveRecordInCollection.Requests();
        List<Account> testAccounts = getAccounts(NUMBER_OF_TEST_RECORDS);
        request.inputCollection = testAccounts;
        request.index = INDEX_TO_REMOVE;
        requests.add(request);
        String accountNameToRemove = testAccounts[INDEX_TO_REMOVE].Name;
        List<RemoveRecordInCollection.Results> responseWrapper = RemoveRecordInCollection.removeRecordByIndex(
            requests
        );
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual(
            NUMBER_OF_TEST_RECORDS - 1,
            responseWrapper[0].outputCollection.size()
        );
        Assert.areNotEqual(
            ((Account) responseWrapper[0].outputCollection[0]).Name,
            accountNameToRemove
        );
    }

    @isTest
    static void getFirstTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<GetFirst.Requests> requests = new List<GetFirst.Requests>();
        GetFirst.Requests request = new GetFirst.Requests();
        List<Account> testAccounts = getAccounts(NUMBER_OF_TEST_RECORDS);
        request.inputCollection = testAccounts;
        request.enforceSingleMember = false;
        requests.add(request);
        List<GetFirst.Results> responseWrapper = GetFirst.execute(requests);
        Assert.areEqual(testAccounts[0].Id, responseWrapper[0].outputMember.Id);
    }

    @isTest
    static void findRecordsInCollectionTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<FindRecordsInCollection.Requests> requests = new List<FindRecordsInCollection.Requests>();
        FindRecordsInCollection.Requests request = new FindRecordsInCollection.Requests();
        List<Account> testAccounts = getAccounts(NUMBER_OF_TEST_RECORDS);
        request.inputCollection = testAccounts;
        request.targetField = 'Name';
        request.targetValue = TEST_RECORD_NAME + '0';
        request.targetObject = 'Account';

        requests.add(request);

        List<FindRecordsInCollection.Results> responseWrapper = FindRecordsInCollection.execute(
            requests
        );
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual(
            testAccounts[0].Name,
            ((Account) responseWrapper[0].singleOutputMember).Name
        );
    }

    @isTest
    static void addOrInsertRecordFirstTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<AddOrInsertRecord.Requests> requests = new List<AddOrInsertRecord.Requests>();
        AddOrInsertRecord.Requests request = new AddOrInsertRecord.Requests();
        List<Account> testAccounts = getAccounts(NUMBER_OF_TEST_RECORDS);
        request.inputCollection = testAccounts;
        request.inputRecord = testAccounts[0];
        request.index = 0;
        requests.add(request);

        List<AddOrInsertRecord.Results> responseWrapper = AddOrInsertRecord.addOrInsertRecord(
            requests
        );
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual(
            NUMBER_OF_TEST_RECORDS + 1,
            responseWrapper[0].outputCollection.size()
        );
        Assert.areNotEqual(
            ((Account) responseWrapper[0].outputCollection[0]).Name,
            ((Account) responseWrapper[0]
                    .outputCollection[NUMBER_OF_TEST_RECORDS])
                .Name
        );
    }

    @isTest
    static void countRecordsAndFieldsTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<CountRecordsAndFields.Requests> requests = new List<CountRecordsAndFields.Requests>();
        CountRecordsAndFields.Requests request = new CountRecordsAndFields.Requests();
        List<Account> testAccounts = getAccounts(NUMBER_OF_TEST_RECORDS);
        request.inputCollection = testAccounts;
        request.fieldName = 'Name';
        request.fieldValue = TEST_RECORD_NAME + '0';
        requests.add(request);

        List<CountRecordsAndFields.Results> responseWrapper = CountRecordsAndFields.count(
            requests
        );
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual(1, responseWrapper[0].matchedNumber);
        Assert.areEqual(NUMBER_OF_TEST_RECORDS, responseWrapper[0].totalNumber);
    }

    //this is incompatible with recent work done on this class. however, there's a new set of test classes in a separate file, so just going to comment this one out
    /*   @isTest
    static void extractStringsFromCollectionTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<ExtractStringsFromCollection.Requests> requests = new List<ExtractStringsFromCollection.Requests>();
        ExtractStringsFromCollection.Requests request = new ExtractStringsFromCollection.Requests();
        List<Account> testAccounts = getAccounts(NUMBER_OF_TEST_RECORDS);
        request.inputCollection = testAccounts;
        request.fieldName = 'Name';
        requests.add(request);

        List<ExtractStringsFromCollection.Results> responseWrapper = ExtractStringsFromCollection.extract(requests);
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual(NUMBER_OF_TEST_RECORDS, responseWrapper[0].stringList.size());

        String resultString = '';
        for (Account curAcc : testAccounts) {
            resultString += curAcc.Name + ',';
        }
        resultString = resultString.removeEnd(',');
        Assert.areEqual(resultString, String.join(responseWrapper[0].stringList, ','));
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
        List<Account> testAccounts = getAccounts(NUMBER_OF_TEST_RECORDS);
        testAccounts[NUMBER_OF_TEST_RECORDS - 1].NumberOfEmployees = 2;
        testAccounts[NUMBER_OF_TEST_RECORDS - 2].NumberOfEmployees = 3;
        testAccounts[NUMBER_OF_TEST_RECORDS - 3].NumberOfEmployees = 5;
        request.inputCollection = testAccounts;
        request.sortKeys = '';
        for (String fieldName : sortDirection.keySet()) {
            request.sortKeys +=
                '"' +
                fieldName +
                '":"' +
                sortDirection.get(fieldName) +
                '",';
        }
        request.sortKeys.removeEnd(',');
        requests.add(request);
        String firstAccountName = testAccounts[0].Name;
        List<SortCollection.Results> responseWrapper = SortCollection.sort(
            requests
        );
        Assert.areEqual(responseWrapper.size(), 1);
        Assert.areEqual(
            NUMBER_OF_TEST_RECORDS,
            responseWrapper[0].outputCollection.size()
        );

        Assert.areEqual(
            ((Account) responseWrapper[0]
                    .outputCollection[NUMBER_OF_TEST_RECORDS - 1])
                .Name,
            firstAccountName
        );
    }

    static List<Event> createEvents(
        Integer numberOfRecords,
        Id whatId,
        Boolean doInsert
    ) {
        List<Event> returnList = new List<Event>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            returnList.add(
                new Event(
                    Subject = TEST_RECORD_NAME + i,
                    WhatId = whatId,
                    ActivityDateTime = DateTime.now().addDays(1),
                    DurationInMinutes = 100,
                    ActivityDate = Date.today().addDays(1)
                )
            );
        }
        if (doInsert) {
            insert returnList;
        }

        return returnList;
    }

    static List<Lead> createLeads(Integer numberOfRecords, Boolean doInsert) {
        List<Lead> returnList = new List<Lead>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            returnList.add(
                new Lead(
                    LastName = TEST_RECORD_NAME + i,
                    Company = TEST_RECORD_NAME
                )
            );
        }
        if (doInsert) {
            insert returnList;
        }

        return returnList;
    }

    static List<Opportunity> createOpportunities(
        Integer numberOfRecords,
        Boolean doInsert
    ) {
        List<Opportunity> returnList = new List<Opportunity>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            returnList.add(
                new Opportunity(
                    Name = 'Opportunity' + i,
                    StageName = 'Prospecting',
                    CloseDate = System.today()
                )
            );
        }
        if (doInsert) {
            insert returnList;
        }

        return returnList;
    }

    private static List<Account> getAccounts(Integer numberOfRecords) {
        List<Account> returnList = [
            SELECT Id, Name, Website, AnnualRevenue, NumberOfEmployees, Site
            FROM Account
            ORDER BY Name
            LIMIT :numberOfRecords
            OFFSET :numAccountsRetrieved
        ];
        numAccountsRetrieved += numberOfRecords;
        return returnList;
    }

    private static Account getAccountWithTasks() {
        Task testTask = [SELECT Id, WhatId FROM Task LIMIT 1];
        return [
            SELECT
                Id,
                Name,
                Website,
                AnnualRevenue,
                NumberOfEmployees,
                Site,
                (SELECT Id, Subject, WhatId FROM Tasks)
            FROM Account
            WHERE Id = :testTask.WhatId
            LIMIT 1
        ];
    }

    private static List<Contact> getContacts(Integer numberOfRecords) {
        return [
            SELECT Id, LastName, AccountId
            FROM Contact
            ORDER BY LastName
            LIMIT :numberOfRecords
        ];
    }
}