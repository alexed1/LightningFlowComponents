public class Quip implements IQuip {
    
    private IQuipAPI quipApi;
    
    public Quip(IQuipAPI quipApi) {
        this.quipApi = quipApi;
    }

    private ThreadResponse findThreadByName(String name) {
        UserResponse currentUser = quipApi.getCurrentUser();
        currentUser.ThrowOnError();
        Set<String> processedFolders = new Set<String>();
        List<String> folderQueue = new List<String>();
        folderQueue.add(currentUser.starred_folder_id);
        folderQueue.add(currentUser.desktop_folder_id);
        folderQueue.add(currentUser.private_folder_id);
        for (String sharedFolder : currentUser.shared_folder_ids) {
            folderQueue.add(sharedFolder);
        }
        for (String groupFolder : currentUser.group_folder_ids) {
            folderQueue.add(groupFolder);
        }
        folderQueue.add(currentUser.archive_folder_id);
        while (folderQueue.size() > 0) {
            String folderId = folderQueue.remove(0);
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
                    if (thread.thread.title == name) {
                        return thread;
                    }
                }
            }
        }
        //It means that we've looked through all the folders and didn't find a thread with this name
        return null;
    }

    private static final Pattern tablePattern = Pattern.compile('(?s)<table.*?\\/table>');

    private Thread toThread(ThreadResponse response) {
        Thread result = new Thread(response.thread.id);
        Matcher match = tablePattern.matcher(response.html);
        while (match.find()) {
            result.sheets.add(ThreadSheet.parseHtml(match.group()));
        }
        return result;
    }

    public Thread findThread(String idOrName) {
        if (String.isBlank(idOrName)) {
            throw new QuipException('Id or Name can\'t be blank');
        }
        ThreadResponse threadResponse = null;
        //If the value seems to be Id, we try to directly retrieve the thread with this Id
        if (quipApi.LikeId(idOrName)) {
            threadResponse = quipApi.getThread(idOrName);
        }
        //If it is not Id for sure (e.g. contains spaces) or we didn't find a thread with this Id, we try to treat it as thread name
        if (threadResponse == null || threadResponse.error_code == 400 || threadResponse.error_code == 404) {
            threadResponse = findThreadByName(idOrName);
            if (threadResponse == null) {
                throw new QuipException('File "' + idOrName + '" doesn\'t exist');
            }
        }
        threadResponse.ThrowOnError();
        return toThread(threadResponse);
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
            //Creating new row(s)
            else if (cellToUpdate.addr.column < sheet.rows[0].cells.size()) {
                ThreadRow lastRow = sheet.rows[sheet.rows.size() - 1];
                for (Integer row = sheet.rows.size() - 1; row < cellToUpdate.addr.row - 1; row++) {
                    value += '<tr></tr>';
                }
                value += '<tr>';
                for (Integer col = 0; col < cellToUpdate.addr.column - 1; col++) {
                    value += '<td></td>';
                }
                sectionId = lastRow.id;
                value += '<td>' + cellToUpdate.value.escapeHtml4() + '</td></tr>';
            }
            //Can't expand existing row - throw exception
            else {
                throw new QuipException('The cell "' + cellToUpdate.addr.toString() + '" doesn\'t belong to the spreadsheet. Add it manually and try again');
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
}
