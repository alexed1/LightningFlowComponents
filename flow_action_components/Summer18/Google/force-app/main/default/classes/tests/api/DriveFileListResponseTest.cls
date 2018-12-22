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

	@isTest
	static void getNonTrashedFiles_returnsNonTrashedFiles() {
		DriveFileListResponse response = new DriveFileListResponse();
		response.files = new List<FileResponse>();
		FileResponse file = new FileResponse();
		file.trashed = True;
		response.files.add(file);
		file = new FileResponse();
		file.trashed = False;
		response.files.add(file);
		List<FileResponse> nonTrashedFiles = response.getNonTrashedFiles();
		System.assertEquals(1, nonTrashedFiles.size());
	}
}
