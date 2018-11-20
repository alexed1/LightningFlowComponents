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
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    result.add(row);
                    row = new List<String>();
                    row.add('');
                    row.add('test');
                    result.add(row);
                    Thread thread = new Thread();
                    ThreadSheet sheet = new ThreadSheet();
                    sheet.data = result;
                    thread.sheets.add(sheet);
                    return thread;
                } else if (threadId == 'ByRight') {
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    result.add(row);
                    row = new List<String>();
                    row.add('1');
                    row.add('test');
                    result.add(row);
                    Thread thread = new Thread();
                    ThreadSheet sheet = new ThreadSheet();
                    sheet.data = result;
                    thread.sheets.add(sheet);
                    return thread;
                } else if (threadId == 'ByBelow') {
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    result.add(row);
                    row = new List<String>();
                    row.add('1');
                    result.add(row);
                    row = new List<String>();
                    row.add('test');
                    result.add(row);
                    Thread thread = new Thread();
                    ThreadSheet sheet = new ThreadSheet();
                    sheet.data = result;
                    thread.sheets.add(sheet);
                    return thread;
                } else if (threadId == 'OutsideOfTheRange' || threadId == 'InvalidAddress') {
                    List<List<String>> result = new List<List<String>>();
                    Thread thread = new Thread();
                    ThreadSheet sheet = new ThreadSheet();
                    sheet.data = result;
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
        request.RelativeDirection1 = 'Address';
        request.TargetLabel1 = 'B2';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value1);
    }

    @isTest
    public static void GetQuipSheetDataImpl_CanFindByRight() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'ByRight';
        request.RelativeDirection2 = 'Right';
        request.TargetLabel2 = '1';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value2);
    }

    @isTest
    public static void GetQuipSheetDataImpl_CanFindByBelow() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'ByBelow';
        request.RelativeDirection3 = 'Below';
        request.TargetLabel3 = '1';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value3);
    }
    
    @isTest
    public static void GetQuipSheetDataImpl_OutsideOfTheRange_ReturnsEmptyString() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'OutsideOfTheRange';
        request.RelativeDirection4 = 'Address';
        request.TargetLabel4 = 'A100';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assert(String.isBlank(response.Value4));
    }    
    
    @isTest
    public static void GetQuipSheetDataImpl_InvalidAddress_ThrowsException() {
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock());
        GetQuipSheetData.Request request = new GetQuipSheetData.Request();
        request.FileName = 'InvalidAddress';
        request.RelativeDirection5 = 'Address';
        request.TargetLabel5 = 'Invalid';
        GetQuipSheetData.Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('Address "Invalid" doesn\'t contain row part', response.ErrorMessage);
        System.assert(String.isBlank(response.Value5));
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
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}
