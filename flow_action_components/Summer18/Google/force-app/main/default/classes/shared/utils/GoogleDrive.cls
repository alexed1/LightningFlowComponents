public class GoogleDrive implements IGoogleDrive {

    private IGoogleAPI googleApi;

    public GoogleDrive(IGoogleAPI googleApi) {
        if (googleApi == null) {
            throw new GoogleException('googleApi parameter is null');
        }
        this.googleApi = googleApi;
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

    public ClonedFile cloneFile(String filePath, String newName) {
        File file = getFile(filePath, FileMimeTypes.GOOGLE_SHEET);
        if (file == null) {
            throw new GoogleException('Google sheet with the name "' + filePath + '" doesn\'t exist');
        }
        DriveFilesCopyResponse response = googleApi.copyFile(file.id, newName);
        response.ThrowOnError();
        return new ClonedFile(response.id, response.webViewLink);
    }

    public File getFolder(String path, Boolean forceCreate) { 
        List<String> folderNames = path.trim().split('[\\\\\\/]');
        Boolean isPath = folderNames.size() > 1;  
        String parentFolder = isPath ? 'root' : null;
        File result = null;
        for (String folderName : folderNames) {
            if (String.isBlank(folderName)) {
                continue;
            }
            DriveFileListResponse response = googleApi.driveFilesList(folderName, FileMimeTypes.GOOGLE_FOLDER, parentFolder);
            response.throwOnError();
            List<FileResponse> files = response.getNonTrashedFiles();
            if (files.size() > 0) {
                parentFolder = files[0].id;
                result = toFile(files[0]);
                
            } else if (forceCreate) {
                FileResponse fileResponse = googleApi.createFile(folderName, FileMimeTypes.GOOGLE_FOLDER, parentFolder);
                fileResponse.throwOnError();
                parentFolder = fileResponse.id;
                result = toFile(fileResponse);
            } else {
                return null;
            }
        }
        return result;
    }

    public File getFile(String path, String mimeType) {
        List<String> folderNames = path.trim().split('[\\\\\\/]');
        Boolean isPath = folderNames.size() > 1; 
        String parent = null;
        if (isPath) {
            List<String> subFolders = new List<String>();
            for (Integer i = 0; i < folderNames.size() - 1; i++) {
                subFolders.add(folderNames[i]);
            }
            File parentFolder = getFolder(String.join(subFolders,'/'), true);
            parent = parentFolder.id;
        }
        String fileName = folderNames[folderNames.size() - 1];
        DriveFileListResponse fileListResponse = googleApi.driveFilesList(fileName, mimeType, parent);
        fileListResponse.throwOnError();
        for (FileResponse fileResponse : fileListResponse.files) {
            return toFile(fileResponse);
        }
        return null; 
    }

    public void renameFile(File file, String newName) { 
        FileResponse response = googleApi.renameFile(file.id, newName);
        response.throwOnError();
    }

    public void deleteFile(File file) {
        ErrorResponse response = googleApi.deleteFile(file.id);
        response.throwOnError();
    }

    public File createSpreadsheet(String path) {
        List<String> folderNames = path.trim().split('[\\\\\\/]');
        Boolean isPath = folderNames.size() > 1; 
        String parent = null;
        if (isPath) {
            List<String> subFolders = new List<String>();
            for (Integer i = 0; i < folderNames.size() - 1; i++) {
                subFolders.add(folderNames[i]);
            }
            File parentFolder = getFolder(String.join(subFolders,'/'), true);
            parent = parentFolder.id;
        }
        FileResponse result = googleApi.createFile(folderNames[folderNames.size() - 1], FileMimeTypes.GOOGLE_SHEET, parent);
        result.throwOnError(); 
        return toFile(result);
    }

    public void grantAccess(String path, List<String> emails, Boolean readonly) {
        File file = getFile(path, FileMimeTypes.GOOGLE_SHEET);
        if (file == null) {
            throw new GoogleException('Google sheet with the name "' + path + '" doesn\'t exist');
        }
        for (String email : emails) {
            PermissionResponse response = googleApi.createPermission(file.Id, email, readonly);
            response.throwOnError();
        }
    }

    public void revokeAccess(String path, List<String> emails) {
        File file = getFile(path, FileMimeTypes.GOOGLE_SHEET);
        if (file == null) {
            throw new GoogleException('Google sheet with the name "' + path + '" doesn\'t exist');
        }
        PermissionListResponse permissions = googleApi.getPermissions(file.id);
        permissions.throwOnError();
        List<String> permissionsToDelete = new List<String>();
        Set<String> permissionsSet = new Set<String>(emails);
        for (PermissionResponse permission : permissions.permissions) {
            if (String.isBlank(permission.emailAddress)) {
                continue;
            }
            if (permissionsSet.contains(permission.emailAddress)) {
                permissionsToDelete.add(permission.id);
            }
        }
        for (String permissionId : permissionsToDelete) {
            ErrorResponse response = googleApi.deletePermission(file.id, permissionId);
            response.throwOnError();
        }
    }

    private File toFile(FileResponse response) {
        return new File(response.id, response.name, response.mimeType, response.webViewLink);
    }
}   