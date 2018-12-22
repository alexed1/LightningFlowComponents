public class FolderResponse extends Response {

    public Folder folder;
    public List<ThreadOrFolder> children;

    public class Folder {
        public String title;
        public String id;
    }

    public class ThreadOrFolder {
        public String thread_id;
        public String folder_id;

        public Boolean isFolder() {
            return !String.isBlank(folder_id);
        }
    }

    public FolderResponse() {
        children = new List<ThreadOrFolder>();
    }

    public static FolderResponse parse(String json) {
        return (FolderResponse)System.JSON.deserialize(json, FolderResponse.class);
    }    

    private static Folder parseFolder(Map<String, Object> rawJson) {
        Folder result = new Folder();
        result.title = rawJson.get('title').toString();
        result.id = rawJson.get('id').toString();
        return result;
    }

    private static ThreadOrFolder parseThreadOrFolder(Map<String, Object> rawJson) {
        ThreadOrFolder result = new ThreadOrFolder();
        result.thread_id = (String)rawJson.get('thread_id');
        result.folder_id = (String)rawJson.get('folder_id');
        return result;
    }

    public static FolderResponse parse(Map<String, Object> rawJson) {
        FolderResponse result = new FolderResponse();
        result.folder = FolderResponse.parseFolder((Map<String, Object>)rawJson.get('folder'));
        List<Object> children = (List<Object>)rawJson.get('children');
        for (Object child : children) {
            result.children.add(FolderResponse.parseThreadOrFolder((Map<String,Object>)child));
        }       
        return result;
    }
}