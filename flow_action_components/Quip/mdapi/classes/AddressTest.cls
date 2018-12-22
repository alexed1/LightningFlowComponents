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

    @isTest
    public static void Parse_NullForEmptyString() {
        Address a = Address.parse('');
        System.assertEquals(null, a);
    }

    @isTest
    public static void Parse_ThrowsExceptionWhenNoColumn() {
        try {
            Address a = Address.parse('123');
            System.assert(false, 'Must throw exception');
        }
        catch (QuipException ex) {
            System.assertEquals('Address "123" doesn\'t contain column part', ex.getMessage());
        }
    }

    @isTest
    public static void Parse_ThrowsExceptionWhenNoRow() {
        try {
            Address a = Address.parse('AA');
            System.assert(false, 'Must throw exception');
        }
        catch (QuipException ex) {
            System.assertEquals('Address "AA" doesn\'t contain row part', ex.getMessage());
        }
    }
}