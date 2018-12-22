@isTest
public class StoreDataInGoogleSheetTest {

    class GoogleDriveMock implements StubProvider {

        private List<CellValue> cellValues;

        public GoogleDriveMock(List<CellValue> cellValues) {
            this.cellValues = cellValues;
        }

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            //Pretend that file Id equals file name requested
            if (stubbedMethodName == 'FindFileIdByName') {
                return listOfArgs[0];
            }
            if (stubbedMethodName == 'SaveSpreadsheetData') {
                List<CellValue> newValues = (List<CellValue>)listOfArgs[2];
                for (CellValue value: newValues) {
                    cellValues.add(value);
                }
                return null;
            }
            if (stubbedMethodName == 'GetSpreadsheetData') {
                String fileId = listOfArgs[0].toString();
                if (fileId == 'ByAddress') {
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    result.add(row);
                    row = new List<String>();
                    row.add('');
                    row.add('test');
                    result.add(row);
                    return result;
                } else if (fileId == 'ByRight') {
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    row.add('');
                    row.add('B1');
                    result.add(row);
                    return result;
                } else if (fileId == 'ByBelow') {
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    row.add('');
                    row.add('B1');
                    result.add(row);
                    return result;
                }
                return null;
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void StoreDataInGoogleSheetImpl_CanStoreByAddress() {
        List<CellValue> valuesToWrite = new List<CellValue>();
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock(valuesToWrite));
        StoreDataInGoogleSheet.Request request = new StoreDataInGoogleSheet.Request();
        request.SpreadsheetName = 'ByAddress';
        request.Address1 = 'B2';
        request.Value1 = 'test';
        StoreDataInGoogleSheet.Response response = StoreDataInGoogleSheet.StoreDataInGoogleSheetImpl(drive, request);
        System.assert(response.IsSuccess, 'IsSuccess must be true');
        System.assert(String.isBlank(response.ErrorMessage), 'Error message is not empty');
        System.assertEquals('B2', valuesToWrite[0].addr.toString());
        System.assertEquals('test', valuesToWrite[0].value);
    }

    @isTest
    public static void StoreDataInGoogleSheetImpl_CanStoreByBelow() {
        List<CellValue> valuesToWrite = new List<CellValue>();
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock(valuesToWrite));
        StoreDataInGoogleSheet.Request request = new StoreDataInGoogleSheet.Request();
        request.SpreadsheetName = 'ByBelow';
        request.Below1 = 'B1';
        request.Value1 = 'test';
        StoreDataInGoogleSheet.Response response = StoreDataInGoogleSheet.StoreDataInGoogleSheetImpl(drive, request);
        System.assert(response.IsSuccess, 'IsSuccess must be true');
        System.assert(String.isBlank(response.ErrorMessage), 'Error message is not empty');
        System.assertEquals('B2', valuesToWrite[0].addr.toString());
        System.assertEquals('test', valuesToWrite[0].value);
    }

    @isTest
    public static void StoreDataInGoogleSheetImpl_CanStoreByRight() {
        List<CellValue> valuesToWrite = new List<CellValue>();
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock(valuesToWrite)); 
        StoreDataInGoogleSheet.Request request = new StoreDataInGoogleSheet.Request();
        request.SpreadsheetName = 'ByRight';
        request.Right1 = 'B1';
        request.Value1 = 'test';
        StoreDataInGoogleSheet.Response response = StoreDataInGoogleSheet.StoreDataInGoogleSheetImpl(drive, request);
        System.assert(response.IsSuccess, 'IsSuccess must be true');
        System.assert(String.isBlank(response.ErrorMessage), 'Error message is not empty');
        System.assertEquals('C1', valuesToWrite[0].addr.toString());
        System.assertEquals('test', valuesToWrite[0].value);
    }

    @isTest
    public static void StoreDataInGoogleSheet_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        StoreDataInGoogleSheet.Request request = new StoreDataInGoogleSheet.Request();
        request.SpreadsheetName = 'test';
        List<StoreDataInGoogleSheet.Request> requests = new List<StoreDataInGoogleSheet.Request> { request };
        List<StoreDataInGoogleSheet.Response> responses = StoreDataInGoogleSheet.StoreDataInGoogleSheet(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}
