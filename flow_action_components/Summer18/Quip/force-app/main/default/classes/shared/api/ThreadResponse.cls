public class ThreadResponse extends Response {

    public Thread thread;
    public String html;

    public class Thread {
        public String thread_class;
        public String id;
        public String type;
        public String title;

        public Boolean isSpreadsheet() {
            return thread_class == 'spreadsheet';
        }
    }

    public static ThreadResponse parse(String json) {
        return (ThreadResponse)System.JSON.deserialize(json, ThreadResponse.class);
    }

    private static Thread parseThread(Map<String, Object> rawJson) {
        Thread result = new Thread();
        result.thread_class = rawJson.get('thread_class').toString();
        result.id = rawJson.get('id').toString();
        result.type = rawJson.get('type').toString();
        result.title = rawJson.get('title').toString();
        return result;
    }

    public static ThreadResponse parse(Map<String, Object> rawJson) {
        ThreadResponse result = new ThreadResponse();
        result.html = rawJson.get('html').toString();
        result.thread = ThreadResponse.parseThread((Map<String, Object>)rawJson.get('thread'));
        return result;
    }
}
