@IsTest
public class RecalculateFormulasTest {
    
    @TestSetup
    static void makeData(){
        insert new Lead(Email = 'email@email.com', LastName = 'Doe', Company = 'Business');
    }
    
    @isTest
    static void RefreshRecordsTest() {
        RecalculateFormulas.Input input = new RecalculateFormulas.Input();
        input.inputCollection = [SELECT Id,Email,LastName,Company FROM Lead];
        RecalculateFormulas.refreshFormulas(new List<RecalculateFormulas.Input>{input});
    }
}