public class PermissionListResponse extends ErrorResponse {
    public PermissionListResponse() {
        permissions = new List<PermissionResponse>();
    }

    public PermissionResponse[] permissions;

	public static PermissionListResponse parse(String json){
		return (PermissionListResponse) System.JSON.deserialize(json, PermissionListResponse.class);
	}
}
