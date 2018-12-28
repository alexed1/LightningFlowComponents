@isTest
public class StoreDataInQuipSheetTest {

    class QuipMock implements StubProvider {

        private Map<String, List<List<Object>>> methodCalls;

        public QuipMock(Map<String, List<List<Object>>> methodCalls) {
            this.methodCalls = methodCalls;
        }

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (methodCalls != null) {
                List<List<Object>> calls = methodCalls.get(stubbedMethodName);
                if (calls == null) {
                    calls = new List<List<Object>>();
                    methodCalls.put(stubbedMethodName, calls);
                }
                calls.add(new List<Object>(listOfArgs));
            }
            if (stubbedMethodName == 'findThread') {
                String threadId = listOfArgs[0].toString();
                if (threadId == 'Valid') {
                    Thread thread = new Thread('Valid');
                    ThreadSheet sheet = new ThreadSheet();
                    sheet.title = 'Sheet';
                    thread.sheets.add(sheet);
                    ThreadRow row = new ThreadRow('row0');
                    row.cells.add(new ThreadCell(Address.parse('A1'), 'col0', 'AOne'));
                    row.cells.add(new ThreadCell(Address.parse('B1'), 'col1', 'BOne'));
                    row.cells.add(new ThreadCell(Address.parse('C1'), 'col2', 'COne'));
                    sheet.rows.add(row);
                    return thread;
                } else if (threadId == 'DoesntExist') {
                    return null;
                } else if (threadId == 'NoSheet') {
                    Thread thread = new Thread('NoSheet');
                    return thread;
                } else if (threadId == 'NoNamedSheet') {
                    Thread thread = new Thread('NoNamedSheet');
                    ThreadSheet sheet = new ThreadSheet();
                    sheet.title = 'DoesntMatch';
                    thread.sheets.add(sheet);
                    return thread;
                }
                return null;
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void StoreDataInQuipSheetImpl_WhenFileDoesntExist_ThrowsException() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock(null));
        StoreDataInQuipSheet.Request request = new StoreDataInQuipSheet.Request();
        request.FileName = 'DoesntExist';
        request.Address1 = 'A1';
        StoreDataInQuipSheet.Response response = StoreDataInQuipSheet.StoreDataInQuipSheetImpl(quip, request);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('File with the name "DoesntExist" was not found', response.ErrorMessage);
    }

    @isTest
    public static void StoreDataInQuipSheetImpl_WhenFileDoesntContainSheets_ThrowsException() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock(null));
        StoreDataInQuipSheet.Request request = new StoreDataInQuipSheet.Request();
        request.FileName = 'NoSheet';
        request.Address1 = 'A1';
        StoreDataInQuipSheet.Response response = StoreDataInQuipSheet.StoreDataInQuipSheetImpl(quip, request);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('File "NoSheet" doesn\'t contain child sheets', response.ErrorMessage);
    }

    @isTest
    public static void StoreDataInQuipSheetImpl_WhenFileDoesntContainSheetWithSpecificName_ThrowsException() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock(null));
        StoreDataInQuipSheet.Request request = new StoreDataInQuipSheet.Request();
        request.FileName = 'NoNamedSheet';
        request.SheetName = 'Sheet';
        request.Address1 = 'A1';
        request.Value1 = 'Test1';
        StoreDataInQuipSheet.Response response = StoreDataInQuipSheet.StoreDataInQuipSheetImpl(quip, request);
        System.assert(!response.IsSuccess);
        System.assertEquals('File "NoNamedSheet" doesn\'t contain sheet "Sheet"', response.ErrorMessage);
    }

    @isTest
    public static void StoreDataInQuipSheetImpl_WhenEverythingIsOK_CallsApi() {
        Map<String, List<List<Object>>> methodCalls = new Map<String, List<List<Object>>>();
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock(methodCalls));
        StoreDataInQuipSheet.Request request = new StoreDataInQuipSheet.Request();
        request.FileName = 'Valid';
        request.SheetName = 'Sheet';
        request.Address1 = 'A1';
        request.Value1 = 'Test1';
        request.Right2 = 'BOne';
        request.Value2 = 'Test2';
        request.Below3 = 'BOne';
        request.Value3 = 'Test3';
        StoreDataInQuipSheet.Response response = StoreDataInQuipSheet.StoreDataInQuipSheetImpl(quip, request);
        System.assert(response.IsSuccess);
        List<List<Object>> calls = methodCalls.get('saveSpreadsheetData');
        System.assert(calls != null, 'saveSpreadsheetData method was not called');
        List<Object> args = calls[0];
        List<ThreadCell> cellsToUpdate = (List<ThreadCell>)args[2];
        ThreadCell cell = cellsToUpdate[0];
        System.assertEquals('A1', cell.addr.toString());
        System.assertEquals('Test1', cell.value);
        cell = cellsToUpdate[1];
        System.assertEquals('C1', cell.addr.toString());
        System.assertEquals('Test2', cell.value);
        cell = cellsToUpdate[2];
        System.assertEquals('B2', cell.addr.toString());
        System.assertEquals('Test3', cell.value);
    }

    @isTest
    public static void StoreDataInQuipSheet_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        StoreDataInQuipSheet.Request request = new StoreDataInQuipSheet.Request();
        request.FileName = 'test';
        List<StoreDataInQuipSheet.Request> requests = new List<StoreDataInQuipSheet.Request> { request };
        List<StoreDataInQuipSheet.Response> responses = StoreDataInQuipSheet.StoreDataInQuipSheet(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
    }
}