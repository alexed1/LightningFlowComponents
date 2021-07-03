@isTest
public with sharing class ConvertCSVToRecordsTest {
    private static final String SPACE = ' ';
    private static final String SAMPLE_DESCRIPTION = 'Sample Description';
    private static final String NEW_YORK = 'New York';
    private static final String HOT = 'Hot';

    @TestSetup
    static void createData() {
        ContentVersion cv = new ContentVersion(Title = 'Demo Accounts CSV', VersionData = createCSVBlob(), PathOnClient = 'DemoAccounts.csv');
        insert cv;
    }

    @isTest
    static void testconvertMethodExceptions() {
        ConvertCSVToRecords.Request[] flowInputs = createFlowInputsList();

        /* 1. FlowInput list size more than 1 exception
         */
        try {
            ConvertCSVToRecords.Request input = new ConvertCSVToRecords.Request();
            flowInputs.add(input);
            ConvertCSVToRecords.Response[] flowOutputs = ConvertCSVToRecords.convert(flowInputs);
        } catch (Exception e) {
            System.assert(e.getMessage().contains('This action is only supported in Screen flows.'));
        }
    }

    @isTest
    static void testconvertMethod() {
        ConvertCSVToRecords.Request[] flowInputs = createFlowInputsList();
        Test.startTest();
        ConvertCSVToRecords.Response[] flowOutputs = ConvertCSVToRecords.convert(flowInputs);
        Test.stopTest();
        System.assert(flowOutputs[0].convertedCSVRows.size() == 3);
    }

    @isTest
    static void testIsTrimFlagPositive() {
        ConvertCSVToRecords.Request[] flowInputs = createFlowInputsList();
        flowInputs[0].isTrim = true;
        Test.startTest();
        ConvertCSVToRecords.Response[] flowOutputs = ConvertCSVToRecords.convert(flowInputs);
        Test.stopTest();
        System.assertEquals(flowOutputs[0].convertedCSVRows.size(), 3, 'Expected to see three rows from the converted csv');
        Account acc = (Account) flowOutputs[0].convertedCSVRows[0];
        System.assertEquals(acc.Description, SAMPLE_DESCRIPTION, 'Setting isTrim to true did not trim the leading space from Description field');
        System.assertEquals(acc.Rating, HOT, 'Setting isTrim to true did not trim the leading space from Rating field');
        System.assertEquals(acc.Site, NEW_YORK, 'Setting isTrim to true did not trim the trailing space from City field');
    }

    @isTest
    static void testIsTrimFlagNegative() {
        ConvertCSVToRecords.Request[] flowInputs = createFlowInputsList();
        flowInputs[0].isTrim = false;
        Test.startTest();
        ConvertCSVToRecords.Response[] flowOutputs = ConvertCSVToRecords.convert(flowInputs);
        Test.stopTest();
        System.assertEquals(flowOutputs[0].convertedCSVRows.size(), 3, 'Expected to see three rows from the converted csv');
        Account acc = (Account) flowOutputs[0].convertedCSVRows[0];
        System.assertEquals(acc.Description, SPACE + SAMPLE_DESCRIPTION, 'Setting isTrim to false did not stop the leading space from being trimmed from the description field');
        System.assertEquals(acc.Rating, SPACE + HOT, 'Setting isTrim to false did not stop the leading space from being trimmed from the rating field');
        System.assertEquals(acc.Site, NEW_YORK + SPACE, 'Setting isTrim to false did not stop the trailing space from being trimmed from the city field');
    }

    @isTest
    static void testGetFieldTypeMethodException() {
        try {
            ConvertCSVToRecords.getFieldType(Schema.SObjectType.Account.fields.getMap(), 'TestField');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Invalid Field Error'));
        }
    }

    static Blob createCSVBlob() {
        String csvStringContent;
        Blob csvBlobContent;
        string[] fields = new List<String>{ 'Description', 'AnnualRevenue', 'NumberOfEmployees', 'Rating', 'Name', 'Site' };

        String csvHeader = String.join(fields, ',') + '\n';
        csvStringContent = csvHeader;
        csvStringContent += SPACE + SAMPLE_DESCRIPTION + ',500000,300,' + SPACE + HOT + ',"Acme, Inc",' + NEW_YORK + SPACE;
        csvStringContent += '\n';
        csvStringContent += '"Sample Description,\nwith new line",40000,30,Hot,"Universal Containers","Washington, DC"';
        csvStringContent += '\n';
        csvStringContent += ',40000,20,Hot,"Universal Containers",';
        return Blob.valueOf(csvStringContent);
    }
    static ConvertCSVToRecords.Request[] createFlowInputsList() {
        String contentDocumentId;
        ContentVersion cv = [SELECT ContentDocumentId, FileType FROM ContentVersion WHERE Title = 'Demo Accounts CSV'];
        ConvertCSVToRecords.Request[] flowInputs = new List<ConvertCSVToRecords.Request>{};
        ConvertCSVToRecords.Request input = new ConvertCSVToRecords.Request();
        input.objectApiName = 'Account';
        input.contentDocumentId = cv.ContentDocumentId;
        flowInputs.add(input);

        return flowInputs;
    }
}
