public interface IGoogleAPI {

    DriveFileListResponse driveFilesList(String name, String mimeType, String parentId);

    SheetsSheetResponse sheetsSpreadsheetsGet(String id);

    ErrorResponse sheetsValuesBatchUpdate(String id, SheetsValuesBatchUpdateRequest request);

    DriveFilesCopyResponse copyFile(String id, String newName);

    FileResponse createFile(String name, String mimeType, String parentId);

    FileResponse renameFile(String id, String newName);

    ErrorResponse deleteFile(String id);

    PermissionResponse createPermission(String fileId, String email, Boolean readonly);

    PermissionListResponse getPermissions(String fileId);

    ErrorResponse deletePermission(String fileId, String permissionId);
}