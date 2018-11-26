public class Thread {
    public List<ThreadSheet> sheets;

    public String id;

    public Thread(String id) {
        this.id = id; 
        sheets = new List<ThreadSheet>();
    }
}
