public interface IQuipAPI {

    Boolean likeId(String id);

    UserResponse getCurrentUser();

    ThreadResponse getThread(String id);

    ThreadListResponse getThreadList(List<String> id);

    FolderResponse getFolder(String id);
}
