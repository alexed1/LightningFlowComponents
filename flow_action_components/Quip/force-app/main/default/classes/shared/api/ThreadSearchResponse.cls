public with sharing class ThreadSearchResponse extends Response {

    public ThreadSearchResponse() {
        threads = new List<ThreadSearchResponse.SearchResult>();
    }
    
    public List<ThreadSearchResponse.SearchResult> threads;

    public class Thread {
        public String id;
        public String title;
    }

    public class SearchResult {
        public Thread thread;
    }
}
