public class UserResponse extends Response {

    public UserResponse() {
        shared_folder_ids = new List<String>();
        group_folder_ids = new List<String>();
    }
    
    public String id;
    public String desktop_folder_id;
    public String archive_folder_id;
    public String starred_folder_id;
    public String private_folder_id;
    public String[] shared_folder_ids;
    public String[] group_folder_ids;

    public static UserResponse parse(String json) {
        return (UserResponse)System.JSON.deserialize(json, UserResponse.class);
    }
}
