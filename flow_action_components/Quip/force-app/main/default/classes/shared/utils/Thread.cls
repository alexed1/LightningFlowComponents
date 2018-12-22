public class Thread extends ThreadRef {
    public List<ThreadSheet> sheets;

    public String type;

    public String title;

    public String link;

    public String html;

    public String[] userIds;

    public String parentFolderId;

    public Thread(String id) {
        this(id, null, null, null, null, null, null);        
    }

    public Thread(String id, String type, String title, String link, String html, List<String> userIds, String parentFolderId) {
        super(id);
        this.type = type;
        this.title = title;
        this.link = link;
        this.html = html;
        this.userIds = userIds == null ? new List<String>() : userIds;
        this.parentFolderId = parentFolderId;
        sheets = new List<ThreadSheet>();
    }
}
