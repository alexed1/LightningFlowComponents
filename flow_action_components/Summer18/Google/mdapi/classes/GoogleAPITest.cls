@isTest
public class GoogleAPITest {

    class HttpResponseMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String endpoint = req.getEndpoint();
            System.debug('Test call for: ' + endpoint);
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);       
            if (endpoint.contains('files?q=name')) {
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
            }
            else if (endpoint.contains('spreadsheets') && endpoint.contains('values:batchUpdate')) {
                res.setBody(JSON.serialize(new ErrorResponse()));
            }
            else if (endpoint.contains('copy?fields')) {
                res.setBody('{ "id": "test copy", "webViewLink": "test link" }');
            } else {
                System.debug('Unknown endpoint: ' + endpoint);
            }

            return res;
        }
    }

    @isTest
    public static void DriveFilesList_ParsedData() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        DriveFileListResponse response = api.DriveFilesList('Name');
        System.assertEquals('id', response.files[0].id);
    }

    @isTest
    public static void SheetsSpreadsheetsGet_ParsedData() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        SheetsSheetResponse response = api.SheetsSpreadsheetsGet('Id');
        System.assertEquals('test', response.sheets[0].data[0].rowData[1].values[1].formattedValue);
    }

    @isTest
    public static void SheetsValuesBatchUpdate_ParsedData() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        ErrorResponse response = api.SheetsValuesBatchUpdate('Id', new SheetsValuesBatchUpdateRequest());
        System.assertEquals(null, response.error, 'Error must be empty');
    }

    @isTest
    public static void CopyFile_FailsOnEmptyId() {
        try {
            new GoogleApi().CopyFile(null, 'test');
            System.assert(false, 'Must fail');
        }
        catch (GoogleException ex) {
            System.assertEquals('Id can\'t be empty or contain only whitespaces', ex.getMessage());
        }
    }

    @isTest
    public static void CopyFile_FailsOnEmptyName() {
        try {
            new GoogleApi().CopyFile('test', null);
            System.assert(false, 'Must fail');
        }
        catch (GoogleException ex) {
            System.assertEquals('New name can\'t be empty or contain only whitespaces', ex.getMessage());
        }
    }   

    @isTest
    public static void CopyFile_ReturnsDataOnCopiedFile() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleAPI api = new GoogleAPI();
        DriveFilesCopyResponse response = api.CopyFile('test id', 'test name');
        System.assertEquals('test copy', response.id);
        System.assertEquals('test link', response.webViewLink);
        System.assertEquals(null, response.error, 'Error must be empty');
    }
}
