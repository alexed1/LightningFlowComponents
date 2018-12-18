public class GoogleAPI implements IGoogleAPI {

    public static final String GOOGLE_DRIVE_CREDENTIALS = 'google_drive';

    public static final String GOOGLE_SHEETS_CREDENTIALS = 'google_sheets';

    public GoogleAPI() { }

    public DriveFileListResponse driveFilesList(String name, String mimeType, String parentId) {
        if (String.isBlank(name)) {
            throw new GoogleException('Name can\'t be empty or blank');
        }
        System.debug('Searching Google file with name = "' + name + '"');        
        
        String query = 'name=\'' + name + '\'';
        if (!String.isBlank(mimeType)) {
            query = query + ' and mimeType=\'' + mimeType + '\'';
        }
        if (!String.isBlank(parentId)) {
            query = query + ' and \'' + parentId + '\' in parents';
        }
        String url = 'callout:' + GOOGLE_DRIVE_CREDENTIALS + '/files?q=' + EncodingUtil.urlEncode(query, 'UTF-8') + '&fields=files(id%2Cname%2Cparents%2CmimeType%2CwebViewLink%2Ctrashed)';
        System.debug('Google Drive URL: ' + url);
        HttpRequest req = newRequest(url);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return DriveFileListResponse.parse(res.getBody());
    }

    public SheetsSheetResponse sheetsSpreadsheetsGet(String id) {
        if (String.isBlank(id)) {
            throw new GoogleException('Spreadsheet Id can\'t be empty or contain only whitespaces');
        }
        System.debug('Retrieving Google Sheets file with id = "' + id + '"');
        String url = 'callout:' + GOOGLE_SHEETS_CREDENTIALS + '/spreadsheets/' + EncodingUtil.urlEncode(id, 'UTF-8') + '?includeGridData=true';
        System.debug('Google Sheets URL: ' + url);
        HttpRequest req = newRequest(url);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return SheetsSheetResponse.parse(res.getBody());
    }

    public ErrorResponse sheetsValuesBatchUpdate(String id, SheetsValuesBatchUpdateRequest request) {
        if (String.isBlank(id)) {
            throw new GoogleException('Spreadsheet Id can\'t be empty or contain only whitespaces');
        }
        String url = 'callout:' + GOOGLE_SHEETS_CREDENTIALS + '/spreadsheets/'  + EncodingUtil.urlEncode(id, 'UTF-8') + '/values:batchUpdate';
        System.debug('Google Sheets URL: ' + url);
        HttpRequest req = newRequest(url, 'POST', request);        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return ErrorResponse.parse(res.getBody());
    }

    public DriveFilesCopyResponse copyFile(String id, String newName) {
        if (String.isBlank(id)) {
            throw new GoogleException('Id can\'t be empty or contain only whitespaces');
        }
        if (String.isBlank(newName)) {
            throw new GoogleException('New name can\'t be empty or contain only whitespaces');
        }
        String url = 'callout:' + GOOGLE_DRIVE_CREDENTIALS + '/files/'  + EncodingUtil.urlEncode(id, 'UTF-8') + '/copy'
            + '?fields=appProperties%2Cdescription%2CfileExtension%2Cid%2CmimeType%2Cname%2CwebContentLink%2CwebViewLink%2Ctrashed';
        System.debug('Google Drive URL: ' + url);
        Map<String, String> body = new Map<String, String>();
        body.put('name', newName);        
        HttpRequest req = newRequest(url, 'POST', body);        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return DriveFilesCopyResponse.parse(res.getBody());
    }

    public FileResponse createFile(String name, String mimeType, String parentId) {
        System.debug('Creating Google file with name "' + name + '", MIME type "' + mimeType + '" and parent Id "' + parentId + '"');
        String url = 'callout:' + GOOGLE_DRIVE_CREDENTIALS + '/files?fields=id%2CwebViewLink%2Cname%2CmimeType%2Ctrashed';
        System.debug('Google Drive URL: ' + url);
        Map<String, Object> body = new Map<String, Object>();
        body.put('name', name);
        body.put('mimeType', mimeType);
        if (!String.isBlank(parentId)) {
            body.put('parents', new List<String> { parentId });
        }
        Http http = new Http();
        HttpRequest req = newRequest(url, 'POST', body);
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return FileResponse.parse(res.getBody());
    }

    public FileResponse renameFile(String id, String newName) {
        System.debug('Renaming Google file with id "' + id + '". New name will be "' + newName + '"');
        String url = 'callout:' + GOOGLE_DRIVE_CREDENTIALS + '/files/' + id;
        System.debug('Google Drive URL: ' + url);
        Map<String, Object> body = new Map<String, Object>();
        body.put('name', newName);
        Http http = new Http();
        HttpRequest req = newRequest(url, 'PATCH', body);
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return FileResponse.parse(res.getBody());
    }

    public ErrorResponse deleteFile(String id) {
        System.debug('Deleting Google file with id "' + id + '"');
        String url = 'callout:' + GOOGLE_DRIVE_CREDENTIALS + '/files/' + id;
        System.debug('Google Drive URL: ' + url);
        Http http = new Http();
        HttpRequest req = newRequest(url, 'DELETE', null);
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        String responseBody = res.getBody();
        return String.isBlank(responseBody) ? new ErrorResponse() : ErrorResponse.parse(res.getBody());
    }

    public PermissionResponse createPermission(String fileId, String email, Boolean readonly) {
        System.debug('Adding permission for file Id ' + fileId + ' and user email ' + email);
        String url = 'callout:' + GOOGLE_DRIVE_CREDENTIALS + '/files/' + fileId + '/permissions';
        System.debug('Google Drive URL: ' + url);
        Map<String, Object> body = new Map<String, Object>();
        body.put('role', readonly ? 'reader': 'writer');
        body.put('type', 'user');
        body.put('emailAddress', email);
        Http http = new Http();
        HttpRequest req = newRequest(url, 'POST', body);
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        String responseBody = res.getBody();
        return PermissionResponse.parse(res.getBody());
    }

    public PermissionListResponse getPermissions(String fileId) {
        System.debug('Retrieving all permissions for file with id "' + fileId + '"');
        String url = 'callout:' + GOOGLE_DRIVE_CREDENTIALS + '/files/' + fileId + '/permissions?fields=nextPageToken%2Cpermissions(emailAddress%2Cid)';
        System.debug('Google Drive URL: ' + url);
        Http http = new Http();
        HttpRequest req = newRequest(url);
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        String responseBody = res.getBody();
        return PermissionListResponse.parse(res.getBody());
    }

    public ErrorResponse deletePermission(String fileId, String permissionId) {
        System.debug('Deleting Google file with id "' + fileId + '"');
        String url = 'callout:' + GOOGLE_DRIVE_CREDENTIALS + '/files/' + fileId + '/permissions/' + permissionId;
        System.debug('Google Drive URL: ' + url);
        Http http = new Http();
        HttpRequest req = newRequest(url, 'DELETE', null);
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        String responseBody = res.getBody();
        return String.isBlank(responseBody) ? new ErrorResponse() : ErrorResponse.parse(res.getBody());
    }

    private HttpRequest newRequest(String url) {
        return newRequest(url, 'GET', null);
    }

    private HttpRequest newRequest(String url, String method, Object body) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        if (method == 'PATCH') {
            req.setMethod('POST');
            req.setHeader('X-HTTP-Method-Override','PATCH');
        } else {
            req.setMethod(method);
        }
        req.setHeader('Accept', 'application/json, text/json');
        req.setHeader('Content-Type', 'application/json');
        if (body != null) {
            req.setBody(JSON.serialize(body));
        }
        req.setTimeout(20 * 1000);
        return req;
    }
}