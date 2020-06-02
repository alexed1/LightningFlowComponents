@isTest
private class AddQuotesToFieldsTest {
	@isTest
    private static void testAddSingleQuote() {
        AddQuotesToFields.Input input = new AddQuotesToFields.Input();
        input.fieldCollection = new List<String>{'Apple', 'Banana', 'Orange'};
       	List<AddQuotesToFields.Output> output = AddQuotesToFields.addQuotesToFields(new List<AddQuotesToFields.Input>{input});
       	System.assertEquals('\'Apple\',\'Banana\',\'Orange\'', output[0].fieldString);
    }
    
    @isTest
    private static void testAddDoubleQuote() {
        AddQuotesToFields.Input input = new AddQuotesToFields.Input();
        input.fieldCollection = new List<String>{'Apple', 'Banana', 'Orange'};
        input.quoteType = 'DOUBLE';
       	List<AddQuotesToFields.Output> output = AddQuotesToFields.addQuotesToFields(new List<AddQuotesToFields.Input>{input});
       	System.assertEquals('"Apple","Banana","Orange"', output[0].fieldString);
    }
    
}