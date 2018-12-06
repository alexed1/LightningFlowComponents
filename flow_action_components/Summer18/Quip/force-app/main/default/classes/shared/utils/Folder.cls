public class Folder extends FolderRef {

    public String name;

    public List<FolderRef> subFolders;

    public List<ThreadRef> threads;

    public Folder(String id, String name) {
        super(id);
        this.name = name;
        subFolders = new List<FolderRef>();
        threads = new List<ThreadRef>();
    }
}
