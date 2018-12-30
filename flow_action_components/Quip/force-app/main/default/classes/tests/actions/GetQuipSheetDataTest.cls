@isTest
public class GetQuipSheetDataTest {

    class QuipMock implements StubProvider { 

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (stubbedMethodName == 'findThread') {
                String threadId = listOfArgs[0].toString();
                if (threadId == 'ByAddress') {
                    ThreadSheet sheet = new ThreadSheet();
                    ThreadRow row = new ThreadRow('1');
                    sheet.rows.add(row);
                    row = new ThreadRow('2');
                    sheet.rows.add(row);
                    ThreadCell cell = new ThreadCell(Address.parse('A2'), '1', '');
                    row.cells.add(cell);
                    cell = new ThreadCell(Address.parse('B2'), '2', 'test');
                    row.cells.add(cell);
                    Thread thread = new Thread('1');
                    thread.sheets.add(sheet);
                    return thread;
                } else if (threadId == 'ByRight') {
                    ThreadSheet sheet = new ThreadSheet(); 
                    ThreadRow row = new ThreadRow('1');
                    sheet.rows.add(row);
                    row = new ThreadRow('2');
                    sheet.rows.add(row);
                    ThreadCell cell = new ThreadCell(Address.parse('A2'), '1', '1');
                    row.cells.add(cell);
                    cell = new ThreadCell(Address.parse('B2'), '2', 'test');
                    row.cells.add(cell);
                    Thread thread = new Thread('1');
                    thread.sheets.add(sheet);
                    return thread;
                } else if (threadId == 'ByBelow') {
                    ThreadSheet sheet = new ThreadSheet();
                    ThreadRow row = new ThreadRow('1');
                    sheet.rows.add(row);
                    row = new ThreadRow('2');
                    sheet.rows.add(row);
                    ThreadCell cell = new ThreadCell(Address.parse('A2'), '1', '1');
                    row.cells.add(cell);
                    row = new ThreadRow('3');
                    sheet.rows.add(row);
                    cell = new ThreadCell(Address.parse('A2'), '2', 'test');
                    row.cells.add(cell);
                    Thread thread = new Thread('1');
                    thread.sheets.add(sheet);
                    return thread;
                } else if (threadId == 'OutsideOfTheRange' || threadId == 'InvalidAddress') {
                    Thread thread = new Thread('1');
                    ThreadSheet sheet = new ThreadSheet();
                    thread.sheets.add(sheet);
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
    public static void GetQuipSheetDataImpl_CanFindByAddress() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'ByAddress';
        request.Address1 = 'B2';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.debug(response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value1);
    }

    @isTest
    public static void GetQuipSheetDataImpl_CanFindByRight() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'ByRight';
        request.Right2 = '1';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value2);
    }

    @isTest
    public static void GetQuipSheetDataImpl_CanFindByBelow() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'ByBelow';
        request.Below3 = '1';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value3);
    }
    
    @isTest
    public static void GetQuipSheetDataImpl_OutsideOfTheRange_ReturnsEmptyString() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'OutsideOfTheRange';
        request.Address4 = 'A100';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assert(String.isBlank(response.Value4));
    }    
    
    @isTest
    public static void GetQuipSheetDataImpl_InvalidAddress_ThrowsException() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'InvalidAddress';
        request.Address5 = 'Invalid';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('Address "Invalid" doesn\'t contain row part', response.ErrorMessage);
        System.assert(String.isBlank(response.Value5));
    }

    @isTest
    public static void GetQuipSheetDataImpl_WhenFileDoesntExist_ThrowsException() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'DoesntExist';
        request.Address1 = 'A1';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('File with the name "DoesntExist" was not found', response.ErrorMessage);
        System.assert(String.isBlank(response.Value1));
    }

    @isTest
    public static void GetQuipSheetDataImpl_WhenFileDoesntContainSheets_ThrowsException() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'NoSheet';
        request.Address1 = 'A1';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('File "NoSheet" doesn\'t contain child sheets', response.ErrorMessage);
        System.assert(String.isBlank(response.Value1));
    }

    @isTest
    public static void GetQuipSheetDataImpl_WhenFileDoesntContainSheetWithSpecificName_ThrowsException() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'NoNamedSheet';
        request.SheetName = 'Test';
        request.Address1 = 'A1';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('File "NoNamedSheet" doesn\'t contain sheet "Test"', response.ErrorMessage);
        System.assert(String.isBlank(response.Value1));
    }

    @isTest
    public static void GetQuipSheetData_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'test';
        List<GetQuipSheetData.Request> requests = new List<GetQuipSheetData.Request> { request };
        List<GetQuipSheetData.Response> responses = GetQuipSheetData.GetQuipSheetData(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
    }
}
