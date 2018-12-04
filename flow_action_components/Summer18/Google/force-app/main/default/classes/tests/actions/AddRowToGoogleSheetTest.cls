@isTest
public class AddRowToGoogleSheetTest {

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
            if (stubbedMethodName.equalsIgnoreCase('findFileIdByName')) {
                return listOfArgs[0];
            }
            if (stubbedMethodName.equalsIgnoreCase('saveSpreadsheetData')) {
                List<CellValue> newValues = (List<CellValue>)listOfArgs[2];
                for (CellValue value: newValues) {
                    cellValues.add(value);
                }
                return null;
            }
            if (stubbedMethodName.equalsIgnoreCase('getSpreadsheetData')) {
                List<List<String>> result = new List<List<String>>();
                List<String> row = new List<String> { 'Header1' };
                result.add(row);
                return result;
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void AddRowToGoogleSheetImpl_SavesBothByHeaderAndValue() {
        List<CellValue> valuesToWrite = new List<CellValue>();
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock(valuesToWrite));
        AddRowToGoogleSheet.Request request = new AddRowToGoogleSheet.Request();
        request.SpreadsheetName = 'Test';
        request.TargetColumnName1 = 'Header1';
        request.Value1 = 'test1';
        request.TargetColumnName2 = 'B';
        request.Value2 = 'test2';
        AddRowToGoogleSheet.Response response = AddRowToGoogleSheet.AddRowToGoogleSheetImpl(drive, request);
        System.assert(response.IsSuccess, 'IsSuccess must be true');
        System.assert(String.isBlank(response.ErrorMessage), 'Error message is not empty');
        System.assertEquals('A2', valuesToWrite[0].addr.toString());
        System.assertEquals('test1', valuesToWrite[0].value);
        System.assertEquals('B2', valuesToWrite[1].addr.toString());
        System.assertEquals('test2', valuesToWrite[1].value);
    }

    @isTest
    public static void AddRowToGoogleSheet_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        AddRowToGoogleSheet.Request request = new AddRowToGoogleSheet.Request();
        request.SpreadsheetName = 'test';
        request.TargetColumnName1 = 'Header1';
        request.Value1 = 'test1';
        List<AddRowToGoogleSheet.Request> requests = new List<AddRowToGoogleSheet.Request> { request };
        List<AddRowToGoogleSheet.Response> responses = AddRowToGoogleSheet.AddRowToGoogleSheet(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}
