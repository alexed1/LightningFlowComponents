@isTest
public class GoogleDriveTests {
    
    class GoogleAPIMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (stubbedMethodName.equalsIgnoreCase('driveFilesList')) {
                String fileName = listOfArgs[0].toString();
                if (fileName == 'Exists') {
                    DriveFileListResponse response = new DriveFileListResponse();
                    response.files = new List<DriveFileListResponse.File>();
                    response.files.Add(new DriveFileListResponse.File());
                    response.files[0].id = 'test';
                    return response;
                }
                if (fileName == 'DoesntExist') {
                    DriveFileListResponse response = new DriveFileListResponse();
                    response.files = new List<DriveFileListResponse.File>();
                    return response;
                }
                if (fileName == 'Exception') {
                    DriveFileListResponse response = new DriveFileListResponse();
                    response.error = new ErrorResponse.Errors();
                    response.error.message = 'Exception';
                    return response;
                }
                System.debug('Unexpected argument: ' + fileName);
                return null;
            }
            if (stubbedMethodName.equalsIgnoreCase('sheetsSpreadsheetsGet')) {
                String fileId = listOfArgs[0].toString();
                if (fileId == 'Exists') {
                    SheetsSheetResponse response = new SheetsSheetResponse();
                    response.sheets = new List<SheetsSheetResponse.Sheet>();
                    response.sheets.add(new SheetsSheetResponse.Sheet());
                    response.sheets[0].data = new List<SheetsSheetResponse.Data>();
                    response.sheets[0].data.add(new SheetsSheetResponse.Data());
                    response.sheets[0].data[0].rowData = new List<SheetsSheetResponse.RowData>();
                    response.sheets[0].data[0].rowData.add(new SheetsSheetResponse.RowData());
                    response.sheets[0].data[0].rowData.add(new SheetsSheetResponse.RowData());
                    response.sheets[0].data[0].rowData[1].values = new List<SheetsSheetResponse.CellData>();
                    response.sheets[0].data[0].rowData[1].values.add(new SheetsSheetResponse.CellData());
                    response.sheets[0].data[0].rowData[1].values[0].formattedValue = '1-0';
                    response.sheets[0].data[0].rowData.add(new SheetsSheetResponse.RowData());
                    response.sheets[0].data[0].rowData[2].values = new List<SheetsSheetResponse.CellData>();
                    response.sheets[0].data[0].rowData[2].values.add(new SheetsSheetResponse.CellData());
                    response.sheets[0].data[0].rowData[2].values[0].formattedValue = '2-0';
                    response.sheets[0].data[0].rowData[2].values.add(new SheetsSheetResponse.CellData());
                    response.sheets[0].data[0].rowData[2].values[1].formattedValue = '2-1';
                    return response;
                }
                if (fileId == 'Exception') {
                    SheetsSheetResponse response = new SheetsSheetResponse();
                    response.error = new ErrorResponse.Errors();
                    response.error.message = 'Exception';
                    return response;
                }
                System.debug('Unknown file Id: ' + fileId);
            }
            if (stubbedMethodName.equalsIgnoreCase('sheetsValuesBatchUpdate')) {
                String id = listOfArgs[0].toString();
                SheetsValuesBatchUpdateRequest body = (SheetsValuesBatchUpdateRequest)listOfArgs[1];
                SheetsValuesBatchUpdateRequest.Data data = body.data[0];
                System.assertEquals('A1', data.range);
                System.assertEquals('test', data.values[0][0]);
                return new ErrorResponse();
            }
            System.debug('Unknown method: ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void FindFileIdByName_WhenFileExists_RetrievesFileId() {
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        String id = drive.findFileIdByName('Exists');
        System.assertEquals('test', id);
    }

    @isTest
    public static void FindFileIdByName_WhenFileDoesntExist_ReturnsNull() {
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        String id = drive.findFileIdByName('DoesntExist');
        System.assert(String.isBlank(id));
    }

    @isTest
    public static void FindFileIdByName_WhenGoogleReturnsError_ThrowsException() {
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        try {
            String id = drive.findFileIdByName('Exception');
            System.assert(false, 'Exception was not thrown');
        } catch (GoogleException ex) {
            System.assertEquals('Exception', ex.getMessage());
        }
    }

    @isTest
    public static void GetSpreadsheetData_ReturnsData() {
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        List<List<String>> data = drive.getSpreadsheetData('Exists', null);
        System.assertEquals(3, data.size());
        System.assertEquals(0, data[0].size());
        System.assertEquals(1, data[1].size());
        System.assertEquals(2, data[2].size());
        System.assertEquals('1-0', data[1][0]);
        System.assertEquals('2-0', data[2][0]);
        System.assertEquals('2-1', data[2][1]);
    }

    @isTest
    public static void GetSpreadsheetData_WhenGoogleReturnsError_ThrowsException() {
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        try {
            List<List<String>> data = drive.getSpreadsheetData('Exception', null);
            System.assert(false, 'Exception was not thrown');
        } catch (GoogleException ex) {
            System.assertEquals('Exception', ex.getMessage());
        }
    }

    @isTest
    public static void SaveSpreadsheetData_SavesData() {
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        drive.saveSpreadsheetData('Anything', null, new List<CellValue> { new CellValue(Address.parse('A1'), 'test') });
    }
}
