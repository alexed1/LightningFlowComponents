public class FolderListResponse extends Response {
    public FolderListResponse() {
        folders = new List<FolderResponse>();
    }

    public List<FolderResponse> folders;

    public static FolderListResponse parse(String json) {
        FolderListResponse result = (FolderListResponse)System.JSON.deserialize(json, FolderListResponse.class);
        if (!result.isSuccess()) {
            return result;
        }
        result.folders = new List<FolderResponse>();
        Map<String, Object> deserializedJson = (Map<String, Object>)System.JSON.deserializeUntyped(json);
        for (String folderId : deserializedJson.keySet()) {
            result.folders.add(FolderResponse.parse((Map<String, Object>)deserializedJson.get(folderId)));
        }
        return result;
    }
}
