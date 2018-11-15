public class DriveFilesCopyResponse extends ErrorResponse {
    
    public String id;
    public String name;
    public String mimeType;
    public String webViewLink;

	public static DriveFilesCopyResponse parse(String json){
		return (DriveFilesCopyResponse) System.JSON.deserialize(json, DriveFilesCopyResponse.class);
	}
}
