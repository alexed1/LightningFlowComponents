public interface IGoogleAPI {

    Boolean LikeId(String id);

    DriveFileListResponse DriveFilesList(String name);

    SheetsSheetResponse SheetsSpreadsheetsGet(String id);

    ErrorResponse SheetsValuesBatchUpdate(String id, SheetsValuesBatchUpdateRequest request);

    DriveFilesCopyResponse CopyFile(String id, String newName);
}
