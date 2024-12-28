@isTest
public class CheckBlankFieldsTest {

    static testMethod void testCheckBlankFields() {
        // Create an account with some blank fields
        Account acct = new Account(Name='Test Account', Industry='');
        insert acct;
        // Update Industry to be blank
        acct.Industry = '';
        update acct;
        // Create the input object
        CheckBlankFields.Input input = new CheckBlankFields.Input();
        input.record = acct;
        input.fieldApiNames = 'Industry';
        // Create a list of inputs
        List<CheckBlankFields.Input> inputList = new List<CheckBlankFields.Input>();
        inputList.add(input);
        // Call the checkBlankFields method
        List<CheckBlankFields.Output> outputList = CheckBlankFields.checkBlankFields(inputList);
        // Verify the output
        System.assertEquals(1, outputList.size());
        CheckBlankFields.Output output = outputList.get(0);
        System.assertEquals('Industry', output.blankFieldsListString, 'Expected: Industry, Actual: ' + output.blankFieldsListString);

    }

}