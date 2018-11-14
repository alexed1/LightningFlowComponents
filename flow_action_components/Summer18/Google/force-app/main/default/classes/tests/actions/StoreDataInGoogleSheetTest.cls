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
                List<CellValue> newValues = (List<CellValue>)listOfArgs[1];
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
    public static void StoreDataInGoogleSheet_CanStoreByAddress() {
        List<CellValue> valuesToWrite = new List<CellValue>();
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock(valuesToWrite));
        StoreDataInGoogleSheet.GoogleSheetsRequest request = new StoreDataInGoogleSheet.GoogleSheetsRequest();
        request.aSpreadsheetName = 'ByAddress';
        request.RelativeDirection1 = 'Address';
        request.TargetLabel1 = 'B2';
        request.Value1 = 'test';
        ActionResponse response = StoreDataInGoogleSheet.StoreDataInGoogleSheetImpl(drive, request);
        System.assert(response.IsSuccess, 'IsSuccess must be true');
        System.assert(String.isBlank(response.ErrorMessage), 'Error message is not empty');
        System.assertEquals('B2', valuesToWrite[0].addr.toString());
        System.assertEquals('test', valuesToWrite[0].value);
    }

    @isTest
    public static void StoreDataInGoogleSheet_CanStoreByBelow() {
        List<CellValue> valuesToWrite = new List<CellValue>();
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock(valuesToWrite));
        StoreDataInGoogleSheet.GoogleSheetsRequest request = new StoreDataInGoogleSheet.GoogleSheetsRequest();
        request.aSpreadsheetName = 'ByBelow';
        request.RelativeDirection1 = 'Below';
        request.TargetLabel1 = 'B1';
        request.Value1 = 'test';
        ActionResponse response = StoreDataInGoogleSheet.StoreDataInGoogleSheetImpl(drive, request);
        System.assert(response.IsSuccess, 'IsSuccess must be true');
        System.assert(String.isBlank(response.ErrorMessage), 'Error message is not empty');
        System.assertEquals('B2', valuesToWrite[0].addr.toString());
        System.assertEquals('test', valuesToWrite[0].value);
    }

    @isTest
    public static void StoreDataInGoogleSheet_CanStoreByRight() {
        List<CellValue> valuesToWrite = new List<CellValue>();
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock(valuesToWrite)); 
        StoreDataInGoogleSheet.GoogleSheetsRequest request = new StoreDataInGoogleSheet.GoogleSheetsRequest();
        request.aSpreadsheetName = 'ByRight';
        request.RelativeDirection1 = 'Right';
        request.TargetLabel1 = 'B1';
        request.Value1 = 'test';
        ActionResponse response = StoreDataInGoogleSheet.StoreDataInGoogleSheetImpl(drive, request);
        System.assert(response.IsSuccess, 'IsSuccess must be true');
        System.assert(String.isBlank(response.ErrorMessage), 'Error message is not empty');
        System.assertEquals('C1', valuesToWrite[0].addr.toString());
        System.assertEquals('test', valuesToWrite[0].value);
    }
}
