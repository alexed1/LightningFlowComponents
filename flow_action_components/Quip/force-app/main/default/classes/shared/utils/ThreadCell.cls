public class ThreadCell {

    public String id;

    public String value;

    public Address addr;

    //public Boolean valueTypeIsCheckbox;

    public ThreadCell(Address addr, String id, String value) {
        this.addr = addr;
        this.id = id;
        this.value = value;
    }

    public static final String TRUE_CHECK_BOX = '☑';

    public static final String FALSE_CHECK_BOX = '☐';

    //public Boolean isCheckbox() {
    //    return value == TRUE_CHECK_BOX || value == FALSE_CHECK_BOX;
    //}
}