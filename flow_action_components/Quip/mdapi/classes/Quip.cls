public class Quip implements IQuip {
    
    private IQuipAPI quipApi;
    
    public Quip(IQuipAPI quipApi) {
        this.quipApi = quipApi;
    }

    private ThreadResponse findThreadByNameOrId(String nameOrId, Boolean isName) {
        CurrentUserResponse currentUser = quipApi.getCurrentUser();
        currentUser.ThrowOnError();
        Set<String> processedFolders = new Set<String>();
        List<String> folderQueue = new List<String>();
        for (String sharedFolder : currentUser.shared_folder_ids) {
            folderQueue.add(sharedFolder);
        }
        for (String groupFolder : currentUser.group_folder_ids) {
            folderQueue.add(groupFolder);
        }
        folderQueue.add(currentUser.archive_folder_id);
        folderQueue.add(currentUser.desktop_folder_id);
        folderQueue.add(currentUser.starred_folder_id);
        folderQueue.add(currentUser.private_folder_id);
        while (folderQueue.size() > 0) {
            String folderId = folderQueue.remove(folderQueue.size() - 1);
            if (String.isBlank(folderId)) {
                continue;
            }
            if (!processedFolders.add(folderId)) {
                //It means that this folder for some reason has been already processed
                continue;
            }
            FolderResponse folder = quipApi.getFolder(folderId);
            folder.throwOnError();
            List<String> threadIdList = new List<String>();
            for (FolderResponse.ThreadOrFolder child : folder.children) {
                if (child.isFolder()) {
                    folderQueue.add(child.folder_id);
                } else {
                    threadIdList.add(child.thread_id);
                }
            }
            if (threadIdList.size() > 0) {
                ThreadListResponse threads = quipApi.getThreadList(threadIdList);
                threads.throwOnError();
                for (ThreadResponse thread : threads.threads) {
                    if (isName) {
                        if (thread.thread.title == nameOrId) {
                            thread.folder_id = folderId;
                            return thread;
                        }
                    //No idea why, but all threads have two Ids (one in Id and one in the link) and you can access them by any of those
                    } else if (thread.thread.id == nameOrId || thread.thread.link.endsWith('/' + nameOrId)) {
                        thread.folder_id = folderId;
                        return thread;
                    }
                }
            }
        }
        //It means that we've looked through all the folders and didn't find a thread with this name
        return null;
    }

    private ThreadResponse findThreadByName(String name) {
        return findThreadByNameOrId(name, true);
    }

    private ThreadResponse findThreadById(String id) {
        return findThreadByNameOrId(id, false);
    }

    private static final Pattern tablePattern = Pattern.compile('(?s)<table.*?\\/table>');

    private Thread toThread(ThreadResponse response) {
        Thread result = new Thread(
            response.thread.id,
            response.thread.type,
            response.thread.title,
            response.thread.link,
            response.html,
            response.user_ids,
            response.folder_id
        );
        Matcher match = tablePattern.matcher(response.html);
        while (match.find()) {
            result.sheets.add(ThreadSheet.parseHtml(match.group()));
        }
        return result;
    }

    private ThreadResponse findThreadImpl(String idOrName) {
         if (String.isBlank(idOrName)) {
            throw new QuipException('Id or Name can\'t be blank');
        }
        ThreadResponse threadResponse = null;
        //If the value seems to be Id, we try to directly retrieve the thread with this Id
        if (quipApi.LikeId(idOrName)) {
            threadResponse = findThreadById(idOrName);
        }
        //If it is not Id for sure (e.g. contains spaces) or we didn't find a thread with this Id, we try to treat it as thread name
        if (threadResponse == null) {
            threadResponse = findThreadByName(idOrName);
        }
        if (threadResponse == null) {
            throw new QuipException('File "' + idOrName + '" doesn\'t exist');
        }        
        threadResponse.ThrowOnError();
        return threadResponse;
    }

    public Thread findThread(String idOrName) {
        ThreadResponse response = findThreadImpl(idOrName);
        return toThread(response);
    }

    public void saveSpreadsheetData(Thread thread, ThreadSheet sheet, List<ThreadCell> cellsToUpdate) {
        if (thread == null) {
            throw new QuipException('Thread is null');
        }
        if (sheet == null) {
            throw new QuipException('Sheet is null');
        }
        if (cellsToUpdate == null || cellsToUpdate.size() == 0) {
            return;
        }
        //It is very important to understand how exactly the update is performed
        //First of all, we can't just specify the address and the desired value. We need to make and update based on the known section Id.
        //E.g. we can pick a cell Id and tell Quip to put value before/after/instead of it. For this we need to get the Id of the cell 
        //Second, the quip sheet has a finite number of cells returned (e.g. by default its something like 50 x 16)
        //It means that there is no cell Id we could use to insert any values outside of this range
        //Third, Quip doesn't support multiple changes per request. Moreover, for every update request it respond with a new state of the sheet
        //Considering all these facts here is the approach I'm going to use:
        //1. We reparse the sheet after each response
        //2. If a row has to be extended, unfortunately, we can't do anything. Quip doesn't allow to add new cells to the existings rows
        //3. If a sheet has to be extended, we take the last row Id and add HTML after it (e.g. <tr></tr><tr></tr><tr><td>New Value</td></tr>)
        for (ThreadCell cellToUpdate: cellsToUpdate) {
            SectionLocation location = SectionLocation.AFTER_SECTION;
            String sectionId = '';
            String value = '';
            //Updating existing cell
            if (!String.isBlank(cellToUpdate.id)) {
                location = SectionLocation.REPLACE_SECTION;
                sectionId = cellToUpdate.id;
                value = cellToUpdate.value;
            }
            else {
                //This is for the case where our previous update created new cells but still don't know their Id
                ThreadCell actualCellToUpdate = sheet.findCellByAddress(cellToUpdate.addr);
                if (!String.isBlank(actualCellToUpdate.id)) {
                    location = SectionLocation.REPLACE_SECTION;
                    sectionId = actualCellToUpdate.id;
                    value = cellToUpdate.value;
                }
                //Creating new row(s)
                else if (cellToUpdate.addr.column < sheet.rows[0].cells.size()) {
                    ThreadRow lastRow = sheet.rows[sheet.rows.size() - 1];
                    for (Integer row = sheet.rows.size() - 1; row < cellToUpdate.addr.row - 1; row++) {
                        value += '<tr></tr>';
                    }
                    value += '<tr>';
                    for (Integer col = 0; col < cellToUpdate.addr.column; col++) {
                        value += '<td></td>';
                    }
                    sectionId = lastRow.id;
                    value += '<td>' + cellToUpdate.value.escapeHtml4() + '</td></tr>';
                }
                //Can't expand existing row - throw exception
                else {
                    throw new QuipException('The cell "' + cellToUpdate.addr.toString() + '" doesn\'t belong to the spreadsheet. Add it manually and try again');
                }
            }
            
            //Sending request, parsing response and finding the sheet again
            ThreadResponse response = quipApi.editDocument(thread.id, value, sectionId, location);
            response.throwOnError();
            thread = toThread(response);
            for (ThreadSheet threadSheet : thread.sheets) {
                if (threadSheet.title == sheet.title) {
                    sheet = threadSheet;
                    break;
                }
            }
        }
    }

    public Thread cloneThread(String idOrName, String copyName) {
        Thread source = findThread(idOrName);
        List<String> usersAndFolders = new List<String>(source.userIds);
        usersAndFolders.add(source.parentFolderId);
        System.debug('Users and folders: ' + String.join(usersAndFolders, ','));
        ThreadResponse copy = quipApi.createDocument(copyName, source.html, source.type, usersAndFolders);
        copy.throwOnError();
        return toThread(copy);
    }

    public Thread createThread(String title, String content, String type, String parentFolderId) {
        ThreadResponse thread = quipApi.createDocument(title, content, type, new List<String> { parentFolderId });
        thread.throwOnError();
        return toThread(thread);
    }

    private Folder toFolder(FolderResponse response) {
        Folder result = new Folder(response.folder.id, response.folder.title);
        for (FolderResponse.ThreadOrFolder child : response.children) {
            if (child.isFolder()) {
                result.subFolders.add(new FolderRef(child.folder_id));
            } else {
                result.threads.add(new ThreadRef(child.thread_id));
            }
        }
        return result;
    }

    public Folder findFolder(String idOrName) {
        CurrentUserResponse currentUser = quipApi.getCurrentUser();
        currentUser.ThrowOnError();
        if (String.isBlank(idOrName)) {
            FolderResponse folder = quipApi.getFolder(currentUser.private_folder_id);
            folder.ThrowOnError();
            return toFolder(folder);
        }
        Set<String> processedFolders = new Set<String>();
        List<String> folderQueue = new List<String>();
        for (String sharedFolder : currentUser.shared_folder_ids) {
            folderQueue.add(sharedFolder);
        }
        for (String groupFolder : currentUser.group_folder_ids) {
            folderQueue.add(groupFolder);
        }
        folderQueue.add(currentUser.archive_folder_id);
        folderQueue.add(currentUser.desktop_folder_id);
        folderQueue.add(currentUser.starred_folder_id);
        folderQueue.add(currentUser.private_folder_id);
        while (folderQueue.size() > 0) {
            String folderId = folderQueue.remove(folderQueue.size() - 1);
            if (String.isBlank(folderId)) {
                continue;
            }
            if (!processedFolders.add(folderId)) {
                //It means that this folder for some reason has been already processed
                continue;
            }
            FolderResponse folder = quipApi.getFolder(folderId);
            folder.throwOnError();
            if (folder.folder.id == idOrName || folder.folder.title == idOrName) {
                return toFolder(folder);
            }
            for (FolderResponse.ThreadOrFolder child : folder.children) {
                if (child.isFolder()) {
                    folderQueue.add(child.folder_id);
                }
            }
        }
        return null;
    }
    
    public List<Folder> getFolders(List<String> foldersId) {
        if (foldersId.size() == 0) {
            return new List<Folder>();
        }
        FolderListResponse response = quipApi.getFolderList(foldersId);
        response.throwOnError();
        List<Folder> result = new List<Folder>();
        for (FolderResponse folderResponse : response.folders) {
            result.add(toFolder(folderResponse));
        }
        return result;
    }

    public Folder createFolder(String name, String parentFolderId) {
        FolderResponse folder = quipApi.createFolder(name, parentFolderId);
        folder.throwOnError();
        return toFolder(folder);
    }

    public void grantAccess(String threadIdOrName, List<String> userIdsOrEmails) {
        if (userIdsOrEmails == null || userIdsOrEmails.size() == 0) {
            return;
        }
        ThreadResponse thread = quipApi.getThread(threadIdOrName);
        if (!thread.isSuccess()) {
            thread = findThreadByName(threadIdOrName);
        }
        UserListResponse userList = quipApi.getUsers(userIdsOrEmails);
        userList.throwOnError();
        List<String> userIds = new List<String>();
        for (UserResponse user : userList.users) {
            userIds.add(user.id);
        }
        Response response = quipApi.addMembers(thread.thread.id, userIds);
        response.throwOnError();
    }

    public void revokeAccess(String threadIdOrName, List<String> userIdsOrEmails) {
        if (userIdsOrEmails == null || userIdsOrEmails.size() == 0) {
            return;
        }
        ThreadResponse thread = quipApi.getThread(threadIdOrName);
        if (!thread.isSuccess()) {
            thread = findThreadByName(threadIdOrName);
        }
        UserListResponse userList = quipApi.getUsers(userIdsOrEmails);
        userList.throwOnError();
        List<String> userIds = new List<String>();
        for (UserResponse user : userList.users) {
            userIds.add(user.id);
        }
        Response response = quipApi.removeMembers(thread.thread.id, userIds);
        response.throwOnError();
    }

    public Folder getFolderByPath(String path, Boolean createIfNotExists) {
        //If no path is provided then we return private folder
        Folder folder = findFolder(null);
        if (String.isBlank(path)) {
            return folder;
        }
        List<String> folderNames = path.trim().split('[\\\\\\/]');
        for (String folderName : folderNames) {
            if (String.isBlank(folderName)) {
                continue;
            }
            List<String> subFoldersId = new List<String>();
            for (FolderRef subFolderRef : folder.subFolders) {
                subFoldersId.add(subFolderRef.id);
            }
            List<Folder> subFolders = getFolders(subFoldersId);
            Integer subFolderIndex = -1;
            for (Integer i = 0; i < subFolders.size(); i++) {
                if (subFolders[0].name == folderName) {
                    subFolderIndex = i;
                    break;
                }
            }
            //If subfolder already exists we take it
            if (subFolderIndex != -1) {
                folder = subFolders[subFolderIndex];
            }
            //otherwise we create a new subfolder 
            else if (createIfNotExists) {
                folder = createFolder(folderName, folder.id);
            } else {
                return null;
            }
        }
        return folder;
    }

    public void addDocumentToFolder(String threadIdOrName, String folderPath) {
        Folder folder = getFolderByPath(folderPath, true);
        ThreadResponse thread = findThreadImpl(threadIdOrName);
        Response response = quipApi.addMembers(thread.Thread.id, new List<String> { folder.id });
        response.throwOnError();
    }

    public void renameFolder(Folder folder, String newName) {
        if (String.isBlank(newName)) {
            throw new QuipException('Can\'t give an empty name to a folder');
        }
        Response response = quipApi.editFolder(folder.id, newName);
        response.throwOnError();
    }
}
