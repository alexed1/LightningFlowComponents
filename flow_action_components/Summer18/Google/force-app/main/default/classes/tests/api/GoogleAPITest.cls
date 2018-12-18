@isTest
public class GoogleAPITest {

    class HttpResponseMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String endpoint = req.getEndpoint();
            System.debug('Test call for: ' + endpoint);
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);       
            if (endpoint.contains('files?q=name') && req.getMethod() == 'GET') {
                res.setBody(
                    '{'+
                    ' "kind": "drive#fileList",'+
                    ' "incompleteSearch": false,'+
                    ' "files": ['+
                    '  {'+
                    ''+
                    ''+
                    '   "kind": "drive#file",'+
                    '   "id": "id",'+
                    '   "name": "name",'+
                    '   "mimeType": "application/vnd.google-apps.spreadsheet"'+
                    '  }'+
                    ' ]'+
                    '}');
            }
            else if (endpoint.contains('files?fields=') && req.getMethod() == 'POST') {
                res.setBody('{ "id" : "test", "name" : "test name", "mimeType" : "type", "webViewLink": "link", "parents" : [ "parent" ], "trashed": false }');
            }
            else if (endpoint.contains('spreadsheets') && endpoint.contains('?includeGridData=true')) {
                res.setBody(
                    '{'+
                    ' "spreadsheetId": "1A7Td7yl6wbxGhlsjouwO-N3sRyTDq-M5p579awuYTQo",'+
                    ' "sheets": ['+
                    '  {'+
                    '   "data": ['+
                    '    {'+
                    '     "rowData": ['+
                    '      {'+
                    '      },'+
                    '      {'+
                    '       "values": ['+
                    '        {'+
                    '        },'+
                    '        {'+
                    '         "userEnteredValue": {'+
                    '          "numberValue": 43383'+
                    '         },'+
                    '         "effectiveValue": {'+
                    '          "numberValue": 43383'+
                    '         },'+
                    '         "formattedValue": "test"'+
                    '        }'+
                    '       ]'+
                    '      }'+
                    '     ]'+
                    '    }'+
                    '   ]'+
                    '  }'+
                    ' ]'+
                    '}'
                );
            } else if (endpoint.contains('spreadsheets') && endpoint.contains('values:batchUpdate')) {
                res.setBody(JSON.serialize(new ErrorResponse()));
            } else if (endpoint.contains('copy?fields')) {
                res.setBody('{ "id": "test copy", "webViewLink": "test link" }');
            } else if (endpoint.endsWith('files/rename')) {
                res.setBody('{ "id": "rename", "webViewLink": "test link" }');
            } else if (endpoint.endsWith('files/delete')) {
                res.setBody('{}');
            } else if (endpoint.endsWith('files/permission/permissions')) {
                res.setBody('{}');
            } else if (endpoint.contains('files/getperm/permissions')) {
                res.setBody('{ "permissions" : [ { "id": "id", "emailAddress": "email" }]}');
            } else if (endpoint.endsWith('files/delperm/permissions/id')) {
                res.setBody('{}');
            }
            else {
                System.debug('Unknown endpoint: ' + endpoint);
            }
            return res;
        }
    }

    @isTest
    public static void driveFilesList_ParsedData() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        DriveFileListResponse response = api.driveFilesList('Name', null, null);
        System.assertEquals('id', response.files[0].id);
    }

    @isTest
    public static void sheetsSpreadsheetsGet_ParsedData() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        SheetsSheetResponse response = api.SheetsSpreadsheetsGet('Id');
        System.assertEquals('test', response.sheets[0].data[0].rowData[1].values[1].formattedValue);
    }

    @isTest
    public static void sheetsValuesBatchUpdate_ParsedData() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        ErrorResponse response = api.SheetsValuesBatchUpdate('Id', new SheetsValuesBatchUpdateRequest());
        System.assertEquals(null, response.error, 'Error must be empty');
    }

    @isTest
    public static void copyFile_FailsOnEmptyId() {
        try {
            new GoogleApi().CopyFile(null, 'test');
            System.assert(false, 'Must fail');
        }
        catch (GoogleException ex) {
            System.assertEquals('Id can\'t be empty or contain only whitespaces', ex.getMessage());
        }
    }

    @isTest
    public static void copyFile_FailsOnEmptyName() {
        try {
            new GoogleApi().CopyFile('test', null);
            System.assert(false, 'Must fail');
        }
        catch (GoogleException ex) {
            System.assertEquals('New name can\'t be empty or contain only whitespaces', ex.getMessage());
        }
    }   

    @isTest
    public static void copyFile_ReturnsDataOnCopiedFile() { 
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        DriveFilesCopyResponse response = api.CopyFile('test id', 'test name');
        System.assertEquals('test copy', response.id);
        System.assertEquals('test link', response.webViewLink);
        System.assertEquals(null, response.error, 'Error must be empty');
    }

    @isTest
    public static void createFile_createsFile() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        FileResponse response = api.createFile('test name', 'type', 'parent');
        System.assertEquals('test', response.id);
        System.assertEquals('type', response.mimeType);
        System.assertEquals('link', response.webViewLink);
        System.assertEquals(1, response.parents.size());
        System.assertEquals(null, response.error, 'Error must be empty');
    }

    @isTest
    public static void renameFile_renamesFile() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        FileResponse response = api.renameFile('rename', 'rename');
        System.assertEquals('rename', response.id);
        System.assertEquals(null, response.error, 'Error must be empty');
    }

    @isTest
    public static void deleteFile_deletesFile() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        ErrorResponse response = api.deleteFile('delete');
        System.assertEquals(null, response.error, 'Error must be empty');
    }

    @isTest
    public static void createPermission_createsPermission() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        PermissionResponse response = api.createPermission('permission', 'email', true);
        System.assertEquals(null, response.error, 'Error must be empty');
    }

    @isTest
    public static void getPermissions_returnsPermissions() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        PermissionListResponse response = api.getPermissions('getperm');
        System.assertEquals(null, response.error, 'Error must be empty');
        System.assertEquals(1, response.permissions.size());
    }

    @isTest
    public static void deletePermission_deletesPermission() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        ErrorResponse response = api.deletePermission('delperm', 'id');
        System.assertEquals(null, response.error, 'Error must be empty');

    }
}
