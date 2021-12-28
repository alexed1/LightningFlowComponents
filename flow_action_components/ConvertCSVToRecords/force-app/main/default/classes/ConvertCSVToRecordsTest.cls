@isTest
public with sharing class ConvertCSVToRecordsTest {
    private static final String SPACE = ' ';
    private static final String SAMPLE_DESCRIPTION = 'Sample Description';
    private static final String DESCRIPTION_WITH_COMMAS_NEWLINE_AND_QUOTES = 'Agent, Commercial; Agent, Residential; Appraiser; Broker \n Business; ""Escrow Officer""; Landlord; Property Manager';
    private static final String DESCRIPTION_WITH_COMMAS_NEWLINE_AND_QUOTES_POST_PARSE = 'Agent, Commercial; Agent, Residential; Appraiser; Broker \n Business; "Escrow Officer"; Landlord; Property Manager'; // '""' is replaced indicates a single '"' within a column. The value after parsing should indicate that.
    private static final String NEW_YORK = 'New York';
    private static final String HOT = 'Hot';
    private static final String PERCENT_VAL_ONE = '23.2';
    private static final String PERCENT_VAL_TWO = '4.33';

    @TestSetup
    private static void createData() {
        ContentVersion cv = new ContentVersion(Title = 'Demo Accounts CSV', VersionData = createCSVBlob(), PathOnClient = 'DemoAccounts.csv');
        insert cv;
    }

    @isTest
    private static void testconvertMethodExceptions() {
        ConvertCSVToRecords.Request[] flowInputs = createFlowInputsList();

        /* 1. FlowInput list size more than 1 exception
         */
        try {
            ConvertCSVToRecords.Request input = new ConvertCSVToRecords.Request();
            input.FSep = ',';
            flowInputs.add(input);
            ConvertCSVToRecords.Response[] flowOutputs = ConvertCSVToRecords.convert(flowInputs);
        } catch (Exception e) {
            System.debug('ddd' + e.getMessage() + e.getStackTraceString());
            System.assert(e.getMessage().contains('You need to provide either a single ContentDocument Id OR a list of ContentDocumentIds as inputs to this Flow action.'));
        }
    }

    @isTest
    private static void testconvertMethod() {
        ConvertCSVToRecords.Request[] flowInputs = createFlowInputsList();
        Test.startTest();
        ConvertCSVToRecords.Response[] flowOutputs = ConvertCSVToRecords.convert(flowInputs);
        Test.stopTest();
        System.assert(flowOutputs[0].convertedCSVRows.size() == 3);
        List<Account> accList = flowOutputs[0].convertedCSVRows;
        System.assertEquals(3, accList.size(), 'Expected 2 accounts to be parsed from csv input');
        System.assertEquals(DESCRIPTION_WITH_COMMAS_NEWLINE_AND_QUOTES_POST_PARSE, accList[1].Description, 'The description field with commas, newline and quotes was not parsed correctly');
    }

    @isTest
    private static void testIsTrimFlagPositive() {
        ConvertCSVToRecords.Request[] flowInputs = createFlowInputsList();
        flowInputs[0].isTrim = true;
        Test.startTest();
        ConvertCSVToRecords.Response[] flowOutputs = ConvertCSVToRecords.convert(flowInputs);
        Test.stopTest();
        System.assertEquals(flowOutputs[0].convertedCSVRows.size(), 3, 'Expected to see three rows from the converted csv');
        Account acc = (Account) flowOutputs[0].convertedCSVRows[0];
        System.debug(acc.Description);
        System.debug(SAMPLE_DESCRIPTION);
        System.assertEquals(acc.Description, SAMPLE_DESCRIPTION, 'Setting isTrim to true did not trim the leading space from Description field');
        System.assertEquals(acc.Rating, HOT, 'Setting isTrim to true did not trim the leading space from Rating field');
        System.assertEquals(acc.Site, NEW_YORK, 'Setting isTrim to true did not trim the trailing space from City field');
    }

    @isTest
    private static void testIsTrimFlagNegative() {
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
    private static void testGetFieldTypeMethodException() {
        try {
            ConvertCSVToRecords.getFieldType(Schema.SObjectType.Account.fields.getMap(), 'TestField');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Invalid Field Error'));
        }
    }

    @isTest
    private static void testGetConvertedFieldValue() {
        /**
         * Check DOUBLE field
         */
        Object result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.DOUBLE, '1234.56', ',', ',', '', '');
        System.assertEquals('1234.56', String.valueOf((Decimal) result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.DOUBLE, '1234,56', '.', ',', '', '');
        System.assertEquals('1234.56', String.valueOf((Decimal) result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.DOUBLE, '1234,56', ',', '.', '', '');
        System.assertEquals('123456', String.valueOf((Decimal) result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.DOUBLE, '1,234.56', ',', '.', '', '');
        System.assertEquals('1234.56', String.valueOf((Decimal) result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.DOUBLE, '1.234,56', '.', ',', '', '');
        System.assertEquals('1234.56', String.valueOf((Decimal) result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.DOUBLE, '-1.234,56', '.', ',', '', '');
        System.assertEquals('-1234.56', String.valueOf((Decimal) result));

        /*
         * Check currency field
         */
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.CURRENCY, '$1234.56', ',', ',', '$', '');
        System.assertEquals('1234.56', String.valueOf((Decimal) result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.CURRENCY, '$1234,56', '.', ',', '$', '');
        System.assertEquals('1234.56', String.valueOf((Decimal) result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.CURRENCY, '€1234,56', ',', '.', '€', '');
        System.assertEquals('123456', String.valueOf((Decimal) result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.CURRENCY, '$1,234.56', ',', '.', '$', '');
        System.assertEquals('1234.56', String.valueOf((Decimal) result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.CURRENCY, '1.234,56', '.', ',', '$', '');
        System.assertEquals('1234.56', String.valueOf((Decimal) result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.CURRENCY, '-1.234,56', '.', ',', '$', '');
        System.assertEquals('-1234.56', String.valueOf((Decimal) result));

        /*
         * Check percent field
         */
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.PERCENT, '0.55', ',', ',', '', '');
        System.assertEquals(0.55, (Decimal) result);
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.PERCENT, '125', '.', ',', '$', '');
        System.assertEquals(125, (Decimal) result);
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.PERCENT, '12.5', ',', '.', '€', '');
        System.assertEquals(12.5, (Decimal) result);

        /*
         * Check Integer fields
         */
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.INTEGER, '55', ',', '.', '', '');
        System.assertEquals(55, Integer.valueOf(result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.INTEGER, '1,125', ',', '.', '', '');
        System.assertEquals(1125, Integer.valueOf(result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.INTEGER, '1.234', '.', ',', '', '');
        System.assertEquals(1234, Integer.valueOf(result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.INTEGER, '-1.234', '.', ',', '', '');
        System.assertEquals(-1234, Integer.valueOf(result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.INTEGER, '-1.234,00', '.', ',', '', '');
        System.assertEquals(-1234, Integer.valueOf(result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.INTEGER, '', '.', ',', '', '');
        System.assertEquals(null, result);

        /*
         * Check date field
         */

        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.DATE, '1/12/2021', ',', ',', '', '');
        System.assertEquals(Date.parse('01/12/2021'), result);
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.DATE, '1/12/2021', '.', ',', '', 'MM-dd-yyyy');
        System.assertEquals('2021-01-12', String.valueOf((Date) result), 'Result is ' + result);
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.DATE, '1/12/2021', ',', '.', '', 'dd/MM/yyyy');
        System.assertEquals('2021-12-01', String.valueOf((Date) result));
        result = ConvertCSVToRecords.getConvertedFieldValue(Schema.DisplayType.DATE, '2021-1-12', ',', '.', '', '');
        System.assertEquals('2021-01-12', String.valueOf((Date) result));
    }

    @isTest
    private static void testConvertMultipleContentDocs() {
        createData(); //Create the document once more so we have a list of contentdocument ids
        //System.assert(false,[Select Id from ContentVersion].size());
        ConvertCSVToRecords.Request[] flowInputs = createFlowInputsList();
        Test.startTest();
        ConvertCSVToRecords.Response[] flowOutputs = ConvertCSVToRecords.convert(flowInputs);
        Test.stopTest();
        //We should get 2 responses in the output array, one for each ContentDocument Id
        System.assertEquals(2, flowOutputs.size(), 'Expected 2 outputs from action, one for each Content Document Id');
        for (ConvertCSVToRecords.Response flowOutput : flowOutputs) {
            System.assert(flowOutput.convertedCSVRows.size() == 3, 'Expected 6 records but got ' + flowOutput.convertedCSVRows.size());
            List<Account> accList = flowOutput.convertedCSVRows;
            System.assertEquals(3, accList.size(), 'Expected 2 accounts to be parsed from csv input');
            System.assertEquals(DESCRIPTION_WITH_COMMAS_NEWLINE_AND_QUOTES_POST_PARSE, accList[1].Description, 'The description field with commas, newline and quotes was not parsed correctly');
        }
    }

    @isTest
    private static void testDateAndPercentFieldType() {
        ContentVersion cv = new ContentVersion(Title = 'Demo Opp CSV', VersionData = createOpportunityCSVBlob(), PathOnClient = 'DemoOpps.csv');
        insert cv;
        ConvertCSVToRecords.Request[] flowInputs = createOppFlowInputList();
        Test.startTest();
        ConvertCSVToRecords.Response[] flowOutputs = ConvertCSVToRecords.convert(flowInputs);
        Test.stopTest();
        System.assert(flowOutputs[0].convertedCSVRows.size() == 2);
        List<Opportunity> oppsList = flowOutputs[0].convertedCSVRows;
        System.assertEquals(2, oppsList.size(), 'Expected 2 opportunities to be parsed from csv input');
        System.assertEquals(PERCENT_VAL_ONE, String.valueOf(oppsList[0].Probability));
        System.assertEquals(PERCENT_VAL_TWO, String.valueOf(oppsList[1].Probability));
        System.assertEquals('2021-01-01', String.valueOf(oppsList[0].CloseDate));
        System.assertEquals(Date.parse('08/12/2022'), oppsList[1].CloseDate); //By default, the date is parsed based on the user's locale
    }

    private static Blob createCSVBlob() {
        String csvStringContent;
        Blob csvBlobContent;
        string[] fields = new List<String>{ 'Description', 'AnnualRevenue', 'NumberOfEmployees', 'Rating', 'Name', 'Site' };

        String csvHeader = String.join(fields, ',') + '\n';
        csvStringContent = csvHeader;
        csvStringContent += SPACE + SAMPLE_DESCRIPTION + ',500000,300,' + SPACE + HOT + ',"Acme, Inc",' + NEW_YORK + SPACE;
        csvStringContent += '\n';
        csvStringContent += '"' + DESCRIPTION_WITH_COMMAS_NEWLINE_AND_QUOTES + '",40000,30,Hot,"Universal Containers","Washington, DC"';
        csvStringContent += '\n';
        csvStringContent += ',40000,20,Hot,"Universal Containers", ';
        return Blob.valueOf(csvStringContent);
    }

    private static Blob createOpportunityCSVBlob() {
        String csvStringContent;
        Blob csvBlobContent;
        string[] fields = new List<String>{ 'Name', 'Probability', 'CloseDate' };

        String csvHeader = String.join(fields, ',') + '\n';
        csvStringContent = csvHeader;
        csvStringContent += 'Opp One,' + PERCENT_VAL_ONE + ',2021-01-01';
        csvStringContent += '\n';
        csvStringContent += 'Opp Two,' + PERCENT_VAL_TWO + ',8/12/2022';
        csvStringContent += '\n';
        return Blob.valueOf(csvStringContent);
    }

    private static ConvertCSVToRecords.Request[] createFlowInputsList() {
        String contentDocumentId;
        List<ContentVersion> cvList = [SELECT ContentDocumentId, FileType FROM ContentVersion WHERE Title = 'Demo Accounts CSV'];
        ConvertCSVToRecords.Request[] flowInputs = new List<ConvertCSVToRecords.Request>{};
        ConvertCSVToRecords.Request input = new ConvertCSVToRecords.Request();
        input.objectApiName = 'Account';
        if (cvList.size() == 1) {
            input.contentDocumentId = cvList[0].ContentDocumentId;
        } else if (cvList.size() > 1) {
            input.contentDocumentIdList = new List<Id>();
            for (ContentVersion cv : cvList) {
                input.contentDocumentIdList.add(cv.ContentDocumentId);
            }
        }
        input.FSep = ',';
        input.TSep = ',';
        input.DSep = '.';
        input.vCur = '$';
        flowInputs.add(input);

        return flowInputs;
    }

    private static ConvertCSVToRecords.Request[] createOppFlowInputList() {
        String contentDocumentId;
        List<ContentVersion> cvList = [SELECT ContentDocumentId, FileType FROM ContentVersion WHERE Title = 'Demo Opp CSV'];
        ConvertCSVToRecords.Request[] flowInputs = new List<ConvertCSVToRecords.Request>{};
        ConvertCSVToRecords.Request input = new ConvertCSVToRecords.Request();
        input.objectApiName = 'Opportunity';
        if (cvList.size() == 1) {
            input.contentDocumentId = cvList[0].ContentDocumentId;
        } else if (cvList.size() > 1) {
            input.contentDocumentIdList = new List<Id>();
            for (ContentVersion cv : cvList) {
                input.contentDocumentIdList.add(cv.ContentDocumentId);
            }
        }
        input.FSep = ',';
        input.TSep = ',';
        input.DSep = '.';
        input.vCur = '$';
        flowInputs.add(input);

        return flowInputs;
    }
}
