public class UserResponse extends Response {
    
    public String id;
    public String name;

    public static UserResponse parse(String json) {
        return (UserResponse)System.JSON.deserialize(json, UserResponse.class);
    }    

    public static UserResponse parse(Map<String, Object> rawJson) {
        UserResponse result = new UserResponse();
        result.id = (String)rawJson.get('id');
        result.name = (String)rawJson.get('name');
        return result;
    }
}
