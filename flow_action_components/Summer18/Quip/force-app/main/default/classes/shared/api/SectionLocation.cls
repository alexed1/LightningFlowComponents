public class SectionLocation {

    private Integer value;

    private SectionLocation(Integer value) {
        this.value = value;
    }

    public Integer valueOf() {
        return value;
    }

    public static final SectionLocation AFTER_SECTION = new SectionLocation(2);

    public static final SectionLocation REPLACE_SECTION = new SectionLocation(4);
}