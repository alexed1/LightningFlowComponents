public interface IGoogleAPI {

    Boolean likeId(String id);

    DriveFileListResponse driveFilesList(String name, String mimeType, String parentId);

    SheetsSheetResponse sheetsSpreadsheetsGet(String id);

    ErrorResponse sheetsValuesBatchUpdate(String id, SheetsValuesBatchUpdateRequest request);

    DriveFilesCopyResponse copyFile(String id, String newName);

    FileResponse createFile(String name, String mimeType, String parentId);

    FileResponse renameFile(String id, String newName);
}
