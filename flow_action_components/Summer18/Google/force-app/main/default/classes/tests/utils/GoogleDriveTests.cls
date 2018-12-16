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
                    response.files = new List<FileResponse>();
                    response.files.Add(new FileResponse());
                    response.files[0].id = 'test';
                    response.files[0].trashed = false;
                    return response;
                }
                if (fileName == 'DoesntExist') {
                    DriveFileListResponse response = new DriveFileListResponse();
                    response.files = new List<FileResponse>();
                    return response;
                }
                if (fileName == 'Exception') {
                    DriveFileListResponse response = new DriveFileListResponse();
                    response.error = new ErrorResponse.Errors();
                    response.error.message = 'Exception';
                    return response;
                }
                if (fileName == 'One') {
                    DriveFileListResponse response = new DriveFileListResponse(); 
                    response.files = new List<FileResponse>();
                    response.files.Add(new FileResponse());
                    response.files[0].id = 'One';
                    response.files[0].trashed = false;
                    return response;
                }
                if (fileName == 'Two') {
                    DriveFileListResponse response = new DriveFileListResponse(); 
                    response.files = new List<FileResponse>();
                    response.files.Add(new FileResponse());
                    response.files[0].id = 'Two';
                    response.files[0].trashed = false;
                    return response;
                }
                if (fileName == 'Three') {
                    DriveFileListResponse response = new DriveFileListResponse(); 
                    response.files = new List<FileResponse>();
                    return response;
                }
                if (fileName == 'File') {
                    DriveFileListResponse response = new DriveFileListResponse(); 
                    response.files = new List<FileResponse>();response.files = new List<FileResponse>();
                    response.files.Add(new FileResponse());
                    response.files[0].id = 'File';
                    response.files[0].trashed = false;
                    return response;
                }

                System.debug('Unexpected argument: ' + fileName);
                return null;
            }
            if (stubbedMethodName.equalsIgnoreCase('createFile')) {
                String fileName = listOfArgs[0].toString();
                if (fileName == 'Three') {
                    FileResponse response = new FileResponse();
                    response.id = 'Three';
                    return response;
                }
                if (fileName == 'Two') {
                    FileResponse response = new FileResponse();
                    response.id = 'Two';
                    return response;
                }
            }
            if (stubbedMethodName.equalsIgnoreCase('renameFile')) {
                String fileName = listOfArgs[0].toString();
                if (fileName == 'Two') {
                    FileResponse response = new FileResponse();
                    response.id = 'Two';
                    return response;
                }
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
    public static void findFileIdByName_WhenFileExists_RetrievesFileId() {
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        String id = drive.findFileIdByName('Exists');
        System.assertEquals('test', id);
    }

    @isTest
    public static void findFileIdByName_WhenFileDoesntExist_ReturnsNull() {
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        String id = drive.findFileIdByName('DoesntExist');
        System.assert(String.isBlank(id));
    }

    @isTest
    public static void findFileIdByName_WhenGoogleReturnsError_ThrowsException() {
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
    public static void getSpreadsheetData_ReturnsData() {
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
    public static void getSpreadsheetData_WhenGoogleReturnsError_ThrowsException() {
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
    public static void saveSpreadsheetData_SavesData() {
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        drive.saveSpreadsheetData('Anything', null, new List<CellValue> { new CellValue(Address.parse('A1'), 'test') });
    }

    @isTest
    public static void getFolder_retrievesFolder() {
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        File folder = drive.getFolder('One/Two/Three', true);
        System.assertEquals('Three', folder.id);
    }

    @isTest
    public static void createSpreasheet_createsFile() {
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        File file = drive.createSpreadsheet('One/Two');
        System.assertEquals('Two', file.id); 
    }

    @isTest
    public static void renameSpreadsheet_renamesFile() {        
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        drive.renameFile(new File('Two', null, null, null), 'NewName');
    }

    @isTest
    public static void getFile_returnsFile() {        
        IGoogleAPI api = (IGoogleAPI)Test.createStub(IGoogleAPI.class, new GoogleAPIMock());
        GoogleDrive drive = new GoogleDrive(api);
        File file = drive.getFile('One/Two/File', 'type');
        System.assertEquals('File', file.id);
    }
}
