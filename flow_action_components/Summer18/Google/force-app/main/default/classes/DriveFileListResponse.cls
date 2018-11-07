public class DriveFileListResponse extends DriveErrorResponse {

    public string kind;

    public boolean incompleteSearch;

    public List<DriveFile> files;

    public string nextPageToken;

    public DriveFileListResponse() {
        files = new List<DriveFile>();
    }
}