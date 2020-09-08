@isTest
public class RefreshRecordsActionTest {
    @TestSetup
    static void makeData(){
        insert new Lead(Email = 'email@email.com', LastName = 'Doe', Company = 'Business');
    }

    @isTest
    static void RefreshRecordsTest() {
        RefreshRecordsAction.RefreshRecordsInput input = new RefreshRecordsAction.RefreshRecordsInput();
        input.values = [SELECT Id FROM Lead];
        RefreshRecordsAction.RefreshRecords(new List<RefreshRecordsAction.RefreshRecordsInput>{input});
    }
}