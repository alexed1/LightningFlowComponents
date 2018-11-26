public class Thread {
    public List<ThreadSheet> sheets;

    public String id;

    public String type;

    public String title;

    public String link;

    public String html;

    public Thread(String id) {
        this(id, null, null, null, null);        
    }

    public Thread(String id, String type, String title, String link, String html) {
        this.id = id;
        this.type = type;
        this.title = title;
        this.link = link;
        this.html = html;
        sheets = new List<ThreadSheet>();
    }
}
