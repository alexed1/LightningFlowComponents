public interface IQuipAPI {

    Boolean likeId(String id);

    CurrentUserResponse getCurrentUser();

    ThreadResponse getThread(String id); 

    ThreadListResponse getThreadList(List<String> id);

    FolderResponse getFolder(String id);

    FolderListResponse getFolderList(List<String> id);

    ThreadResponse editDocument(String threadId, String content, String sectionId, SectionLocation location); 

    ThreadResponse createDocument(String title, String content, String type,  List<String> usersAndFolders);

    FolderResponse createFolder(String title, String parentId);

    Response addMembers(String threadId, List<String> usersAndFolders);

    Response removeMembers(String threadId, List<String> usersAndFolders);

    Response editFolder(String folderId, String newName);

    UserListResponse getUsers(List<String> idsOrEmails);

    ThreadSearchResponse searchThreads(String name);
}