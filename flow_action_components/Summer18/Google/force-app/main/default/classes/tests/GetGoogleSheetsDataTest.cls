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
            if (stubbedMethodName == 'FindFileIdByName') {
                return listOfArgs[0];
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
                } else if (fileId == 'OutsideOfTheRange') {
                    List<List<String>> result = new List<List<String>>();
                    return result;
                }
            }
            System.debug('Unknown method');
            return null;
        }
    }

    @isTest
    public static void GetGoogleSheetsData_CanFindByAddress() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.GoogleSheetsRequest request = new GetGoogleSheetsData.GoogleSheetsRequest();
        request.SpreadsheetName = 'ByAddress';
        request.Direction1 = 'Address';
        request.Location1 = 'B2';
        List<GetGoogleSheetsData.GoogleSheetsRequest> requests = new List<GetGoogleSheetsData.GoogleSheetsRequest>();
        requests.add(request);
        GetGoogleSheetsData.GoogleSheetsResponse response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, requests)[0];
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value1);
    }

    @isTest
    public static void GetGoogleSheetsData_CanFindByRight() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.GoogleSheetsRequest request = new GetGoogleSheetsData.GoogleSheetsRequest();
        request.SpreadsheetName = 'ByRight';
        request.Direction2 = 'Right';
        request.Location2 = '1';
        List<GetGoogleSheetsData.GoogleSheetsRequest> requests = new List<GetGoogleSheetsData.GoogleSheetsRequest>();
        requests.add(request);
        GetGoogleSheetsData.GoogleSheetsResponse response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, requests)[0];
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value2);
    }

    @isTest
    public static void GetGoogleSheetsData_CanFindByBelow() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.GoogleSheetsRequest request = new GetGoogleSheetsData.GoogleSheetsRequest();
        request.SpreadsheetName = 'ByBelow';
        request.Direction3 = 'Below';
        request.Location3 = '1';
        List<GetGoogleSheetsData.GoogleSheetsRequest> requests = new List<GetGoogleSheetsData.GoogleSheetsRequest>();
        requests.add(request);
        GetGoogleSheetsData.GoogleSheetsResponse response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, requests)[0];
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value3);
    }
    
    @isTest
    public static void GetGoogleSheetsData_OutsideOfTheRange_ReturnsEmptyString() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.GoogleSheetsRequest request = new GetGoogleSheetsData.GoogleSheetsRequest();
        request.SpreadsheetName = 'OutsideOfTheRange';
        request.Direction4 = 'Address';
        request.Location4 = 'A100';
        List<GetGoogleSheetsData.GoogleSheetsRequest> requests = new List<GetGoogleSheetsData.GoogleSheetsRequest>();
        requests.add(request);
        GetGoogleSheetsData.GoogleSheetsResponse response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, requests)[0];
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assert(String.isBlank(response.Value4));
    }    
    
    @isTest
    public static void GetGoogleSheetsData_InvalidAddress_ThrowsException() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.GoogleSheetsRequest request = new GetGoogleSheetsData.GoogleSheetsRequest();
        request.SpreadsheetName = 'InvalidAddress';
        request.Direction5 = 'Address';
        request.Location5 = 'Invalid';
        List<GetGoogleSheetsData.GoogleSheetsRequest> requests = new List<GetGoogleSheetsData.GoogleSheetsRequest>();
        requests.add(request);
        GetGoogleSheetsData.GoogleSheetsResponse response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, requests)[0];
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('Address "Invalid" doesn\'t contain row part', response.ErrorMessage);
        System.assert(String.isBlank(response.Value5));
    }
}
