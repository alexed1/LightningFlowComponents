public interface IGoogleDrive {
    
    String FindFileIdByName(String name);

    String FindFileIdByName(String name, String fileType); 

    List<List<String>> GetSpreadsheetData(String id);

    void SaveSpreadsheetData(String id, List<CellValue> values);
}
