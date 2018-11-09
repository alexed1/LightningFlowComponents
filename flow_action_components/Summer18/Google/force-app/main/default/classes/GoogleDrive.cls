public class GoogleDrive implements IGoogleDrive {

    private IGoogleAPI googleApi;

    public GoogleDrive(IGoogleAPI googleApi) {
        if (googleApi == null) {
            throw new GoogleException('googleApi parameter is null');
        }
        this.googleApi = googleApi;
    }

    public String FindFileIdByName(String name) {
        return FindFileIdByName(name, null);
    }

    public String FindFileIdByName(String name, String fileType) {
        DriveFileListResponse response = googleApi.DriveFilesList(name);
        response.ThrowOnError();
        if (response.files.size() == 0) {
            return null;
        }
        DriveFileListResponse.File file = response.files[0];
        if (String.isBlank(fileType) || file.mimeType.equalsIgnoreCase(fileType)) {
            return file.id;
        }
        return null;
    }

    public List<List<String>> GetSpreadsheetData(String id) {
        SheetsSheetResponse response = googleApi.SheetsSpreadsheetsGet(id);
        response.ThrowOnError();
        SheetsSheetResponse.Data firstSheet = response.sheets[0].data[0];
        Integer maxColumn = 0;
        //The data in the spreadsheet is stored in an uneven two-dimensional array
        //If row doesn't contain a single cell with a data, it will have no values at all
        //If it does contain it, then all previous cells will be empty
        //E.g.
        // []
        // [,,1]
        // []
        // [1]
        // Means that the first line is empty, the second line has only value in the third column, 
        // the third line is empty and the fourth line has the value only in the first cell
        List<List<String>> result = new List<List<String>>();
        for (SheetsSheetResponse.RowData row : firstSheet.rowData) {
            List<String> currentRow = new List<String>();
            result.add(currentRow);
            if (row.values == null) {
                continue;
            }  
            for (SheetsSheetResponse.CellData cell : row.values) {
                currentRow.add(String.isBlank(cell.formattedValue) ? '' : cell.formattedValue);
            }
        }
        return result;        
    }
}
