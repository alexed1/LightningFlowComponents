public class ThreadResponse extends Response {

    public Thread thread;
    public String html;

    public class Thread {
        public String id;
        public String type;
        public String title;
        public String link;
    }

    public static ThreadResponse parse(String json) {
        return (ThreadResponse)System.JSON.deserialize(json, ThreadResponse.class);
    }

    private static Thread parseThread(Map<String, Object> rawJson) {
        Thread result = new Thread();
        result.id = (String)rawJson.get('id');
        result.type = (String)rawJson.get('type');
        result.title = (String)rawJson.get('title');
        result.link = (String)rawJson.get('link');
        return result;
    }

    public static ThreadResponse parse(Map<String, Object> rawJson) {
        ThreadResponse result = new ThreadResponse();
        result.html = (String)rawJson.get('html');
        result.thread = ThreadResponse.parseThread((Map<String, Object>)rawJson.get('thread'));
        return result;
    }
}
