@isTest
public class AddressTest {
    
    @isTest
    public static void ToString_SingleLetterColumn() {
        Address a = new Address();
        System.assertEquals('A1', a.toString());
    }

    @isTest
    public static void ToString_MultiLetterColumn() {
        Address a = new Address(26, 1);
        System.assertEquals('AA2', a.toString());
    }
}
