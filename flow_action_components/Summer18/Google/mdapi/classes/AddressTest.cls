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
        catch (GoogleException ex) {
            //Expected scenario
        }
    }

    @isTest
    public static void Parse_ThrowsExceptionWhenNoRow() {
        try {
            Address a = Address.parse('AA');
            System.assert(false, 'Must throw exception');
        }
        catch (GoogleException ex) {
            System.assertEquals('Address "AA" doesn\'t contain row part', ex.getMessage());
        }
    }

    @isTest
    public static void Equals_VerifySuccess() {
        Set<Address> result = new Set<Address>();
        result.add(new Address(1, 1));
        System.assert(result.contains(new Address(1, 1)));
        System.assert(!result.contains(new Address(2, 1)));
    }
}
