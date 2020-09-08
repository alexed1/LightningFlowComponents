@isTest
public class RefreshRecordsTest {
    @TestSetup
    static void makeData(){
        insert new Lead(Email = 'email@email.com', LastName = 'Doe', Company = 'Business');
    }

    @isTest
    static void RefreshRecordsTest() {
        RefreshRecords.RefreshRecordsInput input = new RefreshRecords.RefreshRecordsInput();
        input.values = [SELECT Id FROM Lead];
        RefreshRecords.RefreshRecords(new List<RefreshRecords.RefreshRecordsInput>{input});
    }
}