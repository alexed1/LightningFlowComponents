public class PermissionResponse extends ErrorResponse{

    public String kind;

    public String id;

    public String type;

    public String role;

    public String emailAddress;

	public static PermissionResponse parse(String json){
		return (PermissionResponse) System.JSON.deserialize(json, PermissionResponse.class);
	}
}
