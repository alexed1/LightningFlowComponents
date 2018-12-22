public class FileResponse extends ErrorResponse {
    public String id;

    public String name;

    public String mimeType;

    public String webViewLink;

    public String[] parents;

    public Boolean trashed;

	public static FileResponse parse(String json){
		return (FileResponse) System.JSON.deserialize(json, FileResponse.class);
	}
}
