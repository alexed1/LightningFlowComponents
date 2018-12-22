public class UserListResponse extends Response {
    public UserListResponse() {
        users = new List<UserResponse>();
    }

    public List<UserResponse> users;

    public static UserListResponse parse(String json) {
        UserListResponse result = (UserListResponse)System.JSON.deserialize(json, UserListResponse.class);
        if (!result.isSuccess()) {
            return result;
        }
        result.users = new List<UserResponse>();
        Map<String, Object> deserializedJson = (Map<String, Object>)System.JSON.deserializeUntyped(json);
        for (String userId : deserializedJson.keySet()) {
            result.users.add(UserResponse.parse((Map<String, Object>)deserializedJson.get(userId)));
        }
        return result;
    }
}