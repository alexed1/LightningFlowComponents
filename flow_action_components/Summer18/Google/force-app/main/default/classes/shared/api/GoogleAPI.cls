public class GoogleAPI implements IGoogleAPI {

    public static final String GOOGLE_DRIVE_CREDENTIALS = 'google_drive';

    public static final String GOOGLE_SHEETS_CREDENTIALS = 'google_sheets';
    
    private static final Integer ID_LENGTH = 44;

    public GoogleAPI() { }
    //Google file Id is a string 44 symbols long, no whitespaces
    //This method is used for some shortcuts so it doesn't necessary mean a real existing file Id
    public Boolean likeId(String id) {
        if (String.isBlank(id)) {
            return false;
        }
        if (id.length() != ID_LENGTH) {
            return false;
        }
        if (id.contains(' ')) {
            return false;
        }
        return true;
    }

    public DriveFileListResponse driveFilesList(String name) {
        if (String.isBlank(name)) {
            throw new GoogleException('Name can\'t be empty or blank');
        }
        System.debug('Searching Google file with name = "' + name + '"');        
        HttpRequest req = new HttpRequest();
        String url = 'callout:' + GOOGLE_DRIVE_CREDENTIALS + '/files?q=name=\'' + EncodingUtil.urlEncode(name, 'UTF-8') + '\'';
        System.debug('Google Drive URL: ' + url);
        req.setEndpoint(url);
        req.setMethod('GET');
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
        HttpRequest req = new HttpRequest();
        String url = 'callout:' + GOOGLE_SHEETS_CREDENTIALS + '/spreadsheets/' + EncodingUtil.urlEncode(id, 'UTF-8') + '?includeGridData=true';
        System.debug('Google Sheets URL: ' + url);
        req.setEndpoint(url);
        req.setMethod('GET');
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
        HttpRequest req = new HttpRequest();
        String url = 'callout:' + GOOGLE_SHEETS_CREDENTIALS + '/spreadsheets/'  + EncodingUtil.urlEncode(id, 'UTF-8') + '/values:batchUpdate';
        System.debug('Google Sheets URL: ' + url);
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json, text/json');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(request));
        
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
        
        HttpRequest req = new HttpRequest();
        String url = 'callout:' + GOOGLE_DRIVE_CREDENTIALS + '/files/'  + EncodingUtil.urlEncode(id, 'UTF-8') + '/copy'
            + '?fields=appProperties%2Cdescription%2CfileExtension%2Cid%2CmimeType%2Cname%2CwebContentLink%2CwebViewLink';
        System.debug('Google Drive URL: ' + url);
        Map<String, String> body = new Map<String, String>();
        body.put('name', newName);
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json, text/json');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(body));
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        System.debug('Response status code: ' + String.valueOf(statusCode));
        return DriveFilesCopyResponse.parse(res.getBody());
    }
}