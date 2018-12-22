@isTest
public class AddRowToQuipSheetTest {

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
    public static void AddRowToQuipSheetImpl_WhenFileDoesntExist_ThrowsException() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock(null));
        AddRowToQuipSheet.Request request = new AddRowToQuipSheet.Request();
        request.FileName = 'DoesntExist';
        AddRowToQuipSheet.Response response = AddRowToQuipSheet.AddRowToQuipSheetImpl(quip, request);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('File with the name "DoesntExist" was not found', response.ErrorMessage);
    }

    @isTest
    public static void AddRowToQuipSheetImpl_WhenFileDoesntContainSheets_ThrowsException() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock(null));
        AddRowToQuipSheet.Request request = new AddRowToQuipSheet.Request();
        request.FileName = 'NoSheet';
        AddRowToQuipSheet.Response response = AddRowToQuipSheet.AddRowToQuipSheetImpl(quip, request);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('File "NoSheet" doesn\'t contain child sheets', response.ErrorMessage);
    }

    @isTest
    public static void AddRowToQuipSheetImpl_WhenFileDoesntContainSheetWithSpecificName_ThrowsException() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock(null));
        AddRowToQuipSheet.Request request = new AddRowToQuipSheet.Request();
        request.FileName = 'NoNamedSheet';
        request.SheetName = 'Sheet';
        AddRowToQuipSheet.Response response = AddRowToQuipSheet.AddRowToQuipSheetImpl(quip, request);
        System.assert(!response.IsSuccess);
        System.assertEquals('File "NoNamedSheet" doesn\'t contain sheet "Sheet"', response.ErrorMessage);
    }

    @isTest
    public static void AddRowToQuipSheetImpl_WhenEverythingIsOK_CallsApi() {
        Map<String, List<List<Object>>> methodCalls = new Map<String, List<List<Object>>>();
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock(methodCalls));
        AddRowToQuipSheet.Request request = new AddRowToQuipSheet.Request();
        request.FileName = 'Valid';
        request.SheetName = 'Sheet';
        request.TargetColumnName1 = 'BOne';
        request.Value1 = 'Test1';
        AddRowToQuipSheet.Response response = AddRowToQuipSheet.AddRowToQuipSheetImpl(quip, request);
        System.assert(response.IsSuccess);
        List<List<Object>> calls = methodCalls.get('saveSpreadsheetData');
        System.assert(calls != null, 'saveSpreadsheetData method was not called');
        List<Object> args = calls[0];
        List<ThreadCell> cellsToUpdate = (List<ThreadCell>)args[2];
        ThreadCell cell = cellsToUpdate[0];
        System.assertEquals('B2', cell.addr.toString());
        System.assertEquals('Test1', cell.value);
    }

    @isTest
    public static void AddRowToQuipSheet_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        AddRowToQuipSheet.Request request = new AddRowToQuipSheet.Request();
        request.FileName = 'test';
        List<AddRowToQuipSheet.Request> requests = new List<AddRowToQuipSheet.Request> { request };
        List<AddRowToQuipSheet.Response> responses = AddRowToQuipSheet.AddRowToQuipSheet(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}