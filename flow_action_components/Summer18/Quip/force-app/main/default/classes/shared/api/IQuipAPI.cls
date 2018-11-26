public interface IQuipAPI {

    Boolean likeId(String id);

    UserResponse getCurrentUser();

    ThreadResponse getThread(String id);

    ThreadListResponse getThreadList(List<String> id);

    FolderResponse getFolder(String id);

    ThreadResponse editDocument(String threadId, String content, String sectionId, SectionLocation location); 

    ThreadResponse createDocument(String title, String content, String type);
}
