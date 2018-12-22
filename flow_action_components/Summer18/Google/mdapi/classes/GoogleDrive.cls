public class GoogleDrive implements IGoogleDrive {

    private IGoogleAPI googleApi;

    public GoogleDrive(IGoogleAPI googleApi) {
        if (googleApi == null) {
            throw new GoogleException('googleApi parameter is null');
        }
        this.googleApi = googleApi;
    }

    public String findFileIdByName(String name) {
        return findFileIdByName(name, null);
    }

    public String findFileIdByName(String name, String fileType) {
        DriveFileListResponse response = googleApi.driveFilesList(name);
        response.ThrowOnError();
        if (response.files.size() == 0) {
            return null;
        }
        for (DriveFileListResponse.File file: response.files) {            
            if (String.isBlank(fileType) || file.mimeType.equalsIgnoreCase(fileType)) {
                return file.id;
            }
        }
        return null;
    }

    public List<List<String>> getSpreadsheetData(String id, String sheetTitle) {
        SheetsSheetResponse response = googleApi.sheetsSpreadsheetsGet(id);
        response.throwOnError();
        SheetsSheetResponse.Data targetSheet = null;
        for (SheetsSheetResponse.Sheet sheet : response.sheets) {
            if (String.isBlank(sheetTitle) || sheet.properties.title == sheetTitle) {
                targetSheet = sheet.data[0];
            }
        }
        if (targetSheet == null) {
            throw new GoogleException('Target spreadsheet doesn\'t have a sheet "' + sheetTitle + '"');
        }
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
        for (SheetsSheetResponse.RowData row : targetSheet.rowData) {
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

    public void saveSpreadsheetData(String id, String sheetTitle, List<CellValue> values) {        
        SheetsValuesBatchUpdateRequest body = new SheetsValuesBatchUpdateRequest();
        if (values != null) {
            for (CellValue cellValue : values) {
                SheetsValuesBatchUpdateRequest.Data data = new SheetsValuesBatchUpdateRequest.Data(
                    String.isBlank(sheetTitle)
                        ? cellValue.addr.toString()
                        : sheetTitle + '!' + cellValue.addr.toString());
                data.values[0].add(cellValue.value);
                body.data.add(data);
            }
        }
        ErrorResponse response = googleApi.SheetsValuesBatchUpdate(id, body);
        response.ThrowOnError();
    }

    public ClonedFile cloneFile(String idOrName, String newName) {
        if (String.isBlank(idOrName)) {
            throw new GoogleException('Id or Name can\'t be blank');
        }
        if (String.isBlank(newName)) {
            throw new GoogleException('New name can\'t be blank');
        }
        DriveFilesCopyResponse response = null;
        //If the value seems to be Id, we try to clone the file with this Id
        if (googleApi.LikeId(idOrName)) {
            response = googleApi.copyFile(idOrName, newName);
        }
        //If it is not Id for sure (e.g. contains spaces) or we didn't find a file with this Id, we try to treat it as file name
        if (response == null || (response.error != null && response.error.code == 404)) {
            String id = findFileIdByName(idOrName);
            if (String.isBlank(id)) {
                throw new GoogleException('File "' + idOrName + '" doesn\'t exist');
            }
            response = googleApi.copyFile(id, newName);
        }
        response.ThrowOnError();
        return new ClonedFile(response.id, response.webViewLink);
    }
}