public class File {

    public String id;

    public String name;

    public String mimeType;

    public String webViewLink;

    public File(String id, String name, String mimeType, String webViewUrl) {
        this.id = id;
        this.name = name;
        this.mimeType = mimeType;
        this.webViewLink = webViewUrl;
    }

    public File(String id) {
        this(id, null, null, null);
    }
}
