public with sharing class DriveFile {
    
    public static final string GOOGLE_SHEETS_MIME_TYPE = 'application/vnd.google-apps.spreadsheet';

    public string kind;

    public string id;

    public string name;

    public string mimeType;

    public boolean isGoogleSheetsFile() {
        return mimeType == GOOGLE_SHEETS_MIME_TYPE;
    }
}