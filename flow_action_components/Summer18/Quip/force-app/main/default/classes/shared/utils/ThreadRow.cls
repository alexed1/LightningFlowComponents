public class ThreadRow {

    public String id;

    public List<ThreadCell> cells;

    public ThreadRow(String id) {
        this.id = id;
        cells = new List<ThreadCell>();
    }
}
