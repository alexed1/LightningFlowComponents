public interface IQuip {
    
    Thread findThread(String idOrName);

    void saveSpreadsheetData(Thread thread, ThreadSheet sheet, List<ThreadCell> cellsToUpdate);

    Thread cloneThread(String idOrName, String copyName);

    Thread createThread(String title, String content, String type, String parentFolderId);

    Folder findFolder(String idOrName);

    Folder createFolder(String name, String parentFolderId);

    List<Folder> getFolders(List<String> foldersId);

    void grantAccess(String threadIdOrName, List<String> userIdsOrEmails);

    void revokeAccess(String threadIdOrName, List<String> userIdsOrEmails);

    Folder getFolderByPath(String path, Boolean createIfNotExists);

    void addDocumentToFolder(String threadIdOrName, String folderPath);

    void renameFolder(Folder folder, String newName);
}
