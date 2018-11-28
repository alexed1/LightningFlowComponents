public interface IQuip {
    
    Thread findThread(String idOrName);

    void saveSpreadsheetData(Thread thread, ThreadSheet sheet, List<ThreadCell> cellsToUpdate);

    Thread cloneThread(String idOrName, String copyName);
}
