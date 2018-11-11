public class CellValue {

    public Address addr;

    public String value;

    public CellValue(Address addr, String value) {
        this.addr = addr;
        this.value = value;
    }

    public CellValue(String addr, String value) {
        this.addr = Address.parse(addr);
        this.value = value;
    }
}
