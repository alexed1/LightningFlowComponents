@isTest
public class DriveFileListResponseTest {
    
    @isTest
	static void testParse() {
		String json=		'{'+
		' "kind": "drive#fileList",'+
		' "incompleteSearch": false,'+
		' "files": ['+
		'  {'+
		''+
		''+
		'   "kind": "drive#file",'+
		'   "id": "1A7Td7yl6wbxGhlsjouwO-N3sRyTDq-M5p579awuYTQo",'+
		'   "name": "Api Test",'+
		'   "mimeType": "application/vnd.google-apps.spreadsheet"'+
		'  }'+
		' ]'+
		'}';
		DriveFileListResponse obj = DriveFileListResponse.parse(json);
		System.assert(obj != null);
	}
}
