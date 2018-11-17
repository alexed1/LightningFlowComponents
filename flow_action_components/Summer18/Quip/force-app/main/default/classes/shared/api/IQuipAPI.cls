public interface IQuipAPI {

    UserResponse GetCurrentUser();

    ThreadResponse GetThread(String id);

    ThreadListResponse GetThreadList(List<String> id);

    FolderResponse GetFolder(String id);

    FolderListResponse GetFolderList(List<String> id);
}
