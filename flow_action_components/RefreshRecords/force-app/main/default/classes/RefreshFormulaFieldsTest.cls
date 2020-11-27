@IsTest
public class RefreshFormulaFieldsTest {
    
    @TestSetup
    static void makeData(){
        insert new Lead(Email = 'email@email.com', LastName = 'Doe', Company = 'Business');
    }
    
    @isTest
    static void RefreshRecordsTest() {
        RefreshFormulaFields.Request request = new RefreshFormulaFields.Request();
        request.inputCollection = [SELECT Id,Email,LastName,Company FROM Lead];
        RefreshFormulaFields.refreshFormulas(new List<RefreshFormulaFields.Request>{request});
    }
}