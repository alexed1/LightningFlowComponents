@isTest
public class DirectionUtilsTest {
    
    @isTest
    public static void parse_ReturnsValue() {
        Direction dir = DirectionUtils.parse('below');
        System.assertEquals(Direction.BELOW, dir);
    }

    @isTest
    public static void parse_FailsOnUnknownValue() {
        try {
            DirectionUtils.parse('fail');
            System.assert(false, 'Must fail');
        }
        catch (GoogleException ex) {
            System.assertEquals('"fail" is not valid', ex.getMessage());
        }
    }
}
