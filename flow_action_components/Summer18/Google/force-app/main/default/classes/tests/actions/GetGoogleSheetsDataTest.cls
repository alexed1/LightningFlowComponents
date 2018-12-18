@isTest
public class GetGoogleSheetsDataTest {

    class GoogleDriveMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            //Pretend that file Id equals file name requested
            if (stubbedMethodName == 'getFile') {
                String fileId = listOfArgs[0].toString();
                if (fileId == 'DoesntExist') {
                    return null;
                }
                return new File(fileId);
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
                    result.add(row);
                    row = new List<String>();
                    row.add('1');
                    row.add('test');
                    result.add(row);
                    return result;
                } else if (fileId == 'ByBelow') {
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    result.add(row);
                    row = new List<String>();
                    row.add('1');
                    result.add(row);
                    row = new List<String>();
                    row.add('test');
                    result.add(row);
                    return result;
                } else if (fileId == 'ByRightAndBelow') {
                    List<List<String>> result = new List<List<String>> {
                        new List<String> { '', 'test', '' },
                        new List<String> { '1', 'test1', '' }
                    };
                    return result;
                }                
                 else if (fileId == 'OutsideOfTheRange') {
                    List<List<String>> result = new List<List<String>>();
                    return result;
                }
                return null;
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void GetGoogleSheetsDataImpl_CanFindByAddress() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.SpreadsheetName = 'ByAddress';
        request.Address1 = 'B2';
        GetGoogleSheetsData.Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value1);
    }

    @isTest
    public static void GetGoogleSheetsDataImpl_CanFindByRight() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.SpreadsheetName = 'ByRight';
        request.Right2 = '1';
        GetGoogleSheetsData.Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value2);
    }

    @isTest
    public static void GetGoogleSheetsDataImpl_CanFindByBelow() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.SpreadsheetName = 'ByBelow';
        request.Below3 = '1';
        GetGoogleSheetsData.Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value3);
    }

    @isTest
    public static void GetGoogleSheetsDataImpl_CanFindByRightAndBelow() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.SpreadsheetName = 'ByRightAndBelow';
        request.Below1 = 'test';
        request.Right1 = '1';
        GetGoogleSheetsData.Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test1', response.Value1);
    }
    
    @isTest
    public static void GetGoogleSheetsDataImpl_OutsideOfTheRange_ReturnsEmptyString() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.SpreadsheetName = 'OutsideOfTheRange';
        request.Address4 = 'A100';
        GetGoogleSheetsData.Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assert(String.isBlank(response.Value4));
    }    
    
    @isTest
    public static void GetGoogleSheetsDataImpl_InvalidAddress_ThrowsException() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.SpreadsheetName = 'InvalidAddress';
        request.Address5 = 'Invalid';
        GetGoogleSheetsData.Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('Address "Invalid" doesn\'t contain row part', response.ErrorMessage);
        System.assert(String.isBlank(response.Value5));
    } 
    
    @isTest
    public static void GetGoogleSheetsDataImpl_WhenFileDoesntExist_ThrowsException() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.SpreadsheetName = 'DoesntExist';
        GetGoogleSheetsData.Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
        System.assert(!response.IsSuccess);
        System.assertEquals('Google Sheet with the name "DoesntExist" doesn\'t exist' , response.ErrorMessage);
    }

    @isTest
    public static void GetGoogleSheetsData_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.SpreadsheetName = 'test';
        List<GetGoogleSheetsData.Request> requests = new List<GetGoogleSheetsData.Request> { request };
        List<GetGoogleSheetsData.Response> responses = GetGoogleSheetsData.GetGoogleSheetsData(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}
