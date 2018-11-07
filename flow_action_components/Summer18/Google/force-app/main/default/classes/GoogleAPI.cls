public class GoogleAPI {

    public static final String GOOGLE_DRIVE_CREDENTIALS = 'google_drive';

    public static final String GOOGLE_SHEETS_CREDENTIALS = 'google_sheets';

    public GoogleAPI() { }

    public static DriveFileListResponse DriveFilesList(String name) {
        if (String.isBlank(name)) {
            throw new GoogleException('List all files is not supported. You must provide name to search for');
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
        return (DriveFileListResponse)JSON.deserialize(res.getBody(), DriveFileListResponse.class);
    }
}
 
