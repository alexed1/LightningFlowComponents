public interface IGoogleAPI {

    DriveFileListResponse DriveFilesList(String name);

    SheetsSheetResponse SheetsSpreadsheetsGet(String id);
}
