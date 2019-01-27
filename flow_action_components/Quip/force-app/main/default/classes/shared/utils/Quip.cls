public class Quip implements IQuip {
    
    private IQuipAPI quipApi;
    
    public Quip(IQuipAPI quipApi) {
        this.quipApi = quipApi; 
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
        Boolean isPath = idOrName.containsAny('\\/');
        if (isPath) {
            return findFolderByPath(idOrName, null, false);
        }

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
        Thread thread = findThread(threadIdOrName);
        UserListResponse userList = quipApi.getUsers(userIdsOrEmails);
        userList.throwOnError();
        List<String> userIds = new List<String>();
        for (UserResponse user : userList.users) {
            userIds.add(user.id);
        }
        Response response = quipApi.addMembers(thread.id, userIds);
        response.throwOnError();
    }

    public void revokeAccess(String threadIdOrName, List<String> userIdsOrEmails) {
        if (userIdsOrEmails == null || userIdsOrEmails.size() == 0) {
            return;
        }
        Thread thread = findThread(threadIdOrName);
        UserListResponse userList = quipApi.getUsers(userIdsOrEmails);
        userList.throwOnError();
        List<String> userIds = new List<String>();
        for (UserResponse user : userList.users) {
            userIds.add(user.id);
        }
        Response response = quipApi.removeMembers(thread.id, userIds);
        response.throwOnError();
    }

    public void addDocumentToFolder(String threadIdOrName, String folderPath) {
        Folder folder = findFolderByPath(folderPath, null, true);
        Thread thread = findThread(threadIdOrName);
        Response response = quipApi.addMembers(thread.id, new List<String> { folder.id });
        response.throwOnError();
    }

    public void renameFolder(Folder folder, String newName) {
        if (String.isBlank(newName)) {
            throw new QuipException('Can\'t give an empty name to a folder');
        }
        Response response = quipApi.editFolder(folder.id, newName);
        response.throwOnError();
    }

    public Folder getFolderByPath(String path, Boolean createIfNotExists) {
        return findFolderByPath(path, null, createIfNotExists);
    }

    private Folder getFolder(String name, Folder parentFolder) {
        //Looking among root folders
        if (parentFolder == null) {
            CurrentUserResponse currentUser = quipApi.getCurrentUser();
            currentUser.throwOnError();
            if (String.isBlank(name)) {
                FolderResponse folder = quipApi.getFolder(currentUser.private_folder_id);
                return toFolder(folder);
            }
            System.debug('Looking for the folder ' + name + ' among the root folders');
            Set<String> foldersIds = new Set<String>();
            foldersIds.add(currentUser.private_folder_id);
            for (String sharedFolder : currentUser.shared_folder_ids) {
                foldersIds.add(sharedFolder);
            }
            for (String groupFolder : currentUser.group_folder_ids) {
                foldersIds.add(groupFolder);
            }
            FolderListResponse foldersResponse = quipApi.getFolderList(new List<String>(foldersIds));
            foldersResponse.throwOnError();
            List<Folder> result = new List<Folder>();
            List<String> rootFolderNames = new List<String>();
            for (FolderResponse folder : foldersResponse.folders) {
                if (folder.folder.title == name) {
                    return toFolder(folder);
                }
                rootFolderNames.add(folder.folder.title);
            }
            System.debug('Failed to find the root folder ' + name);
            System.debug('Only these root folders exist: ' + rootFolderNames);
            return null;
        }
        //Looking among subfolders of the specific folder
        if (parentFolder.subfolders.size() == 0) {
            System.debug('Folder '+ name + ' has no subfolder');
            return null;
        }
        System.debug('Looking for the folder ' + name + ' among the ' + parentFolder.subfolders.size() + ' subfolders of '+ parentFolder.name);
        List<String> subFolderIds = new List<String>();
        for (FolderRef subFolder : parentFolder.subFolders) {
            subFolderIds.add(subFolder.id);
        }
        FolderListResponse subFoldersResponse = quipApi.getFolderList(subFolderIds);
        subFoldersResponse.throwOnError();
        List<String> subFolderNames = new List<String>();
        for (FolderResponse folder : subFoldersResponse.folders) {
            if (folder.folder.title == name) {
                return toFolder(folder);
            }
            subFolderNames.add(folder.folder.title);
        }
        System.debug('Failed to find the subfolder ' + name);
        System.debug('Only these subfolders exist: ' + subFolderNames);
        return null;
    }

    private Folder findFolderByPath(String path, List<String> pathNames, Boolean createIfNotExists) {
        Folder privateFolder = getFolder(null, null);
        if (String.isBlank(path) && pathNames == null) {
            return privateFolder;
        }
        pathNames = pathNames != null ? pathNames : path.trim().split('[\\\\\\/]');
        Folder parentFolder = null;
        for (Integer i = 0; i < pathNames.size(); i++) {
            String folderName = pathNames[i].trim();
            if (String.isBlank(folderName)) {
                continue;
            }
            System.debug('Looking for ' + folderName + ' folder among ' + (parentFolder == null ? 'root folders' : parentFolder.name));
            Folder thisFolder = null;
            //If we search for the first folder in the path, we try to search it among the root folders first
            if (parentFolder == null) {
                thisFolder = getFolder(folderName, null);
                //If there is no root folder with a name like this, we try to search for it in user's private folder
                if (thisFolder == null) {
                    System.debug('Folder ' + folderName + ' was not found among root folders');
                    thisFolder = getFolder(folderName, privateFolder);
                }
            } else {
                thisFolder = getFolder(folderName, parentFolder);
            }
            if (thisFolder == null) {
                if (createIfNotExists) {
                    thisFolder = createFolder(folderName, parentFolder == null ? privateFolder.id : parentFolder.id);
                } else {
                    System.debug('Folder ' + folderName + ' was not found among children of ' + (parentFolder == null ? privateFolder.name : parentFolder.name));
                    return null;
                }
            }
            parentFolder = thisFolder;
        }
        return parentFolder;
    }

    private ThreadResponse findThreadByPath(String path) {
        System.debug('Looking for a thread by path: ' + path);
        List<String> pathNames = path.trim().split('[\\\\\\/]');
        String threadName = pathNames[pathNames.size() - 1].trim();
        if (String.isBlank(threadName)) {
            throw new QuipException('Can\'t use empty thread name in the path');
        }
        System.debug('Thread name should be: ' + threadName);
        pathNames.remove(pathNames.size() - 1);
        Folder parentFolder = findFolderByPath(null, pathNames, false);
        if (parentFolder == null) {
            System.debug('Couldn\'t find a folder for thread: ' + path);
            return null;
        }
        ThreadSearchResponse searchResponse = quipApi.searchThreads(threadName);
        searchResponse.throwOnError();
        System.debug('Found ' + searchResponse.threads.size() + ' threads');
        for (ThreadSearchResponse.SearchResult thread : searchResponse.threads) {
            System.debug('Found thread with the name ' + thread.thread.title + ' while looking for a thread ' + path);
            if (thread.thread.title == threadName) {
                ThreadResponse result = quipApi.getThread(thread.thread.id);
                result.throwOnError();
                result.folder_id = parentFolder.id;
                return result;
            }
        }
        return null;
    }

    private ThreadResponse findThreadByName(String name) {
        ThreadSearchResponse searchResponse = quipApi.searchThreads(name);
        searchResponse.throwOnError();
        for (ThreadSearchResponse.SearchResult thread : searchResponse.threads) {
            if (thread.thread.title == name) {
                ThreadResponse result = quipApi.getThread(thread.thread.id);
                result.throwOnError();
                return result;
            }
        }
        return null;
    }

    private ThreadResponse findThreadById(String id) {
        ThreadResponse threadResponse = quipApi.getThread(id);
        if (threadResponse.isSuccess()) {
            return threadResponse;
        }
        //If file is not found, it is expected failure, so we'll just try to get thread by name
        if (threadResponse.error_code != 404 && threadResponse.error_code != 400) {
            threadResponse.throwOnError();
        }
        return null;
    }

    private Folder findParentFolderByThreadId(String id) {
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
            for (FolderResponse.ThreadOrFolder child : folder.children) {
                if (child.thread_id == id) {
                    return toFolder(folder);
                }
                if (child.isFolder()) {
                    folderQueue.add(child.folder_id);
                }
            }
        }
        throw new QuipException('Failed to find parent folder of the thread with Id ' + id);
    }

    private ThreadResponse findThreadImpl(String idOrName) {
        //If the value seems to be Id, we try to directly retrieve the thread with this Id
        //Even though we can get thread by id directly, we still have to find it in folder tree (otherwise we are not aware of the exact location of this file)
        ThreadResponse threadResponse = null;
        if (quipApi.LikeId(idOrName)) {
            threadResponse = findThreadById(idOrName);
            if (threadResponse != null) {
                return threadResponse;
            }
            //otherwise we'll fail gracefully
        }
        //If it is not Id for sure (e.g. contains spaces) or we didn't find a thread with this Id, we try to treat it as thread name
        if (threadResponse == null) {
            threadResponse = findThreadByName(idOrName);
        }        
        if (threadResponse == null) {
            throw new QuipException('File "' + idOrName + '" doesn\'t exist');
        }
        return threadResponse;
    }

    public Thread findThread(String idOrName) {
        if (String.isBlank(idOrName)) {
            throw new QuipException('Id or name can\'t be empty');
        }
        ThreadResponse threadResponse = null;
        Boolean isPath = idOrName.containsAny('\\/');
        if (isPath) {
            threadResponse = findThreadByPath(idOrName);
            if (threadResponse == null) {
                throw new QuipException('File "' + idOrName + '" doesn\'t exist');
            }
            return toThread(threadResponse);
        }
        threadResponse = findThreadImpl(idOrName);
        threadResponse.folder_id = findParentFolderByThreadId(threadResponse.thread.id).id;
        return toThread(threadResponse);
    }
}
