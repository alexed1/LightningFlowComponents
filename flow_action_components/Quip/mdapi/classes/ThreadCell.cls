public class ThreadCell {

    public String id;

    public String value;

    public Address addr;

    public ThreadCell(Address addr, String id, String value) {
        this.addr = addr;
        this.id = id;
        this.value = value;
    }
}