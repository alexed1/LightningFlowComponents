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
        Thread result = new Thread();
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
            threadResponse = quipApi.GetThread(idOrName);
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
}
