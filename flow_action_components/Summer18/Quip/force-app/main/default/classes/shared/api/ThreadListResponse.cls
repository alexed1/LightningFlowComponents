public class ThreadListResponse extends Response {
    public ThreadListResponse() {
        threads = new List<ThreadResponse>();
    }

    public List<ThreadResponse> threads;

    public static ThreadListResponse parse(String json) {
        ThreadListResponse result = (ThreadListResponse)System.JSON.deserialize(json, ThreadListResponse.class);
        if (!result.isSuccess()) {
            return result;
        }
        result.threads = new List<ThreadResponse>();
        Map<String, Object> deserializedJson = (Map<String, Object>)System.JSON.deserializeUntyped(json);
        for (String threadId : deserializedJson.keySet()) {
            result.threads.add(ThreadResponse.parse((Map<String, Object>)deserializedJson.get(threadId)));
        }
        return result;
    }
}
