public interface IGoogleDrive {
    
    List<List<String>> getSpreadsheetData(String id, String sheetTitle);

    void saveSpreadsheetData(String id, String sheetTitle, List<CellValue> values);

    ClonedFile cloneFile(String id, String newName);

    File getFolder(String path, Boolean forceCreate);

    File getFile(String path, String mimeType);

    void renameFile(File file, String newName);

    void deleteFile(File file);

    File createSpreadsheet(String path); 

    void grantAccess(String path, List<String> emails, Boolean readonly);

    void revokeAccess(String path, List<String> emails);
}