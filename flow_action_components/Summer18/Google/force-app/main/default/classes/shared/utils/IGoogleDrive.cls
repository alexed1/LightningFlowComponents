public interface IGoogleDrive {
    
    String findFileIdByName(String name);

    String findFileIdByName(String name, String fileType); 

    List<List<String>> getSpreadsheetData(String id, String sheetTitle);

    void saveSpreadsheetData(String id, String sheetTitle, List<CellValue> values);

    ClonedFile cloneFile(String id, String newName);
}