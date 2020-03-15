@isTest
public with sharing class ListActionsTest {
    private final static Integer NUMBER_OF_TEST_RECORDS = 5;
    private final static String TEST_RECORD_NAME = 'Test Acc';

    @isTest
    static void cloneRecordTests() {
        //user must pass in at least one input recordid or an input record
        String noInputsMessage = 'You need to pass either a record or a recordId into this action, representing the entity you want to clone';
        String dualInputsMessage = 'You need to pass either a record or a recordId into this action, but you can not pass both';
        List<CloneParentRecordAndChildRecords.Requests> requests = new List<CloneParentRecordAndChildRecords.Requests>();
        CloneParentRecordAndChildRecords.Requests request = new CloneParentRecordAndChildRecords.Requests();
        requests.add(request);
        List<CloneParentRecordAndChildRecords.Results> responseWrapper = CloneParentRecordAndChildRecords.clone(requests);
        System.assertEquals(responseWrapper[0].errorText, noInputsMessage );
        requests.clear();

        //user can't pass in both an input recordid and an input record
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputRecordId = testAccounts[0].Id;
        request.inputRecord = testAccounts[0];
        requests.add(request);
        responseWrapper = CloneParentRecordAndChildRecords.clone(requests);
        System.assertEquals(responseWrapper[0].errorText, dualInputsMessage );
        requests.clear();

        request.inputRecordId = null;
        request.inputRecord = testAccounts[0];
        requests.add(request);
        responseWrapper = CloneParentRecordAndChildRecords.clone(requests);
        System.assertNotEquals(responseWrapper[0].clonedRecord, null );
        requests.clear();

        request.inputRecordId = testAccounts[0].Id;
        request.inputRecord = null;
        requests.add(request);
        responseWrapper = CloneParentRecordAndChildRecords.clone(requests);
        System.assertNotEquals(responseWrapper[0].clonedRecord, null );
        requests.clear();

        request.preserveId = true;
        request.inputRecordId = testAccounts[0].Id;
        request.inputRecord = null;
        requests.add(request);
        responseWrapper = CloneParentRecordAndChildRecords.clone(requests);
        System.assertEquals(responseWrapper[0].clonedRecord.Id, testAccounts[0].Id );
        requests.clear();

        request.preserveId = false;
        request.inputRecordId = testAccounts[0].Id;
        request.inputRecord = null;
        request.saveImmediately = true;
        requests.add(request);
        responseWrapper = CloneParentRecordAndChildRecords.clone(requests);
        System.assertNotEquals(responseWrapper[0].clonedRecord.Id, testAccounts[0].Id );
        System.assertNotEquals(responseWrapper[0].clonedRecord.Id, null );
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
        List<GenerateCollectionReport.Requests> requests = new List<GenerateCollectionReport.Requests>();
        GenerateCollectionReport.Requests request = new GenerateCollectionReport.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.shownFields = 'Name';
        requests.add(request);
        List<GenerateCollectionReport.Results> responseWrapper = GenerateCollectionReport.generateReport(requests);
        System.assertEquals(responseWrapper.size(), 1);
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
                'Website' => 'www.site.com',
                'Name' => 'DifferentName'
        };

        List<MapCollection.Requests> requests = new List<MapCollection.Requests>();
        MapCollection.Requests request = new MapCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
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
                System.assertEquals(fieldNameValue.get(fieldName), obj.get(fieldName));
            }
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

    @isTest
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
    }

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

     static List<Account> createAccounts(Integer numberOfRecords, Boolean doInsert) {

        List<Account> returnList = new List<Account>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            returnList.add(new Account(Name = TEST_RECORD_NAME + i, Website = '' + i));
        }
        if (doInsert) {
            insert returnList;
        }

        return returnList;
    }
}